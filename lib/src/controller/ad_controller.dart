import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final adServiceProvider = Provider((ref) => AdService());

class AdService {
  // Google Resmi Test Kimlikleri (Doğru)
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
          // Callback'leri burada tanımlamak yerine show anında tanımlayacağız
          // ki onAdClosed fonksiyonunu tetikleyebilelim.
        },
        onAdFailedToLoad: (error) {
          debugPrint('Geçiş reklamı yüklenemedi: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  // --- REKLAMI GÖSTER (DÜZELTİLEN KISIM) ---
  void showInterstitialAd({VoidCallback? onAdClosed}) {
    if (_interstitialAd != null) {
      // Callback'leri gösterim anında ayarlıyoruz
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          // Reklam kapatıldı -> İşleme devam et
          ad.dispose();
          _loadInterstitialAd(); // Bir sonraki için hazırla
          if (onAdClosed != null) onAdClosed(); // ✅ EKSİK OLAN BUYDU
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          // Reklam gösterilemedi -> Kullanıcıyı bekletme, devam et
          ad.dispose();
          _loadInterstitialAd();
          if (onAdClosed != null) onAdClosed(); // ✅ BURASI DA EKLENDİ
        },
      );

      _interstitialAd!.show();
      _interstitialAd = null; // Tekrar kullanılmasını engelle
    } else {
      // Reklam hazır değilse hiç bekletme, direkt devam et
      debugPrint("Reklam hazır değil, işlem devam ediyor.");
      if (onAdClosed != null) onAdClosed(); // ✅ BURASI DA EKLENDİ
    }
  }
}
