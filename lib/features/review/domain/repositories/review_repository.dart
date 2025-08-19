import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../restaurant_detail/domain/entities/review.dart';

/// Repository contract for adding a new customer review to a restaurant.
abstract class ReviewRepository {
  /// Adds a customer review for restaurant with [id].
  ///
  /// Returns the updated list of [Review] on success or a [Failure] on error.
  Future<Either<Failure, List<Review>>> addReview({
    required String id,
    required String name,
    required String review,
  });
}