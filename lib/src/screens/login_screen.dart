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
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // 1. Verileri tutacak kontrolcüler
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Giriş Yapma Fonksiyonu
  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
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
      await ref
          .read(authControllerProvider)
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      if (mounted) {
        context.router.replace(const HomeRoute());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Giriş başarısız: ${e.toString()}"),
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
    // Renk Paleti
    final primaryColor = const Color(0xFF6C63FF);
    final secondaryColor = const Color(0xFFFF6584);
    final backgroundColor = const Color(0xFFF3F5F9);

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      // APPBAR (Dil Değiştirme - FadeInDown)
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
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
                  dropdownColor: Colors.white,
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
          Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      // 1. LOGO ALANI (ZoomIn + Elastic)
                      ZoomIn(
                        duration: const Duration(milliseconds: 800),
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.25),
                                blurRadius: 30,
                                spreadRadius: 5,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            size: 60,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // BAŞLIKLAR (FadeInUp - Gecikmeli)
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: Text(
                          "auth_welcome_title".tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        child: Text(
                          "auth_welcome_subtitle".tr(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      // 2. FORM ALANI (Sırayla Gelir)
                      FadeInUp(
                        delay: const Duration(milliseconds: 400),
                        child: AuthTextField(
                          label: "auth_email".tr(),
                          icon: Icons.email_outlined,
                          controller: _emailController,
                        ),
                      ),

                      const SizedBox(height: 16), // Boşluk eklendi

                      FadeInUp(
                        delay: const Duration(milliseconds: 500),
                        child: AuthTextField(
                          label: "auth_password".tr(),
                          icon: Icons.lock_outline_rounded,
                          isObscure: true,
                          controller: _passwordController,
                        ),
                      ),

                      // Şifremi Unuttum
                      FadeInUp(
                        delay: const Duration(milliseconds: 600),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Yakında eklenecek..."),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey.shade600,
                            ),
                            child: Text(
                              "auth_forgot_pass".tr(),
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 3. GİRİŞ BUTONU
                      FadeInUp(
                        delay: const Duration(milliseconds: 700),
                        child: Container(
                          width: double.infinity,
                          height: 60, // Buton biraz büyütüldü
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryColor, secondaryColor],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: secondaryColor.withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: _isLoading ? null : _handleLogin,
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
                                        "auth_login_btn".tr(),
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

                      const SizedBox(height: 16),

                      // 4. MİSAFİR GİRİŞİ
                      FadeInUp(
                        delay: const Duration(milliseconds: 800),
                        child: TextButton(
                          onPressed: () {
                            context.router.replace(const HomeRoute());
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            backgroundColor: primaryColor.withOpacity(0.05),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            "auth_continue_guest".tr(),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // 5. KAYIT OL LİNKİ
                      FadeInUp(
                        delay: const Duration(milliseconds: 900),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "auth_no_account".tr(),
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  context.router.push(const RegisterRoute());
                                },
                                child: Text(
                                  "auth_register_link".tr(),
                                  style: GoogleFonts.poppins(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
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
            ),
          ),
        ],
      ),
    );
  }
}
