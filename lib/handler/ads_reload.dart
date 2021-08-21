/// Created by Haoyi on 5/7/21
part of '../ads.dart';

class RetryConfig {
  final int minInSecond;
  final int maxInSecond;

  RetryConfig(this.minInSecond, this.maxInSecond);
}

mixin AdsReload<T> on Ads<T> {
  int retryAttempt = 0;
  Timer? _currentLoadTimer;

  RetryConfig get retryConfig => RetryConfig(4, 600);

  bool get isLoadingRewardAdsDelayed => _currentLoadTimer != null;

  void _resetReloadTimer() {
    try {
      _currentLoadTimer?.cancel();
      _currentLoadTimer = null;
    } catch (error, stacktrace) {
      _currentLoadTimer = null;
    }
  }

  void _reset() {
    retryAttempt = 0;
    _resetReloadTimer();
    setProperty("retryAttempt", "0");
  }

  void reload({bool force = false}) {
    retryAttempt++;
    int delayMillis = (pow(2, retryAttempt) * 1000).toInt();
    final config = retryConfig;
    final duration = Duration(seconds: delayMillis.clamp(config.minInSecond, config.maxInSecond));
    setProperty("retryAttempt", retryAttempt.toString());
    setProperty("reloadIntervalTime", duration.toString());
    _resetReloadTimer();
    if (force) {
      setProperty("latestReloadTime", DateTime.now().toString());
      load();
    } else {
      _currentLoadTimer = new Timer(duration, () {
        setProperty("latestReloadTime", DateTime.now().toString());
        _currentLoadTimer = null;
        load();
      });
    }
  }
}

class AdsReloadHandler extends AdsHandler {
  void _apply(AdsEventPayload msg, void Function(AdsReload) callback) {
    if (msg.ads is AdsReload) {
      callback(msg.ads as AdsReload);
    }
  }

  void onAdLoaded(AdsEventPayload msg) {
    _apply(msg, (adsReload) {
      adsReload._reset();
    });
  }

  void onAdLoadFailed(AdsEventPayload msg) {
    _apply(msg, (adsReload) {
      adsReload.reload();
    });
  }

  void onAdDisplayFailed(AdsEventPayload msg) {
    _apply(msg, (adsReload) {
      adsReload._resetReloadTimer();
      adsReload.load();
      adsReload.setProperty("latestReloadTime", DateTime.now().toString());
    });
  }

  void onAdDisplayed(AdsEventPayload msg) {}

  void onAdClicked(AdsEventPayload msg) {}

  void onAdHidden(AdsEventPayload msg) {
    _apply(msg, (adsReload) {
      adsReload._resetReloadTimer();
      msg.ads.load();
      adsReload.setProperty("latestReloadTime", DateTime.now().toString());
    });
  }
}
