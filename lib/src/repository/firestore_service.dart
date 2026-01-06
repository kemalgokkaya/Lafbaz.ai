import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lafbaz_ai/src/model/history_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Veriyi Kaydet
  Future<void> saveHistory(HistoryItem item, String userId) async {
    try {
      // 'users' koleksiyonunun altında o kullanıcının 'history' koleksiyonuna ekle
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('history')
          .add(item.toMap());
      // Not: toMap() metodunda 'imagePath' yerine Cloud URL gitmeli.
      // Bunu Repository katmanında ayarlayacağız.
    } catch (e) {
      debugPrint("Firestore kayıt hatası: $e");
      rethrow;
    }
  }
}

final firestoreServiceProvider = Provider((ref) => FirestoreService());
