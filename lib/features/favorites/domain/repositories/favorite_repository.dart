import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/favorite_restaurant.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, void>> addFavorite(FavoriteRestaurant restaurant);
  Future<Either<Failure, List<FavoriteRestaurant>>> getAllFavorites();
  Future<Either<Failure, FavoriteRestaurant?>> getFavoriteById(String id);
  Future<Either<Failure, bool>> isFavorite(String id);
  Future<Either<Failure, void>> removeFavorite(String id);
  Future<Either<Failure, void>> removeAllFavorites();
  Future<Either<Failure, int>> getFavoritesCount();
}