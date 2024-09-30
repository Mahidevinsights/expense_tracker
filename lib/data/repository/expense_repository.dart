import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense_model.dart';

class ExpenseRepository {
  static final ExpenseRepository instance = ExpenseRepository._init();
  static Database? _database;

  ExpenseRepository._init();

  // Database getter that initializes if necessary
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Create the database schema
  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE expenses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      description TEXT NOT NULL,
      amount REAL NOT NULL,
      date TEXT NOT NULL
    )
    ''');
  }

  // Add a new expense to the database
  Future<int> addExpense(ExpenseModel expense) async {
    final db = await database; // Avoid `instance.database`
    return await db.insert('expenses', expense.toMap());
  }

  // Fetch all expenses from the database
  Future<List<ExpenseModel>> fetchExpenses() async {
    final db = await database;
    final maps = await db.query('expenses');
    return maps.map((e) => ExpenseModel.fromMap(e)).toList();
  }

  // Update an existing expense
  Future<int> updateExpense(ExpenseModel expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // Delete an expense by ID
  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database (good practice to avoid memory leaks)
  Future close() async {
    final db = await database;
    db.close();
  }
}
