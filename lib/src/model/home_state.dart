import 'dart:io';

class HomeState {
  final bool isLoading;
  final String selectedMode; // 'Karizmatik', 'Diplomatik', 'Esprili'
  final File? selectedImage;

  HomeState({
    this.isLoading = false,
    this.selectedMode = 'Karizmatik', // Varsayılan mod
    this.selectedImage,
  });

  // State'i güncellemek için copyWith metodu
  HomeState copyWith({
    bool? isLoading,
    String? selectedMode,
    File? selectedImage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      selectedMode: selectedMode ?? this.selectedMode,
      selectedImage: selectedImage ?? this.selectedImage,
    );
  }
}
