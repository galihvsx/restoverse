import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/review.dart';
import '../repositories/restaurant_detail_repository.dart';

class AddReview {
  final RestaurantDetailRepository repository;

  const AddReview(this.repository);

  Future<Either<Failure, List<Review>>> call({
    required String id,
    required String name,
    required String review,
  }) async {
    if (id.trim().isEmpty) {
      return const Left(ValidationFailure('Restaurant ID cannot be empty'));
    }

    if (name.trim().isEmpty) {
      return const Left(ValidationFailure('Name cannot be empty'));
    }

    if (review.trim().isEmpty) {
      return const Left(ValidationFailure('Review cannot be empty'));
    }

    if (name.trim().length < 2) {
      return const Left(ValidationFailure('Name must be at least 2 characters'));
    }

    if (review.trim().length < 10) {
      return const Left(ValidationFailure('Review must be at least 10 characters'));
    }

    return await repository.addReview(
      id: id.trim(),
      name: name.trim(),
      review: review.trim(),
    );
  }
}