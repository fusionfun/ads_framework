/// Created by Haoyi on 5/26/21

part of '../ads.dart';

abstract class RewardedAds<T> extends Ads<T> with AdsReload, AdsAudit {
  @override
  void init() {
    super.init();
    addHandler(RewardedAdsReportEventsHandler());
  }
}

class InvalidRewardedAds extends RewardedAds<int> {
  @override
  AdUnitId get adUnitId => throw UnimplementedError();

  @override
  Map<int, AdsEvent> get eventsMapping => <int, AdsEvent>{};

  @override
  Future<bool> requestDispose() {
    return Future.value(false);
  }

  @override
  Future<bool> requestHide() {
    return Future.value(false);
  }

  @override
  Future<bool> requestLoad() {
    return Future.value(false);
  }

  @override
  Future<bool> requestShow({required String scene}) {
    return Future.value(false);
  }
}
