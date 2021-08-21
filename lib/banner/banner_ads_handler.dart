/// Created by Haoyi on 5/11/21
part of '../ads.dart';

class BannerAdsReportEventsHandler extends AdsHandler {
  void _apply(AdsEventPayload payload, void Function(BannerAds ads) callback) {
    if (payload.ads is BannerAds) {
      try {
        callback(payload.ads as BannerAds);
      } catch (error, stacktrace) {
        LogUtils.e('BannerAdsReportEventsHandler apply error:$error, $stacktrace');
      }
    }
  }

  @override
  void onRequestLoad(AdsEventPayload payload) {
    _apply(payload, (ads) {
      Analytics.logEventEx("bads_load");
    });
  }

  void onAdLoaded(AdsEventPayload payload) {
    _apply(payload, (ads) {
      // AnalyticsUtils.logEventEx("bads_loaded",
      //     parameters: {"duration": ads.elapsedTimeInMillisSinceStartLoadAds});
    });
  }

  void onAdLoadFailed(AdsEventPayload payload) {
    _apply(payload, (ads) {
      String errorCode = payload.arguments["errorName"] ?? "Unknown";
      // TODO
      // AnalyticsUtils.logEventEx("bads_failed", itemCategory: "load", parameters: {
      //   "duration": ads.elapsedTimeInMillisSinceStartLoadAds,
      //   "error_code": errorCode
      // });
    });
  }

  void onAdDisplayFailed(AdsEventPayload payload) {
    _apply(payload, (ads) {
      String errorCode = payload.arguments["errorName"] ?? "Unknown";
      // TODO
      // AnalyticsUtils.logEventEx("bads_failed",
      //     itemCategory: "imp",
      //     parameters: {"duration": ads.elapsedTimeInMillisSinceLoadedAds, "error_code": errorCode});
    });
  }

  void onAdDisplayed(AdsEventPayload payload) {
    _apply(payload, (ads) {
      // AnalyticsUtils.logAdImpression("bads_imp", AdTypeName.AD_TYPE_BANNER,
      //     scene: ads.scene,
      //     adName: ads.scene,
      //     parameters: {"duration": "${ads.elapsedTimeInMillisSinceLoadedAds}"});
    });
  }

  void onAdClicked(AdsEventPayload payload) {
    _apply(payload, (ads) {
      Analytics.logAdClick("bads_clk", AdTypeName.AD_TYPE_BANNER,
          scene: ads.scene, adName: ads.scene);
    });
  }

  void onAdHidden(AdsEventPayload payload) {
    _apply(payload, (ads) {
      Analytics.logEventEx("bads_close", itemCategory: ads.scene);
    });
  }
}
