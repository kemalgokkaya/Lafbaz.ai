import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lafbaz_ai/src/controller/user_controller.dart';
import 'package:lafbaz_ai/src/core/router/app_router.gr.dart';

class LafbazDrawer extends ConsumerWidget {
  const LafbazDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userControllerProvider);

    final primaryColor = const Color(0xFF6C63FF);
    final secondaryColor = const Color(0xFF8B85FF);
    final itemBgColor = const Color(0xFFF8F9FE);

    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // 1. HEADER: Profil Alanı
          SizedBox(
            height: isSmallScreen ? 200 : 240,
            child: Stack(
              children: [
                // Arka Plan Gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),

                // İçerik (Animasyonlu)
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar (Büyüyerek gelir)
                        ZoomIn(
                          duration: const Duration(milliseconds: 600),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.white,
                              // Resim yoksa İsmin Baş Harfini Göster
                              child: Text(
                                userState.name.isNotEmpty
                                    ? userState.name[0].toUpperCase()
                                    : "L",
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Yazılar (Sağdan kayarak gelir)
                        Expanded(
                          child: FadeInRight(
                            duration: const Duration(milliseconds: 600),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  userState.name, // Controller'dan gelen isim
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "Lafbaz Üyesi", // Veya userState.email
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. MENÜ LİSTESİ (Sıralı Animasyon)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Ayarlar
                  FadeInLeft(
                    delay: const Duration(milliseconds: 100),
                    child: _buildMenuItem(
                      context,
                      icon: Icons.settings_rounded,
                      text: "settingsTitle".tr(),
                      accentColor: Colors.blueAccent,
                      bgColor: itemBgColor,
                      onTap: () {
                        context.router.pop(); // Drawer'ı kapat
                        context.router.push(const SettingsRoute());
                      },
                    ),
                  ),

                  // Puanla
                  FadeInLeft(
                    delay: const Duration(milliseconds: 200),
                    child: _buildMenuItem(
                      context,
                      icon: Icons.star_rounded,
                      text: "drawer_rate".tr(),
                      accentColor: Colors.orangeAccent,
                      bgColor: itemBgColor,
                      onTap: () {
                        // Mağaza linki
                      },
                    ),
                  ),

                  // Paylaş
                  FadeInLeft(
                    delay: const Duration(milliseconds: 300),
                    child: _buildMenuItem(
                      context,
                      icon: Icons.share_rounded,
                      text: "drawer_share".tr(),
                      accentColor: primaryColor,
                      bgColor: itemBgColor,
                      onTap: () {
                        // Paylaşım kodu
                      },
                    ),
                  ),

                  // ÇIKIŞ YAP / SIFIRLA
                  FadeInLeft(
                    delay: const Duration(milliseconds: 400),
                    child: _buildMenuItem(
                      context,
                      icon: Icons.logout_rounded,
                      text: "settings_logout".tr(),
                      accentColor: Colors.redAccent,
                      bgColor: Colors.red.withOpacity(0.05),
                      onTap: () async {
                        // 1. Kullanıcı verilerini sil (Sıfırla)
                        await ref
                            .read(userControllerProvider.notifier)
                            .deleteUser();

                        // 2. Giriş Ekranına At
                        if (context.mounted) {
                          context.router.replaceAll([const LoginRoute()]);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. ALT BİLGİ
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "v1.0.0 Lafbaz.ai",
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Menü Elemanı Widget'ı
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color accentColor,
    required Color bgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accentColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
