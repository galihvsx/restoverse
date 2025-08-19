import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/favorite_repository.dart';

class RemoveFavorite {
  final FavoriteRepository repository;

  RemoveFavorite(this.repository);

  Future<Either<Failure, void>> call(String restaurantId) async {
    return await repository.removeFavorite(restaurantId);
  }
}