import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final adServiceProvider = Provider((ref) => AdService());

class AdService {
  final String _bannerIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
  final String _interstitialIdAndroid =
      'ca-app-pub-3940256099942544/1033173712';

  final String _bannerIdIOS = 'ca-app-pub-3940256099942544/2934735716';
  final String _interstitialIdIOS = 'ca-app-pub-3940256099942544/4411468910';

  String get bannerAdUnitId =>
      Platform.isAndroid ? _bannerIdAndroid : _bannerIdIOS;
  String get interstitialAdUnitId =>
      Platform.isAndroid ? _interstitialIdAndroid : _interstitialIdIOS;

  InterstitialAd? _interstitialAd;

  Future<void> init() async {
    await MobileAds.instance.initialize();
    _loadInterstitialAd();
  }

  // --- BANNER REKLAM ---
  BannerAd? createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner yüklenemedi: $error');
          ad.dispose();
        },
      ),
    );
  }

  // --- GEÇİŞ REKLAMI YÜKLEME ---
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Geçiş reklamı yüklenemedi: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onAdClosed}) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadInterstitialAd();
          if (onAdClosed != null) onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadInterstitialAd();
          if (onAdClosed != null) onAdClosed();
        },
      );

      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      debugPrint("Reklam hazır değil, işlem devam ediyor.");
      if (onAdClosed != null) onAdClosed();
    }
  }
}
