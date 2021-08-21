/// Created by Haoyi on 5/7/21

part of '../ads.dart';

abstract class AdsHandler {
  void onRequestShow(AdsEventPayload payload) {}

  void onRequestHide(AdsEventPayload payload) {}

  void onRequestLoad(AdsEventPayload payload) {}

  void onRequestDispose(AdsEventPayload payload) {}

  void onAdLoaded(AdsEventPayload payload) {}

  void onAdLoadFailed(AdsEventPayload payload) {}

  void onAdDisplayFailed(AdsEventPayload payload) {}

  void onAdDisplayed(AdsEventPayload payload) {}

  void onAdClicked(AdsEventPayload payload) {}

  void onAdHidden(AdsEventPayload payload) {}
}

abstract class RewardedAdsHandler extends AdsHandler {
  void onAdRewarded(AdsEventPayload payload) {}
}

typedef AdsCallback = void Function(AdsEventPayload);

class AdsHandlerDelegate extends AdsHandler {
  final AdsCallback? onRequestShowCallback;

  final AdsCallback? onRequestHideCallback;

  final AdsCallback? onRequestLoadCallback;

  final AdsCallback? onRequestDisposeCallback;

  final AdsCallback? onAdLoadedCallback;

  final AdsCallback? onAdLoadFailedCallback;

  final AdsCallback? onAdDisplayFailedCallback;

  final AdsCallback? onAdDisplayedCallback;

  final AdsCallback? onAdClickedCallback;

  final AdsCallback? onAdHiddenCallback;

  AdsHandlerDelegate(
      {this.onRequestShowCallback,
      this.onRequestHideCallback,
      this.onRequestLoadCallback,
      this.onRequestDisposeCallback,
      this.onAdLoadedCallback,
      this.onAdLoadFailedCallback,
      this.onAdDisplayFailedCallback,
      this.onAdDisplayedCallback,
      this.onAdClickedCallback,
      this.onAdHiddenCallback});

  void onRequestShow(AdsEventPayload payload) {
    this.onRequestShowCallback?.call(payload);
  }

  void onRequestHide(AdsEventPayload payload) {
    this.onRequestHideCallback?.call(payload);
  }

  void onRequestLoad(AdsEventPayload payload) {
    this.onRequestLoadCallback?.call(payload);
  }

  void onRequestDispose(AdsEventPayload payload) {
    this.onRequestDisposeCallback?.call(payload);
  }

  void onAdLoaded(AdsEventPayload payload) {
    print("onAdLoaded !!!!");
    this.onAdLoadedCallback?.call(payload);
  }

  void onAdLoadFailed(AdsEventPayload payload) {
    this.onAdLoadFailedCallback?.call(payload);
  }

  void onAdDisplayFailed(AdsEventPayload payload) {
    this.onAdDisplayFailedCallback?.call(payload);
  }

  void onAdDisplayed(AdsEventPayload payload) {
    this.onAdDisplayedCallback?.call(payload);
  }

  void onAdClicked(AdsEventPayload payload) {
    this.onAdClickedCallback?.call(payload);
  }

  void onAdHidden(AdsEventPayload payload) {
    this.onAdHiddenCallback?.call(payload);
  }
}

class RewardsAdsHandlerDelegate extends RewardedAdsHandler {
  final AdsCallback? onRequestShowCallback;

  final AdsCallback? onRequestHideCallback;

  final AdsCallback? onRequestLoadCallback;

  final AdsCallback? onRequestDisposeCallback;

  final AdsCallback? onAdLoadedCallback;

  final AdsCallback? onAdLoadFailedCallback;

  final AdsCallback? onAdDisplayFailedCallback;

  final AdsCallback? onAdDisplayedCallback;

  final AdsCallback? onAdClickedCallback;

  final AdsCallback? onAdHiddenCallback;

  final AdsCallback? onAdRewardedCallback;

  RewardsAdsHandlerDelegate(
      {this.onRequestShowCallback,
      this.onRequestHideCallback,
      this.onRequestLoadCallback,
      this.onRequestDisposeCallback,
      this.onAdLoadedCallback,
      this.onAdLoadFailedCallback,
      this.onAdDisplayFailedCallback,
      this.onAdDisplayedCallback,
      this.onAdClickedCallback,
      this.onAdHiddenCallback,
      this.onAdRewardedCallback});

  void onRequestShow(AdsEventPayload payload) {
    this.onRequestShowCallback?.call(payload);
  }

  void onRequestHide(AdsEventPayload payload) {
    this.onRequestHideCallback?.call(payload);
  }

  void onRequestLoad(AdsEventPayload payload) {
    this.onRequestLoadCallback?.call(payload);
  }

  void onRequestDispose(AdsEventPayload payload) {
    this.onRequestDisposeCallback?.call(payload);
  }

  void onAdLoaded(AdsEventPayload payload) {
    print("onAdLoaded !!!!");
    this.onAdLoadedCallback?.call(payload);
  }

  void onAdLoadFailed(AdsEventPayload payload) {
    this.onAdLoadFailedCallback?.call(payload);
  }

  void onAdDisplayFailed(AdsEventPayload payload) {
    this.onAdDisplayFailedCallback?.call(payload);
  }

  void onAdDisplayed(AdsEventPayload payload) {
    this.onAdDisplayedCallback?.call(payload);
  }

  void onAdClicked(AdsEventPayload payload) {
    this.onAdClickedCallback?.call(payload);
  }

  void onAdHidden(AdsEventPayload payload) {
    this.onAdHiddenCallback?.call(payload);
  }

  void onAdRewarded(AdsEventPayload payload) {
    this.onAdRewardedCallback?.call(payload);
  }
}
