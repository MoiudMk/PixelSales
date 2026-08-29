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
    return openDatabase(join(dbPath, fileName), version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE products(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      price REAL NOT NULL,
      quantity INTEGER NOT NULL DEFAULT 0,
      barcode TEXT
    )''');
    await db.execute('''CREATE TABLE customers(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      phone TEXT,
      address TEXT
    )''');
    await db.execute('''CREATE TABLE invoices(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_id INTEGER,
      customer_name TEXT,
      total REAL NOT NULL,
      discount REAL NOT NULL DEFAULT 0,
      paid REAL NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL
    )''');
    await db.execute('''CREATE TABLE invoice_items(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      invoice_id INTEGER NOT NULL,
      product_id INTEGER NOT NULL,
      product_name TEXT NOT NULL,
      price REAL NOT NULL,
      quantity INTEGER NOT NULL,
      total REAL NOT NULL
    )''');
    await db.execute('''CREATE TABLE expenses(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      amount REAL NOT NULL,
      created_at TEXT NOT NULL
    )''');
    await db.execute('''CREATE TABLE settings(
      key TEXT PRIMARY KEY,
      value TEXT
    )''');
  }

  Future<List<Map<String,dynamic>>> getProducts() async =>
      (await database).query('products', orderBy: 'id DESC');

  Future<int> addProduct(String name, double price, int quantity, {String? barcode}) async =>
      (await database).insert('products', {'name':name,'price':price,'quantity':quantity,'barcode':barcode});

  Future<int> updateProduct(int id, String name, double price, int quantity, {String? barcode}) async =>
      (await database).update('products', {'name':name,'price':price,'quantity':quantity,'barcode':barcode}, where:'id=?', whereArgs:[id]);

  Future<int> deleteProduct(int id) async =>
      (await database).delete('products', where:'id=?', whereArgs:[id]);

  Future<List<Map<String,dynamic>>> getCustomers() async =>
      (await database).query('customers', orderBy:'id DESC');

  Future<int> addCustomer(String name, String phone, String address) async =>
      (await database).insert('customers', {'name':name,'phone':phone,'address':address});

  Future<int> deleteCustomer(int id) async =>
      (await database).delete('customers', where:'id=?', whereArgs:[id]);

  Future<List<Map<String,dynamic>>> getInvoices() async =>
      (await database).query('invoices', orderBy:'id DESC');

  Future<List<Map<String,dynamic>>> getExpenses() async =>
      (await database).query('expenses', orderBy:'id DESC');

  Future<int> addExpense(String title, double amount, String date) async =>
      (await database).insert('expenses', {'title':title,'amount':amount,'created_at':date});

  Future<int> deleteExpense(int id) async =>
      (await database).delete('expenses', where:'id=?', whereArgs:[id]);

  Future<String?> getSetting(String key) async {
    final rows = await (await database).query('settings', where:'key=?', whereArgs:[key]);
    return rows.isEmpty ? null : rows.first['value'] as String?;
  }

  Future<void> setSetting(String key, String value) async {
    await (await database).insert('settings', {'key':key,'value':value},
      conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> createInvoice({
    int? customerId,
    String? customerName,
    required double total,
    required double discount,
    required double paid,
    required String createdAt,
    required List<Map<String,dynamic>> items,
  }) async {
    final db = await database;
    return db.transaction((txn) async {
      final invoiceId = await txn.insert('invoices', {
        'customer_id': customerId,
        'customer_name': customerName,
        'total': total,
        'discount': discount,
        'paid': paid,
        'created_at': createdAt,
      });
      for (final item in items) {
        await txn.insert('invoice_items', {
          'invoice_id': invoiceId,
          'product_id': item['id'],
          'product_name': item['name'],
          'price': item['price'],
          'quantity': item['sellQuantity'],
          'total': item['price'] * item['sellQuantity'],
        });
        await txn.rawUpdate(
          'UPDATE products SET quantity = quantity - ? WHERE id = ?',
          [item['sellQuantity'], item['id']],
        );
      }
      return invoiceId;
    });
  }

  Future<Map<String,dynamic>> dashboardStats() async {
    final db = await database;
    final p = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM products')) ?? 0;
    final c = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM customers')) ?? 0;
    final s = await db.rawQuery('SELECT COALESCE(SUM(total),0) AS v FROM invoices');
    final e = await db.rawQuery('SELECT COALESCE(SUM(amount),0) AS v FROM expenses');
    return {'products':p,'customers':c,'sales':(s.first['v'] as num).toDouble(),'expenses':(e.first['v'] as num).toDouble()};
  }
}
