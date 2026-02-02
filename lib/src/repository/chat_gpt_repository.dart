import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // debugPrint için
import 'package:lafbaz_ai/src/model/chat_gpt_model.dart';

class ChatGptRepository {
  late final Dio _dio;

  ChatGptRepository() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );
  }

  String get _baseUrl {
    return "http://84.32.230.159/api/chat/sor";
  }

  Future<List<Suggestion>> generateResponse({
    required String? textInput,
    required File? imageInput,
    required String mode,
  }) async {
    try {
      // 1. Backend'e gönderilecek veriyi hazırla
      final prompt = "Mod: $mode. Soru: ${textInput ?? 'Resim yorumla'}";

      final requestData = {
        "soru": prompt, // Backend'deki UserRequest modelindeki 'Soru' alanı
      };

      debugPrint("🚀 Dio İsteği Gönderiliyor: $_baseUrl");
      debugPrint("📦 Body: $requestData");

      // 2. İsteği Gönder (Dio otomatik JSON encode yapar)
      final response = await _dio.post(_baseUrl, data: requestData);

      // 3. Cevabı İşle (Dio otomatik JSON decode yapar)
      if (response.statusCode == 200) {
        // response.data zaten bir Map'tir (jsonDecode gerekmez)
        final data = response.data;

        // Backend'den gelen alan adı: "chatGptCevabi"
        final rawText = data['chatGptCevabi'] as String?;

        if (rawText != null && rawText.isNotEmpty) {
          debugPrint("✅ Backend Cevabı: $rawText");

          // Gelen cevabı listeye çevirip döndür
          // (İleride backend cevapları ||| ile ayırırsa burada split yapabilirsin)
          return [Suggestion(text: rawText)];
        }
      }
      return [];
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(
          "❌ Sunucu Hatası: ${e.response?.statusCode} - ${e.response?.data}",
        );
      } else {
        debugPrint("❌ Bağlantı Hatası: ${e.message}");
      }
      return [];
    } catch (e) {
      debugPrint("❌ Beklenmeyen Hata: $e");
      return [];
    }
  }
}
