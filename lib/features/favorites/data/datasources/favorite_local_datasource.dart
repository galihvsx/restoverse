import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/favorite_restaurant_model.dart';

abstract class FavoriteLocalDataSource {
  Future<void> insertFavorite(FavoriteRestaurantModel restaurant);
  Future<List<FavoriteRestaurantModel>> getAllFavorites();
  Future<FavoriteRestaurantModel?> getFavoriteById(String id);
  Future<bool> isFavorite(String id);
  Future<void> deleteFavorite(String id);
  Future<void> deleteAllFavorites();
  Future<int> getFavoritesCount();
}

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  final DatabaseHelper databaseHelper;

  FavoriteLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> insertFavorite(FavoriteRestaurantModel restaurant) async {
    try {
      final db = await databaseHelper.database;
      await db.insert(
        'favorites',
        restaurant.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Failed to insert favorite: $e');
    }
  }

  @override
  Future<List<FavoriteRestaurantModel>> getAllFavorites() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'favorites',
        orderBy: 'createdAt DESC',
      );

      return List.generate(maps.length, (i) {
        return FavoriteRestaurantModel.fromMap(maps[i]);
      });
    } catch (e) {
      throw Exception('Failed to get all favorites: $e');
    }
  }

  @override
  Future<FavoriteRestaurantModel?> getFavoriteById(String id) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'favorites',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return FavoriteRestaurantModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get favorite by id: $e');
    }
  }

  @override
  Future<bool> isFavorite(String id) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'favorites',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      return maps.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check if favorite: $e');
    }
  }

  @override
  Future<void> deleteFavorite(String id) async {
    try {
      final db = await databaseHelper.database;
      final deletedRows = await db.delete(
        'favorites',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (deletedRows == 0) {
        throw Exception('Favorite with id $id not found');
      }
    } catch (e) {
      throw Exception('Failed to delete favorite: $e');
    }
  }

  @override
  Future<void> deleteAllFavorites() async {
    try {
      final db = await databaseHelper.database;
      await db.delete('favorites');
    } catch (e) {
      throw Exception('Failed to delete all favorites: $e');
    }
  }

  @override
  Future<int> getFavoritesCount() async {
    try {
      final db = await databaseHelper.database;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM favorites');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw Exception('Failed to get favorites count: $e');
    }
  }
}