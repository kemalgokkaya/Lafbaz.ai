import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lafbaz_ai/src/controller/history_controller.dart';
import 'package:lafbaz_ai/src/controller/home_viewmodel.dart';
import 'package:lafbaz_ai/src/core/router/app_router.gr.dart';
import 'package:lafbaz_ai/src/model/history_model.dart';
import '../widgets/lafbaz_settings_drawer.dart';

@RoutePage()
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<String> modes = ['Karizmatik', 'Diplomatik', 'Esprili'];

  final TextEditingController _textInputController = TextEditingController();
  late TabController _tabController;

  // --- REKLAM DEĞİŞKENLERİ ---
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  InterstitialAd? _interstitialAd;

  // Test ID'leri
  final String _bannerUnitId = 'ca-app-pub-3323165490285936/3281763632';
  final String _interstitialUnitId = 'ca-app-pub-3323165490285936/6235230036';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBannerAd();
    _loadInterstitialAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _bannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isBannerLoaded = true),
        onAdFailedToLoad: (ad, err) => ad.dispose(),
      ),
    )..load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                  _loadInterstitialAd();
                },
                onAdFailedToShowFullScreenContent: (ad, error) {
                  ad.dispose();
                  _loadInterstitialAd();
                },
              );
        },
        onAdFailedToLoad: (err) {},
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textInputController.dispose();
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    final Color primaryColor = const Color(0xFF6C63FF);
    final Color secondaryColor = const Color(0xFFFF6584);
    final Color backgroundColor = const Color(0xFFF3F5F9);

    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: const LafbazDrawer(),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
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

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. HEADER (DÜZENLENMİŞ KISIM)
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // MENU BUTTON
                        Builder(
                          builder: (context) => GestureDetector(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.menu_rounded,
                                size: 26,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // TEXT AREA (EXPANDED İLE OVERFLOW ENGELLENDİ)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "welcomeTitle".tr(),
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // HISTORY BUTTON
                        InkWell(
                          onTap: () =>
                              context.router.push(const HistoryRoute()),
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.history_rounded,
                              size: 28,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 2. TAB BAR
                  FadeInDown(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 600),
                    child: Container(
                      height: 55,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, const Color(0xFF8B85FF)],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey.shade500,
                        labelStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        splashBorderRadius: BorderRadius.circular(25),
                        tabs: [
                          Tab(text: "photo".tr()),
                          Tab(text: "text".tr()),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Expanded(
                    child: ZoomIn(
                      duration: const Duration(milliseconds: 500),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // A. RESİM ALANI
                          GestureDetector(
                            onTap: () => viewModel.pickImageFromGallery(),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(35),
                                border: Border.all(color: Colors.grey.shade100),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withValues(alpha: 0.08),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: homeState.selectedImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(35),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.file(
                                            homeState.selectedImage!,
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            color: Colors.black.withValues(
                                              alpha: 0.2,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: primaryColor.withValues(
                                              alpha: 0.1,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.add_a_photo_rounded,
                                            size: 40,
                                            color: primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "home_hero_title".tr(),
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),

                          // B. METİN ALANI
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(35),
                              border: Border.all(color: Colors.grey.shade100),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _textInputController,
                                    maxLines: null,
                                    expands: true,
                                    decoration: InputDecoration(
                                      hintText: "text_area_hint".tr(),
                                      hintStyle: GoogleFonts.poppins(
                                        color: Colors.grey.shade300,
                                        fontSize: 18,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                if (_textInputController.text.isNotEmpty)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _textInputController.clear();
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 20,
                                        color: Colors.redAccent,
                                      ),
                                      label: Text(
                                        "Temizle",
                                        style: GoogleFonts.poppins(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.red.withValues(
                                          alpha: 0.1,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. MOD SEÇİMİ
                  SlideInUp(
                    duration: const Duration(milliseconds: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "modeSelection".tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 55,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: modes.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final modeKey = modes[index];
                              final isSelected =
                                  homeState.selectedMode == modeKey;
                              return GestureDetector(
                                onTap: () => viewModel.setMode(modeKey),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? primaryColor
                                          : Colors.grey.shade200,
                                      width: 2,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: primaryColor.withValues(
                                                alpha: 0.4,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(
                                      modeKey.tr(),
                                      style: GoogleFonts.poppins(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey.shade600,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 5. AKSİYON BUTONU
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: Container(
                      width: double.infinity,
                      height: 65,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: secondaryColor.withValues(alpha: 0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () async {
                            if (homeState.isLoading) return;

                            final isImageMode = _tabController.index == 0;
                            final textInput = _textInputController.text.trim();

                            if (isImageMode &&
                                homeState.selectedImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("toast_photo_needed".tr()),
                                ),
                              );
                              return;
                            }
                            if (!isImageMode && textInput.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Lütfen bir metin girin!"),
                                ),
                              );
                              return;
                            }

                            final results = await viewModel.analyzeContent(
                              image: isImageMode
                                  ? homeState.selectedImage
                                  : null,
                              text: !isImageMode ? textInput : null,
                            );

                            if (_interstitialAd != null) {
                              final adCompleter = Completer<void>();
                              _interstitialAd!.fullScreenContentCallback =
                                  FullScreenContentCallback(
                                    onAdDismissedFullScreenContent: (ad) {
                                      ad.dispose();
                                      adCompleter.complete();
                                      _loadInterstitialAd();
                                    },
                                    onAdFailedToShowFullScreenContent:
                                        (ad, error) {
                                          ad.dispose();
                                          adCompleter.complete();
                                          _loadInterstitialAd();
                                        },
                                  );
                              _interstitialAd!.show();
                              await adCompleter.future;
                            }

                            if (results.isNotEmpty && context.mounted) {
                              final dateStr = DateFormat(
                                'dd MMM, HH:mm',
                              ).format(DateTime.now());

                              final newItem = HistoryItem(
                                imagePath: isImageMode
                                    ? homeState.selectedImage!.path
                                    : "TEXT_MODE",
                                mode: homeState.selectedMode,
                                date: dateStr,
                                previewText: results.first.text,
                              );

                              await ref
                                  .read(historyControllerProvider.notifier)
                                  .addHistoryItem(newItem);

                              if (!context.mounted) return;

                              context.router.push(
                                ResultRoute(suggestions: results),
                              );
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: Text(
                                    "Yapay zekadan cevap alınamadı. Lütfen API kotanızı kontrol edin.",
                                  ),
                                ),
                              );
                            }
                          },
                          child: Center(
                            child: homeState.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.auto_awesome,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        "btnStartMagic".tr(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 6. BANNER REKLAM
                  if (_bannerAd != null && _isBannerLoaded)
                    FadeIn(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: _bannerAd!.size.width.toDouble(),
                          height: _bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd!),
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
