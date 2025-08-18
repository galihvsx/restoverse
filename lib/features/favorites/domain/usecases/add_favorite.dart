import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/favorite_restaurant.dart';
import '../repositories/favorite_repository.dart';

class AddFavorite {
  final FavoriteRepository repository;

  AddFavorite(this.repository);

  Future<Either<Failure, void>> call(FavoriteRestaurant restaurant) async {
    return await repository.addFavorite(restaurant);
  }
}