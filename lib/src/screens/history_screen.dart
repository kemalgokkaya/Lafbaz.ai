import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lafbaz_ai/src/controller/history_controller.dart';
import 'package:lafbaz_ai/src/model/history_model.dart';

@RoutePage()
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Controller'dan gelen listeyi dinliyoruz
    final historyItems = ref.watch(historyControllerProvider);

    // BOŞ DURUM KONTROLÜ
    if (historyItems.isEmpty) {
      return _buildEmptyState(context);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: FadeInDown(
          child: Text(
            "history_title".tr(),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: historyItems.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final item = historyItems[index];

          // Animasyonlu Liste Elemanı (Sırayla gelir)
          return FadeInUp(
            duration: const Duration(milliseconds: 500),
            delay: Duration(
              milliseconds: index * 100,
            ), // Her eleman 100ms gecikmeli
            child: Dismissible(
              key: Key(item.id.toString()),
              direction: DismissDirection.endToStart,
              // SİLME ARKA PLANI
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 25),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.redAccent.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Siliniyor",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
              ),
              onDismissed: (direction) {
                if (item.id != null) {
                  ref
                      .read(historyControllerProvider.notifier)
                      .deleteHistoryItem(item.id!);
                }
              },
              child: _buildHistoryCard(item),
            ),
          );
        },
      ),
    );
  }

  // BOŞ DURUM WIDGET'I (Animasyonlu)
  Widget _buildEmptyState(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const AutoLeadingButton(color: Colors.black87),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZoomIn(
              duration: const Duration(milliseconds: 800),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.history_toggle_off_rounded,
                  size: 80,
                  color: Colors.indigoAccent,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Text(
                "history_empty_title".tr(),
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Text(
                "history_empty_desc".tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // LİSTE KARTI WIDGET'I
  Widget _buildHistoryCard(HistoryItem item) {
    // Rengi moda göre belirle
    Color cardColor = const Color(0xFF6C63FF); // Karizmatik
    if (item.mode == "Diplomatik") cardColor = const Color(0xFF4CAF50);
    if (item.mode == "Esprili") cardColor = const Color(0xFFFF6584);

    // Resim var mı kontrolü (TEXT_MODE ise ikon göster)
    final bool isTextMode = item.imagePath == "TEXT_MODE";
    final File imageFile = File(item.imagePath);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.8),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Detaya gitmek istersen burayı doldurabilirsin
            // context.router.push(ResultRoute(suggestions: [Suggestion(text: item.previewText)]));
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Sol Taraf: RESİM veya İKON
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: isTextMode
                        ? Icon(
                            Icons.text_fields_rounded,
                            color: cardColor,
                            size: 30,
                          )
                        : Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.broken_image_rounded,
                                color: cardColor,
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(width: 16),

                // Orta Taraf: Bilgiler
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // MOD ETİKETİ
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: cardColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.mode.tr(),
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: cardColor,
                              ),
                            ),
                          ),
                          // TARİH
                          Text(
                            item.date,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // CEVAP ÖNİZLEMESİ
                      Text(
                        item.previewText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
