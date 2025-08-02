import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/restaurant.dart';

abstract class RestaurantRepository {
  Future<Either<Failure, List<Restaurant>>> getRestaurants();

  Future<Either<Failure, List<Restaurant>>> searchRestaurants(String query);
}
