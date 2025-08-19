import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String _databaseName = 'restoverse.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String tableFavorites = 'favorites';

  // Favorites table columns
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnCity = 'city';
  static const String columnRating = 'rating';
  static const String columnPictureId = 'pictureId';
  static const String columnDescription = 'description';
  static const String columnCreatedAt = 'createdAt';

  static Database? _database;

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Get database instance
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableFavorites (
        $columnId TEXT PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnCity TEXT NOT NULL,
        $columnRating REAL NOT NULL,
        $columnPictureId TEXT NOT NULL,
        $columnDescription TEXT,
        $columnCreatedAt INTEGER NOT NULL
      )
    ''');
  }

  // Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database schema upgrades here if needed in the future
  }

  // Insert favorite restaurant
  Future<int> insertFavorite(Map<String, dynamic> favorite) async {
    final db = await database;
    return await db.insert(
      tableFavorites,
      favorite,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all favorite restaurants
  Future<List<Map<String, dynamic>>> getAllFavorites() async {
    final db = await database;
    return await db.query(
      tableFavorites,
      orderBy: '$columnCreatedAt DESC',
    );
  }

  // Get favorite restaurant by ID
  Future<Map<String, dynamic>?> getFavoriteById(String id) async {
    final db = await database;
    final results = await db.query(
      tableFavorites,
      where: '$columnId = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  // Check if restaurant is favorite
  Future<bool> isFavorite(String id) async {
    final db = await database;
    final results = await db.query(
      tableFavorites,
      where: '$columnId = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty;
  }

  // Delete favorite restaurant
  Future<int> deleteFavorite(String id) async {
    final db = await database;
    return await db.delete(
      tableFavorites,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Delete all favorites
  Future<int> deleteAllFavorites() async {
    final db = await database;
    return await db.delete(tableFavorites);
  }

  // Get favorites count
  Future<int> getFavoritesCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM $tableFavorites');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Close database
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}