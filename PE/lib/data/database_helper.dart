import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/expense.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'expenses_database.db');
    _database = await openDatabase(path, version: 2, onCreate: _createDatabase);
    return _database!;
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        category TEXT NOT NULL,
        day TEXT NOT NULL
      )
    ''');

    final samples = [
      Expense(
        title: 'Ăn uống',
        price: 150000,
        category: 'sinh hoạt',
        day: DateTime.now(),
      ),
      Expense(
        title: 'Vé xe buýt',
        price: 10000,
        category: 'Đi lại',
        day: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Expense(
        title: 'Mua sách ',
        price: 180000,
        category: 'Học tập',
        day: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Expense(
        title: 'Mua sắm ',
        price: 1500000,
        category: 'Sinh hoạt',
        day: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Expense(
        title: 'Khám bệnh ',
        price: 3500000,
        category: 'Sức khỏe',
        day: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
    for (final sample in samples) {
      await db.insert('expenses', sample.toMap());
    }
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final result = await db.query('expenses', orderBy: 'day DESC, id DESC');
    return result.map(Expense.fromMap).toList();
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return db.insert('expenses', expense.toMap());
  }

  Future<int> updateExpense(Expense expense) async {
    final id = expense.id;
    if (id == null) {
      throw ArgumentError.value(
        id,
        'expense.id',
        'An ID is required to update an expense.',
      );
    }
    final db = await database;
    return db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = _database;
    if (db == null) return;
    await db.close();
    _database = null;
  }
}
