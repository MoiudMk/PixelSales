import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('pixelsales.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');
  }

  Future<int> addProduct({
    required String name,
    required double price,
    required int quantity,
  }) async {
    final db = await database;

    return await db.insert(
      'products',
      {
        'name': name,
        'price': price,
        'quantity': quantity,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;

    return await db.query(
      'products',
      orderBy: 'id DESC',
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;

    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  Future<int> updateProduct({
    required int id,
    required String name,
    required double price,
    required int quantity,
  }) async {
    final db = await database;

    return await db.update(
      'products',
      {
        'name': name,
        'price': price,
        'quantity': quantity,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  }
}