/// Created by Haoyi on 5/10/21
part of '../ads.dart';

class InterstitialAdsReportEventsHandler extends AdsHandler {
  void _apply(AdsEventPayload payload, void Function(InterstitialAds ads) callback) {
    if (payload.ads is InterstitialAds) {
      try {
        callback(payload.ads as InterstitialAds);
      } catch (error, stacktrace) {
        LogUtils.e('InterstitialAdsHandler apply error:$error, $stacktrace');
      }
    }
  }

  @override
  void onRequestLoad(AdsEventPayload payload) {
    _apply(payload, (ads) {
      Analytics.logEventEx("iads_load");
    });
  }

  void onAdLoaded(AdsEventPayload payload) {
    _apply(payload, (ads) {
      Analytics.logEventEx("iads_loaded",
          parameters: {"duration": ads.elapsedTimeInMillisSinceStartLoadAds});
    });
  }

  void onAdLoadFailed(AdsEventPayload payload) {
    _apply(payload, (ads) {
      String errorCode = payload.arguments["errorName"] ?? "Unknown";
      Analytics.logEventEx("iads_failed", itemCategory: "load", parameters: {
        "duration": ads.elapsedTimeInMillisSinceStartLoadAds,
        "error_code": errorCode
      });
    });
  }

  void onAdDisplayFailed(AdsEventPayload payload) {
    _apply(payload, (ads) {
      String errorCode = payload.arguments["errorName"] ?? "Unknown";
      Analytics.logEventEx("iads_failed",
          itemCategory: "imp",
          parameters: {"duration": ads.elapsedTimeInMillisSinceLoadedAds, "error_code": errorCode});
    });
  }

  void onAdDisplayed(AdsEventPayload payload) {
    _apply(payload, (ads) {
      Analytics.logAdImpression("iads_imp", AdTypeName.AD_TYPE_INTERSTITIAL,
          scene: ads.scene,
          adName: ads.scene,
          parameters: {"duration": "${ads.elapsedTimeInMillisSinceLoadedAds}"});
    });
  }

  void onAdClicked(AdsEventPayload payload) {
    _apply(payload, (ads) {
      Analytics.logAdClick("iads_clk", AdTypeName.AD_TYPE_INTERSTITIAL,
          scene: ads.scene, adName: ads.scene);
    });
  }

  void onAdHidden(AdsEventPayload payload) {
    _apply(payload, (ads) {
      Analytics.logEventEx("iads_close", itemCategory: ads.scene);
    });
  }
}
