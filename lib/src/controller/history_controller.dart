import 'package:flutter_riverpod/legacy.dart';
import 'package:lafbaz_ai/src/repository/history_repository.dart';
import 'package:lafbaz_ai/src/model/history_model.dart';

// State: List<HistoryItem> (Ekranda gösterilecek liste)
class HistoryController extends StateNotifier<List<HistoryItem>> {
  final HistoryRepository _repository;

  HistoryController(this._repository) : super([]) {
    loadHistory(); // Controller oluştuğu an verileri çek
  }

  // Geçmişi Yükle
  Future<void> loadHistory() async {
    final items = await _repository.getHistory();
    state = items; // Listeyi güncelle, ekran otomatik yenilenir
  }

  // Yeni Kayıt Ekle
  Future<void> addHistoryItem(HistoryItem item) async {
    await _repository.addItem(item);
    await loadHistory(); // Listeyi yenile
  }

  // Kayıt Sil
  Future<void> deleteHistoryItem(int id) async {
    await _repository.deleteItem(id);
    await loadHistory(); // Listeyi yenile
  }
}

// Controller Provider'ı (UI bunu kullanacak)
final historyControllerProvider =
    StateNotifierProvider<HistoryController, List<HistoryItem>>((ref) {
      return HistoryController(ref.watch(historyRepositoryProvider));
    });
