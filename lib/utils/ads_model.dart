import 'dart:io';

/// Created by @RealCradle on 2021/8/21
///
///

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
