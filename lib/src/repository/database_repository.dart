import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart'; // User ID için
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lafbaz_ai/src/repository/cloud_storage_service.dart';
import 'package:lafbaz_ai/src/repository/database_helper.dart';
import 'package:lafbaz_ai/src/repository/firestore_service.dart';
import 'package:lafbaz_ai/src/model/history_model.dart';

class HistoryRepository {
  final LocalDbService _localDb;
  final CloudStorageService _cloudStorage;
  final FirestoreService _firestore;
  final FirebaseAuth _auth;

  HistoryRepository(
    this._localDb,
    this._cloudStorage,
    this._firestore,
    this._auth,
  );

  // --- HİBRİT KAYIT FONKSİYONU ---
  Future<void> saveAnalysisResult(HistoryItem item, File imageFile) async {
    // 1. Önce LOKAL'e kaydet (Hız için, resim yolu yerel path kalır)
    await _localDb.insertItem(item);

    // 2. Kullanıcı giriş yapmışsa CLOUD'a da kaydet
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // A. Resmi Buluta Yükle
        String? imageUrl = await _cloudStorage.uploadImage(imageFile, user.uid);

        if (imageUrl != null) {
          // B. Modeli Güncelle (Local path yerine Cloud URL koy)
          // Bunun için HistoryItem'a copyWith eklememiz gerekecek veya yeni obje oluşturacağız.
          final cloudItem = HistoryItem(
            id: item.id, // Cloud'da ID otomatik oluşur ama sorun değil
            imagePath: imageUrl, // ARTIK HTTP LINK OLDU
            mode: item.mode,
            date: item.date,
            previewText: item.previewText,
          );

          // C. Firestore'a Yaz
          await _firestore.saveHistory(cloudItem, user.uid);
        }
      } catch (e) {
        debugPrint("Buluta yedeklenirken hata oluştu: $e");
        // Hata olsa bile lokal kayıt yapıldığı için kullanıcıya hissettirmeyebiliriz
      }
    }
  }

  // ... (getHistory ve deleteItem metodları aynı kalacak - Şimdilik sadece localden okuyoruz)
  Future<List<HistoryItem>> getHistory() async {
    final db = await _localDb.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'history',
      orderBy: "id DESC",
    );
    return List.generate(maps.length, (i) => HistoryItem.fromMap(maps[i]));
  }

  Future<int> deleteItem(int id) async {
    final db = await _localDb.database;
    return await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }
}

// Provider'ı Güncelle
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(
    ref.watch(localDbServiceProvider),
    ref.watch(cloudStorageProvider),
    ref.watch(firestoreServiceProvider),
    FirebaseAuth.instance,
  );
});
