/// Created by Haoyi on 5/10/21

part of '../ads.dart';

abstract class BannerAds<T> extends Ads<T> with AdsAudit {
  @override
  void init() {
    super.init();
    addHandler(BannerAdsReportEventsHandler());
  }
}
