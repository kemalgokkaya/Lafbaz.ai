import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Resmi Yükle ve URL Döndür
  Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      // Dosya ismini benzersiz yap (Örn: users/user123/resim_xys.jpg)
      String fileName = const Uuid().v4();
      Reference ref = _storage.ref().child('users/$userId/scans/$fileName.jpg');

      // Yükleme işlemini başlat
      UploadTask uploadTask = ref.putFile(imageFile);

      // Bitmesini bekle
      TaskSnapshot snapshot = await uploadTask;

      // İndirme linkini al
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint("Resim yükleme hatası: $e");
      return null;
    }
  }
}

final cloudStorageProvider = Provider((ref) => CloudStorageService());
