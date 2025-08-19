import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../restaurant_detail/domain/entities/review.dart';
import '../repositories/review_repository.dart';

/// Use case for adding a customer review for a restaurant.
///
/// Returns the updated list of reviews on success or a [Failure] on error.
class AddReview {
  final ReviewRepository repository;

  AddReview(this.repository);

  Future<Either<Failure, List<Review>>> call({
    required String id,
    required String name,
    required String review,
  }) async {
    return await repository.addReview(
      id: id,
      name: name,
      review: review,
    );
  }
}