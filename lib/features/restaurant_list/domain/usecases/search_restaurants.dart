import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

class SearchRestaurants {
  final RestaurantRepository repository;

  const SearchRestaurants(this.repository);

  Future<Either<Failure, List<Restaurant>>> call(String query) async {
    if (query.trim().isEmpty) {
      return const Left(ValidationFailure('Search query cannot be empty'));
    }

    return await repository.searchRestaurants(query.trim());
  }
}
