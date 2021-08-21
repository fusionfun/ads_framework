import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:ads_framework/utils/ads_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_analytics/flutter_analytics.dart';

import 'package:flutter_utils/datetime/datetime_utils.dart';
import 'package:flutter_utils/extensions/extensions.dart';
import 'package:flutter_utils/hash/hash.dart';
import 'package:flutter_utils/logger/log_utils.dart';

part 'banner/banner_ads.dart';

part 'banner/banner_ads_handler.dart';

part 'handler/ads_audit.dart';

part 'handler/ads_handler.dart';

part 'handler/ads_reload.dart';

part 'interstitial/interstitial_ads.dart';

part 'interstitial/interstitial_ads_handler.dart';

part 'rewards/rewarded_ads.dart';

part 'rewards/rewarded_ads_handler.dart';

/// Created by Haoyi on 5/6/21

abstract class Ads<T> {
  Map<T, AdsEvent> get eventsMapping;

  final Map<String, String> properties = <String, String>{};

  // final StreamController<AdsMsg> adsMsgStreamController = StreamController.broadcast();

  final List<AdsHandler> handlers = [];

  AdUnitId get adUnitId;

  final Map<AdsEvent, void Function(AdsHandler, AdsEventPayload)> _handlerMap = {
    AdsEvents.OnAdLoaded: (handler, adsMsg) {
      handler.onAdLoaded(adsMsg);
    },
    AdsEvents.OnAdLoadFailed: (handler, adsMsg) {
      handler.onAdLoadFailed(adsMsg);
    },
    AdsEvents.OnAdDisplayed: (handler, adsMsg) {
      handler.onAdDisplayed(adsMsg);
    },
    AdsEvents.OnAdDisplayFailed: (handler, adsMsg) {
      handler.onAdDisplayFailed(adsMsg);
    },
    AdsEvents.OnAdClicked: (handler, adsMsg) {
      handler.onAdClicked(adsMsg);
    },
    AdsEvents.OnAdHidden: (handler, adsMsg) {
      handler.onAdHidden(adsMsg);
    },
    AdsEvents.OnAdRewarded: (handler, adsMsg) {
      if (handler is RewardedAdsHandler) {
        handler.onAdRewarded(adsMsg);
      }
    },
    AdsEvents.Show: (handler, adsMsg) {
      handler.onRequestShow(adsMsg);
    },
    AdsEvents.Hide: (handler, adsMsg) {
      handler.onRequestHide(adsMsg);
    },
    AdsEvents.Dispose: (handler, adsMsg) {
      handler.onRequestDispose(adsMsg);
    },
    AdsEvents.Load: (handler, adsMsg) {
      handler.onRequestLoad(adsMsg);
    },
  };

  void addHandler(AdsHandler handler) {
    handlers.add(handler);
  }

  void setProperty(String name, String data) {
    properties[name] = data;
  }

  void dispatchEvent(T event, {Map<dynamic, dynamic> arguments = const <dynamic, dynamic>{}}) {
    print("#### dispatchEvent $event");
    final adsEvent = eventsMapping[event];
    if (adsEvent != null) {
      print("#### dispatchEvent2 $event");
      final adsMsg = obtainMsg(adsEvent, arguments: arguments);
      _notifyAdsEvent(adsMsg);
    }
  }

  void _notifyAdsEvent(AdsEventPayload adsMsg) {
    // adsMsgStreamController.addEx(adsMsg);
    handlers.forEach((handler) {
      _handlerMap[adsMsg.event]?.call(handler, adsMsg);
    });
  }

  AdsEventPayload obtainMsg(AdsEvent adsEvent, {Map<dynamic, dynamic> arguments = const <dynamic, dynamic>{}}) {
    return AdsEventPayload.wrap(this, adsEvent, arguments: arguments);
  }

  @mustCallSuper
  void dispose() {
    requestDispose();
    final msg = obtainMsg(AdsEvents.Dispose);
    _notifyAdsEvent(msg);

    // adsMsgStreamController.close();
    handlers.clear();
  }

  @mustCallSuper
  void init() {
    if (this is AdsAudit) {
      addHandler(AdsAuditHandler());
    }
    if (this is AdsReload) {
      addHandler(AdsReloadHandler());
    }
  }

  Future<bool> load() async {
    final msg = obtainMsg(AdsEvents.Load);
    _notifyAdsEvent(msg);
    return await requestLoad();
  }

  Future hide() async {
    final msg = obtainMsg(AdsEvents.Hide);
    _notifyAdsEvent(msg);
    await requestHide();
  }

  Future<bool> show({required String scene}) async {
    final result = await requestShow(scene: scene).catchError((error, stacktrace) {
      print("show error! $error, $stacktrace");
      return false;
    });
    final msg = obtainMsg(AdsEvents.Show, arguments: {"scene": scene, "result": result});
    _notifyAdsEvent(msg);
    return result;
  }

