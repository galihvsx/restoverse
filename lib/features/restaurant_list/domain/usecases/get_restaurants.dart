import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurants {
  final RestaurantRepository repository;

  const GetRestaurants(this.repository);

  Future<Either<Failure, List<Restaurant>>> call() async {
    return await repository.getRestaurants();
  }
}
