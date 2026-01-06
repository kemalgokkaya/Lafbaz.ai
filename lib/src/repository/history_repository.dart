import 'package:lafbaz_ai/src/repository/database_helper.dart';
import 'package:lafbaz_ai/src/model/history_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryRepository {
  final LocalDbService _dbService;

  HistoryRepository(this._dbService);

  // Veri Ekleme
  Future<int> addItem(HistoryItem item) async {
    final db = await _dbService.database;
    return await db.insert('history', item.toMap());
  }

  // Verileri Getirme
  Future<List<HistoryItem>> getHistory() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'history',
      orderBy: "id DESC", // En yeni en üstte
    );
    return List.generate(maps.length, (i) => HistoryItem.fromMap(maps[i]));
  }

  // Veri Silme
  Future<int> deleteItem(int id) async {
    final db = await _dbService.database;
    return await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }
}

// Repository Provider'ı
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(ref.watch(localDbServiceProvider));
});
