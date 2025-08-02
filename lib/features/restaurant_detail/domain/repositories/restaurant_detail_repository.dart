import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/restaurant_detail.dart';

abstract class RestaurantDetailRepository {
  Future<Either<Failure, RestaurantDetail>> getRestaurantDetail(String id);
}
