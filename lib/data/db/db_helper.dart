import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'kitasehat.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        username TEXT PRIMARY KEY,
        password TEXT NOT NULL,
        fullName TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions(
        transactionId TEXT PRIMARY KEY,
        medicineId TEXT NOT NULL,
        medicineName TEXT NOT NULL,
        medicineCategory TEXT NOT NULL,
        medicinePrice REAL NOT NULL,
        medicineImage TEXT NOT NULL,
        buyerName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        totalPrice REAL NOT NULL,
        date TEXT NOT NULL,
        notes TEXT,
        purchaseMethod TEXT NOT NULL,
        recipeNumber TEXT,
        recipeImagePath TEXT,
        status TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE transactions ADD COLUMN recipeImagePath TEXT
      ''');
    }
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
