import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/favorite_repository.dart';

class IsFavorite {
  final FavoriteRepository repository;

  IsFavorite(this.repository);

  Future<Either<Failure, bool>> call(String restaurantId) async {
    return await repository.isFavorite(restaurantId);
  }
}