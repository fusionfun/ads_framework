/// Created by Haoyi on 5/6/21

part of '../ads.dart';

abstract class InterstitialAds<T> extends Ads<T> with AdsReload, AdsAudit {
  @override
  void init() {
    super.init();
    addHandler(InterstitialAdsReportEventsHandler());
  }

  Future dispose() async {
    super.dispose();
  }

  Future<AdCause> checkShow({String scene = ""}) async {
    return AdCause.success;
  }
}
