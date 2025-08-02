import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/restaurant_detail.dart';
import '../entities/review.dart';

abstract class RestaurantDetailRepository {
  Future<Either<Failure, RestaurantDetail>> getRestaurantDetail(String id);

  Future<Either<Failure, List<Review>>> addReview({
    required String id,
    required String name,
    required String review,
  });
}
