/// Created by Haoyi on 5/7/21

part of '../ads.dart';

mixin AdsAudit<T> on Ads<T> {
  bool get loaded => loadedSubject.value == true;

  set loaded(bool loaded) {
    loadedSubject.addEx(loaded);
    setProperty("isLoaded", loaded ? "true" : "false");
  }

  final BehaviorSubject<bool> loadedSubject = BehaviorSubject.seeded(false);

  Stream<bool> get observableLoaded => loadedSubject.stream;

  int latestShownAt = 0;
  int latestStartLoadAt = 0;
  int latestLoadedAt = 0;
  int latestHiddenAt = 0;
  String scene = "";

  int get elapsedTimeInMillisSinceLoadedAds => DateTimeUtils.currentTimeInMillis() - latestLoadedAt;

  int get elapsedTimeInMillisSinceStartLoadAds => DateTimeUtils.currentTimeInMillis() - latestStartLoadAt;

  void resetLatestLoadedAt() {
    latestLoadedAt = 0;
  }

  void resetLoaded() {
    loaded = false;
  }

  void disposeAudit() {
    loadedSubject.close();
  }
}

extension _AdsAuditMsg on AdsEventPayload {}

class AdsAuditHandler extends AdsHandler {
  void _apply(AdsEventPayload adsMsg, void Function(AdsAudit) callback) {
    if (adsMsg.ads is AdsAudit) {
      callback(adsMsg.ads as AdsAudit);
    }
  }

  void onRequestShow(AdsEventPayload adsMsg) {
    _apply(adsMsg, (adsAudit) {
      final showResult = adsMsg.arguments["result"] == true;
      adsAudit.scene = adsMsg.arguments["scene"] ?? "";
      adsAudit.setProperty("latestScene", adsAudit.scene);
      print("[$adsAudit] onRequestShow $showResult");
      if (!showResult) {
        adsAudit.loaded = false;
      }
    });
  }

  @override
  void onRequestLoad(AdsEventPayload adsMsg) {
    _apply(adsMsg, (adsAudit) {
      adsAudit.latestStartLoadAt = DateTimeUtils.currentTimeInMillis();
      adsAudit.setProperty("latestStartLoadTime", DateTime.fromMillisecondsSinceEpoch(adsAudit.latestStartLoadAt).toString());
    });
  }

  void onAdLoaded(AdsEventPayload adsMsg) {
    _apply(adsMsg, (adsAudit) {
      adsAudit.loaded = true;
      adsAudit.latestLoadedAt = DateTimeUtils.currentTimeInMillis();
      adsAudit.setProperty("latestLoadedTime", DateTime.fromMillisecondsSinceEpoch(adsAudit.latestLoadedAt).toString());
    });
  }

  void onAdLoadFailed(AdsEventPayload adsMsg) {
    _apply(adsMsg, (adsAudit) {
      adsAudit.loaded = false;
      adsAudit.setProperty("latestLoadFailedTime", DateTime.now().toString());
    });
  }

  void onAdDisplayFailed(AdsEventPayload adsMsg) {
    _apply(adsMsg, (adsAudit) {
      adsAudit.loaded = false;
      adsAudit.setProperty("latestDisplayFailedTime", DateTime.now().toString());
    });
  }

  void onAdDisplayed(AdsEventPayload adsMsg) {
    _apply(adsMsg, (adsAudit) {
      adsAudit.loaded = false;
      adsAudit.setProperty("latestDisplayTime", DateTime.now().toString());
    });
  }

  void onAdClicked(AdsEventPayload adsMsg) {}

  void onAdHidden(AdsEventPayload adsMsg) {
    _apply(adsMsg, (adsAudit) {
      final now = DateTime.now();
      adsAudit.loaded = false;
      adsAudit.latestHiddenAt = now.millisecondsSinceEpoch;
      adsAudit.setProperty("latestHiddenTime", now.toString());
    });
  }
}
