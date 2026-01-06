import 'package:lafbaz_ai/src/model/history_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalDbService {
  static Database? _database;

  // Veritabanını getir
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Başlatma ve Tablo Oluşturma
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'lafbaz.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagePath TEXT,
            mode TEXT,
            date TEXT,
            previewText TEXT
          )
        ''');
      },
    );
  }

  // --- EKSİK OLAN METODLAR BURADA ---

  // 1. Veri Ekleme (Insert) - HATA VEREN KISIM BU
  Future<int> insertItem(HistoryItem item) async {
    final db = await database;
    return await db.insert('history', item.toMap());
  }

  // 2. Verileri Getirme (Query) - Repository'de kullanılıyor olabilir
  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await database;
    return await db.query('history', orderBy: "id DESC");
  }

  // 3. Veri Silme (Delete)
  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }
}

// Servisi tüm uygulamaya sağlayan Provider
final localDbServiceProvider = Provider((ref) => LocalDbService());
