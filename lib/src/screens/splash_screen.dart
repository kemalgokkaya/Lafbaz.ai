import 'dart:async';
import 'package:animate_do/animate_do.dart'; // Animasyon Paketi
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lafbaz_ai/src/core/router/app_router.gr.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 2. Yönlendirme Mantığı (3 Saniye bekle ve git)
    // Animasyonların bitmesi için süreyi biraz artırdık (2sn -> 3sn)
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      // Burayı LoginRoute veya HomeRoute olarak değiştirebilirsin
      // Kullanıcının giriş yapıp yapmadığını kontrol edip yönlendirmek en doğrusudur.
      context.router.replace(const LoginRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lafbaz'ın imza renkleri
    final primaryColor = const Color(0xFF6C63FF);
    final secondaryColor = const Color(0xFFFF6584);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // 1. LOGO (ElasticIn - Yaylanarak Gelir)
            ElasticIn(
              duration: const Duration(seconds: 2), // Uzun ve yumuşak geliş
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(Icons.auto_awesome, size: 80, color: primaryColor),
              ),
            ),

            const SizedBox(height: 30),

            // 2. UYGULAMA İSMİ (FadeInUp - Aşağıdan Yukarı)
            FadeInUp(
              delay: const Duration(milliseconds: 500), // Yarım saniye bekle
              duration: const Duration(milliseconds: 800),
              child: Text(
                "Lafbaz.ai",
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 3. SLOGAN (FadeInUp - Biraz daha gecikmeli)
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              duration: const Duration(milliseconds: 800),
              child: Text(
                "Yapay Zeka Cevap Asistanı",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.9),
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const Spacer(),

            // 4. YÜKLENİYOR (FadeIn)
            FadeIn(
              delay: const Duration(milliseconds: 1500), // En son bu görünür
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: CircularProgressIndicator(
                  color: Colors.white.withValues(alpha: 0.8),
                  strokeWidth: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
