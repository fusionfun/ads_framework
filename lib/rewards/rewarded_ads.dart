/// Created by Haoyi on 5/26/21

part of '../ads.dart';

abstract class RewardedAds<T> extends Ads<T> with AdsReload, AdsAudit {
  @override
  void init() {
    super.init();
    addHandler(RewardedAdsReportEventsHandler());
  }
}
