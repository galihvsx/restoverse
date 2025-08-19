import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/favorite_restaurant.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_local_datasource.dart';
import '../models/favorite_restaurant_model.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteLocalDataSource localDataSource;

  FavoriteRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> addFavorite(FavoriteRestaurant restaurant) async {
    try {
      final model = FavoriteRestaurantModel.fromEntity(restaurant);
      await localDataSource.insertFavorite(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to add favorite: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<FavoriteRestaurant>>> getAllFavorites() async {
    try {
      final models = await localDataSource.getAllFavorites();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(CacheFailure('Failed to get all favorites: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, FavoriteRestaurant?>> getFavoriteById(String id) async {
    try {
      final model = await localDataSource.getFavoriteById(id);
      final entity = model?.toEntity();
      return Right(entity);
    } catch (e) {
      return Left(CacheFailure('Failed to get favorite by id: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String id) async {
    try {
      final result = await localDataSource.isFavorite(id);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure('Failed to check if favorite: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String id) async {
    try {
      await localDataSource.deleteFavorite(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to remove favorite: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeAllFavorites() async {
    try {
      await localDataSource.deleteAllFavorites();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to remove all favorites: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> getFavoritesCount() async {
    try {
      final count = await localDataSource.getFavoritesCount();
      return Right(count);
    } catch (e) {
      return Left(CacheFailure('Failed to get favorites count: ${e.toString()}'));
    }
  }
}