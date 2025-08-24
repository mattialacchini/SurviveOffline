import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static Future<void> init() async {
    await MobileAds.instance.initialize();
    // Optional: set test device IDs
    final reqCfg = RequestConfiguration(testDeviceIds: const <String>['TEST_DEVICE_ID']);
    MobileAds.instance.updateRequestConfiguration(reqCfg);
  }

  static String get bannerUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111' // TEST ANDROID
      : 'ca-app-pub-3940256099942544/2934735716'; // TEST iOS

  static String get nativeUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110' // TEST ANDROID
      : 'ca-app-pub-3940256099942544/3986624511'; // TEST iOS
}

class BannerAdWidget {
  BannerAd? _ad;

  BannerAdWidget() {
    _ad = BannerAd(
      adUnitId: AdService.bannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: const BannerAdListener(),
    )..load();
  }

  AdWidget? get widget => _ad == null ? null : AdWidget(ad: _ad!);
  AdSize get size => _ad?.size ?? AdSize.banner;
  void dispose() => _ad?.dispose();
}
