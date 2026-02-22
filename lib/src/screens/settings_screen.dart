import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lafbaz_ai/src/core/router/app_router.gr.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Tasarım Renkleri
    final backgroundColor = const Color(0xFFF8F9FE);
    final primaryColor = const Color(0xFF6C63FF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: FadeInDown(
          child: Text(
            "settingsTitle".tr(), // "Ayarlar"
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const AutoLeadingButton(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildSectionHeader("settings_section_general".tr()),

          FadeInUp(
            duration: const Duration(milliseconds: 500),
            child: _buildLanguageCard(context, primaryColor),
          ),

          const SizedBox(height: 16),

          // --- 2. BÖLÜM: HESAP VE BİLDİRİM ---
          FadeInUp(
            delay: const Duration(milliseconds: 100),
            duration: const Duration(milliseconds: 500),
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.notifications_none_rounded,
                  title: "settings_notifications".tr(),
                  color: Colors.orangeAccent,
                  onTap: () {}, // Bildirim ayarları buraya
                ),
                const SizedBox(height: 12),
                _buildSettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: "settings_account".tr(), // Hesap Bilgileri
                  color: Colors.blueAccent,
                  onTap: () {
                    context.router.push(const ProfileRoute());
                  }, // Profil sayfasına git
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionHeader("settings_section_support".tr()),

          FadeInUp(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 500),
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.star_rate_rounded,
                  title: "drawer_rate".tr(), // Bizi Puanla
                  color: Colors.amber,
                  onTap: () {
                    // Mağaza linkini aç
                  },
                ),
                const SizedBox(height: 12),
                _buildSettingsTile(
                  icon: Icons.share_rounded,
                  title: "drawer_share".tr(), // Arkadaşına Öner
                  color: Colors.green,
                  onTap: () {
                    // Paylaşım dialogunu aç
                  },
                ),
                const SizedBox(height: 12),
                _buildSettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: "pro_privacy".tr(),
                  color: Colors.purpleAccent,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 10),

          // --- 4. BÖLÜM: ÇIKIŞ ---
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 500),
            child: _buildSettingsTile(
              icon: Icons.logout_rounded,
              title: "settings_logout".tr(),
              color: Colors.redAccent,
              isDestructive: true,
              onTap: () {
                context.router.replaceAll([const LoginRoute()]);
              },
            ),
          ),

          const SizedBox(height: 40),
          Center(
            child: Text(
              "v1.0.0",
              style: GoogleFonts.poppins(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- YARDIMCI WIDGETLAR ---

  // Bölüm Başlığı
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  // Dil Seçimi Kartı (Özel Tasarım)
  Widget _buildLanguageCard(BuildContext context, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.language, color: primaryColor, size: 22),
              ),
              const SizedBox(width: 16),
              Text(
                "language".tr(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: context.locale.languageCode,
              icon: const Icon(Icons.arrow_drop_down_rounded),
              borderRadius: BorderRadius.circular(16),
              items: const [
                DropdownMenuItem(value: 'tr', child: Text("🇹🇷 Türkçe")),
                DropdownMenuItem(value: 'en', child: Text("🇺🇸 English")),
              ],
              onChanged: (value) async {
                if (value != null) {
                  final locale = value == 'tr'
                      ? const Locale('tr', 'TR')
                      : const Locale('en', 'US');
                  await context.setLocale(locale);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Genel Ayar Satırı (Reusable)
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required Color color,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? Colors.red.withValues(alpha: 0.1)
                        : color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? Colors.red : color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDestructive ? Colors.red : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