  Future<bool> requestShow({required String scene});

  Future<bool> requestHide();

  Future<bool> requestLoad();

  Future<bool> requestDispose();
}

class AdsEvent {
  final int type;
  final bool isAction;

  const AdsEvent.event(this.type) : isAction = false;

  const AdsEvent.action(this.type) : isAction = true;

  @override
  int get hashCode => hash2(type, isAction);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is AdsEvent) {
      return type == other.type && isAction == other.isAction;
    }
    return false;
  }

  @override
  String toString() {
    return 'AdsEvent{type: $type, isAction: $isAction}';
  }
}

class AdsEvents {
  static const OnAdLoaded = const AdsEvent.event(1);
  static const OnAdLoadFailed = const AdsEvent.event(2);
  static const OnAdDisplayed = const AdsEvent.event(3);
  static const OnAdDisplayFailed = const AdsEvent.event(4);
  static const OnAdClicked = const AdsEvent.event(5);
  static const OnAdHidden = const AdsEvent.event(6);
  static const OnAdRewarded = const AdsEvent.event(7);

  static const Show = const AdsEvent.action(101);
  static const Hide = const AdsEvent.action(102);
  static const Dispose = const AdsEvent.action(103);
  static const ShowFailed = const AdsEvent.action(104);
  static const Load = const AdsEvent.action(105);
}

class AdsEventPayload {
  final Ads ads;
  final AdsEvent event;
  final Map<dynamic, dynamic> arguments;

  AdsEventPayload.wrap(this.ads, this.event, {this.arguments = const <dynamic, dynamic>{}});
}

enum AdType { banner, interstitial, rewarded, none }

enum AdCause {
  success,
  displayFailed,
  loadFailed,
  requestFailed,
  disabledScene,
  invalidRequest,
  tooFrequent,
  canceled,
  internalError,
  rewardedFailed,
  unknownError,
  noAds
}

class AdsResult {
  final AdType type;
  final AdCause cause;
  final dynamic? internalCause;

  factory AdsResult.success(AdType type) => AdsResult.build(type, AdCause.success);

  @override
  String toString() {
    return 'AdsResult{type: $type, cause: $cause, internalCause: $internalCause}';
  }

  AdsResult.build(this.type, this.cause, {this.internalCause});
}

class AdScene {
  static const gameNew = "game_new";
  static const gameReplay = "game_replay";
  static const gameWin = "game_win";
  static const jokerUnlock = "joker_unlock";
  static const getCoins = "get_coins";
  static const theme = "theme";
  static const bgUnlock = "bg_unlock";
  static const cbUnlock = "cb_unlock";
  static const cfUnlock = "cf_unlock";
}

class AdNetwork {
  static const Mopub = "Mopub";
  static const AdManager = "AdManager";
  static const Admob = "Admob";
  static const FAN = "FAN";
  static const Unity = "Unity";
  static const Fyber = "Fyber";
  static const IronSource = "IronSource";
  static const Verizon = "Verizon";
  static const Amazon = "Amazon";
  static const Pangle = "Pangle";
  static const Applovin = "Applovin";
}

class AdFormat {
  static const Banner = "Banner";
  static const Interstitial = "Interstitial";
  static const Rewarded = "Rewarded";
}

class AdAppId {
  final String android;
  final String ios;

  const AdAppId({required this.android, required this.ios});

  @override
  String toString() {
    return 'AdAppId{$id}';
  }

  String get id {
    if (Platform.isAndroid) {
      return android;
    } else if (Platform.isIOS) {
      return ios;
    }
    return android;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AdUnitId && runtimeType == other.runtimeType && android == other.android && ios == other.ios;

  @override
  int get hashCode => android.hashCode ^ ios.hashCode;
}

class AdUnitId {
  final String android;
  final String ios;

  const AdUnitId({required this.android, required this.ios});

  @override
  String toString() {
    return 'AdUnitId{$id}';
  }

  String get id {
    if (Platform.isAndroid) {
      return android;
    } else if (Platform.isIOS) {
      return ios;
    }
    return android;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AdUnitId && runtimeType == other.runtimeType && android == other.android && ios == other.ios;

  @override
  int get hashCode => android.hashCode ^ ios.hashCode;
}

class AdSlotId {
  final String android;
  final String ios;

  const AdSlotId({required this.android, required this.ios});

  @override
  String toString() {
    return 'AdSlotId{$id}';
  }

  String get id {
    if (Platform.isAndroid) {
      return android;
    } else if (Platform.isIOS) {
      return ios;
    }
    return android;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AdUnitId && runtimeType == other.runtimeType && android == other.android && ios == other.ios;

  @override
  int get hashCode => android.hashCode ^ ios.hashCode;
}

class AdsEnv {

}
