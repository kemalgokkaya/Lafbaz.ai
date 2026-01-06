import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lafbaz_ai/src/model/chat_gpt_model.dart';

@RoutePage()
class ResultScreen extends ConsumerWidget {
  final List<Suggestion> suggestions;
  const ResultScreen({super.key, required this.suggestions});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        title: Text(
          "Sonuçlar",
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: suggestions.isEmpty
          ? const Center(child: Text("Sonuç yok ."))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFF6C63FF),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Lafbaz Önerisi ${index + 1}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6C63FF),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      Text(
                        suggestion.text,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
