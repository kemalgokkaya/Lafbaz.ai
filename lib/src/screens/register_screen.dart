import 'package:animate_do/animate_do.dart'; // Animasyon Paketi
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lafbaz_ai/src/controller/auth_controller.dart';
import 'package:lafbaz_ai/src/core/router/app_router.gr.dart';
import '../widgets/auth_text_field.dart';

@RoutePage()
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // 1. Kontrolcüler
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 2. Kayıt Olma Mantığı
  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    // Basit Validasyon
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lütfen tüm alanları doldurun".tr()),
          backgroundColor: Colors.orangeAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Firebase'e Kayıt İsteği
      await ref
          .read(authControllerProvider)
          .signUpWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // Başarılıysa Home'a git ve geçmişi temizle
      if (mounted) {
        context.router.replaceAll([const HomeRoute()]);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Kayıt başarısız: ${e.toString()}"),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6C63FF);
    final secondaryColor = const Color(0xFFFF6584);
    final backgroundColor = const Color(0xFFF3F5F9);

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,

      // APPBAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Özel Geri Butonu
        leading: FadeInRight(
          duration: const Duration(milliseconds: 600),
          child: Container(
            margin: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              color: Colors.black87,
              onPressed: () => context.router.pop(),
            ),
          ),
        ),
        actions: [
          // Dil Seçimi
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Container(
              margin: const EdgeInsets.only(right: 20, top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: context.locale.languageCode,
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.language, color: primaryColor, size: 20),
                  ),
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      if (newValue == 'tr') {
                        context.setLocale(const Locale('tr', 'TR'));
                      } else {
                        context.setLocale(const Locale('en', 'US'));
                      }
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 'tr', child: Text("TR")),
                    DropdownMenuItem(value: 'en', child: Text("EN")),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          // ARKA PLAN DEKORU
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, backgroundColor],
                ),
              ),
            ),
          ),

          // İÇERİK
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // 1. İKON ALANI (ZoomIn)
                    ZoomIn(
                      duration: const Duration(milliseconds: 800),
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: secondaryColor.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 5,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person_add_alt_1_rounded,
                          size: 50,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // BAŞLIKLAR (FadeInUp - Gecikmeli)
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        "auth_register_title".tr(),
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: Text(
                        "auth_register_subtitle".tr(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 2. FORM ALANI (Sırayla Gelir)
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: AuthTextField(
                        label: "auth_name".tr(),
                        icon: Icons.person_outline_rounded,
                        controller: _nameController,
                      ),
                    ),
                    const SizedBox(height: 16),

                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      child: AuthTextField(
                        label: "auth_email".tr(),
                        icon: Icons.email_outlined,
                        controller: _emailController,
                      ),
                    ),
                    const SizedBox(height: 16),

                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: AuthTextField(
                        label: "auth_password".tr(),
                        icon: Icons.lock_outline_rounded,
                        isObscure: true,
                        controller: _passwordController,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 3. KAYIT OL BUTONU
                    FadeInUp(
                      delay: const Duration(milliseconds: 700),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            // Login'in tersi renkler olsun ki fark edilsin
                            colors: [secondaryColor, primaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: _isLoading ? null : _handleRegister,
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      "auth_register_btn".tr(),
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 4. ZATEN HESABIM VAR
                    FadeInUp(
                      delay: const Duration(milliseconds: 800),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "auth_have_account".tr(),
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                context.router.pop(); // Login ekranına dön
                              },
                              child: Text(
                                "auth_login_link".tr(),
                                style: GoogleFonts.poppins(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
