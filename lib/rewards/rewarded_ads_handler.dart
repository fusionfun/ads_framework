/// Created by Haoyi on 5/26/21

part of '../ads.dart';

class RewardedAdsReportEventsHandler extends RewardedAdsHandler {
  void _apply(AdsEventPayload payload, void Function(RewardedAds ads) callback) {
    if (payload.ads is RewardedAds) {
      try {
        callback(payload.ads as RewardedAds);
      } catch (error, stacktrace) {
        LogUtils.e('RewardedAdsHandler apply error:$error, $stacktrace');
      }
    }
  }

  @override
  void onRequestLoad(AdsEventPayload payload) {
    _apply(payload, (ads) {
      Analytics.logEventEx("rads_load");
    });
  }

  void onAdLoaded(AdsEventPayload payload) {
    _apply(payload, (ads) {
      Analytics.logEventEx("rads_loaded", parameters: {"duration": ads.elapsedTimeInMillisSinceStartLoadAds});
    });
  }

  void onAdLoadFailed(AdsEventPayload payload) {
    _apply(payload, (ads) {
      String errorCode = payload.arguments["errorName"] ?? "Unknown";
      Analytics.logEventEx("rads_failed",
          itemCategory: "load", parameters: {"duration": ads.elapsedTimeInMillisSinceStartLoadAds, "error_code": errorCode});
    });
  }

  void onAdDisplayFailed(AdsEventPayload payload) {
    _apply(payload, (ads) {
      String errorCode = payload.arguments["errorName"] ?? "Unknown";
      Analytics.logEventEx("rads_failed",
          itemCategory: "imp", parameters: {"duration": ads.elapsedTimeInMillisSinceLoadedAds, "error_code": errorCode});
    });
  }

  void onAdDisplayed(AdsEventPayload payload) {
    _apply(payload, (ads) {
      Analytics.logAdImpression("rads_imp", AdTypeName.AD_TYPE_REWARDED_VIDEO,
          scene: ads.scene, adName: ads.scene, parameters: {"duration": "${ads.elapsedTimeInMillisSinceLoadedAds}"});
    });
  }

  void onAdClicked(AdsEventPayload payload) {
    _apply(payload, (ads) {
      Analytics.logAdClick("rads_clk", AdTypeName.AD_TYPE_REWARDED_VIDEO, scene: ads.scene, adName: ads.scene);
    });
  }

  void onAdHidden(AdsEventPayload payload) {
    _apply(payload, (ads) {
      Analytics.logEventEx("rads_close", itemCategory: ads.scene);
    });
  }

  @override
  void onAdRewarded(AdsEventPayload payload) {
    _apply(payload, (ads) async {
      Analytics.logEventEx("rads_rewarded", itemCategory: ads.scene);
      // final userRewardedCount =
      //     await AppProperty.getInstance().getInt(PropertyKeys.userRewardedCount) ?? 0;
      // if (userRewardedCount == 0) {
      //   AnalyticsUtils.logEventEx("first_rads_rewarded", itemCategory: ads.scene);
      // }
      // await AppProperty.getInstance().setInt(PropertyKeys.userRewardedCount, userRewardedCount + 1);
    });
  }
}
