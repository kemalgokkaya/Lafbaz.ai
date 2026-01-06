import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lafbaz_ai/firebase_options.dart';
import 'package:lafbaz_ai/src/controller/ad_controller.dart';
import 'package:lafbaz_ai/src/core/router/app_router.dart';

final appRouter = AppRouter();

Future<void> main() async {
  // 1. Motoru hazırla
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // 2. FIREBASE BAŞLATMA (Güvenli Mod)
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint("✅ Firebase başarıyla başlatıldı.");
    } else {
      debugPrint("ℹ️ Firebase zaten çalışıyor, tekrar başlatılmadı.");
    }
  } catch (e) {
    // Hata olsa bile uygulamayı durdurma, sadece logla.
    debugPrint(
      "⚠️ Firebase başlatma hatası (Önemli değil, devam ediliyor): $e",
    );
  }

  // 3. REKLAMLARI BAŞLATMA (Güvenli Mod)
  try {
    await MobileAds.instance.initialize();
    await AdService().init();
    debugPrint("✅ Reklam servisi başlatıldı.");
  } catch (e) {
    debugPrint("⚠️ Reklam servisi başlatılamadı: $e");
  }

  // 4. Uygulamayı Çiz
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
      path: 'assets/translations',
      fallbackLocale: const Locale('tr', 'TR'),
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      title: 'Lafbaz.ai',
      theme: ThemeData(primarySwatch: Colors.indigo),
      routerConfig: appRouter.config(),
    );
  }
}
