import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lafbaz_ai/src/repository/chat_gpt_repository.dart';
import 'package:lafbaz_ai/src/model/chat_gpt_model.dart';
import 'package:lafbaz_ai/src/model/home_state.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  final ChatGptRepository _chatGptRepository = ChatGptRepository();
  final ImagePicker _picker = ImagePicker();

  HomeViewModel() : super(HomeState());

  // --- 1. MOD SEÇİMİ ---
  void setMode(String mode) {
    state = state.copyWith(selectedMode: mode);
  }

  // --- 2. GALERİDEN RESİM SEÇME ---
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50, // Performans için kaliteyi düşürdük
      );

      if (image != null) {
        state = state.copyWith(selectedImage: File(image.path));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Resim seçme hatası: $e");
      }
    }
  }

  // --- 3. RESMİ KALDIRMA ---
  void clearImage() {
    // Resmi null yaparak kaldırıyoruz, diğer değerleri koruyoruz
    state = HomeState(
      isLoading: state.isLoading,
      selectedMode: state.selectedMode,
      selectedImage: null,
    );
  }

  // --- 4. ANALİZ VE CEVAP ÜRETME ---
  // Not: Image parametresini buradan kaldırdık çünkü zaten State'in içinde (state.selectedImage) var.
  Future<List<Suggestion>> analyzeContent({String? text, File? image}) async {
    // Yükleniyor durumunu başlat
    state = state.copyWith(isLoading: true);

    try {
      if (kDebugMode) {
        print("🚀 İstek Başladı: Mod: ${state.selectedMode}");
      }

      // Repository üzerinden .NET Backend'e istek atıyoruz
      final suggestions = await _chatGptRepository.generateResponse(
        textInput: text,
        imageInput: state.selectedImage, // State'deki resmi kullanıyoruz
        mode: state.selectedMode, // State'deki modu kullanıyoruz
      );

      if (kDebugMode) {
        print("✅ Cevap Geldi: ${suggestions.length} adet öneri.");
      }

      // Yükleniyor durumunu bitir
      state = state.copyWith(isLoading: false);
      return suggestions;
    } catch (e) {
      if (kDebugMode) {
        print("❌ ViewModel Hatası: $e");
      }
      // Hata olsa bile loading'i durdur ki ekran donmasın
      state = state.copyWith(isLoading: false);
      return []; // Boş liste dön
    }
  }
}

// --- PROVIDER TANIMI ---
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((
  ref,
) {
  return HomeViewModel();
});
