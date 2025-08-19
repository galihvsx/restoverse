import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/favorite_restaurant.dart';
import '../repositories/favorite_repository.dart';

class GetFavorites {
  final FavoriteRepository repository;

  GetFavorites(this.repository);

  Future<Either<Failure, List<FavoriteRestaurant>>> call() async {
    return await repository.getAllFavorites();
  }
}