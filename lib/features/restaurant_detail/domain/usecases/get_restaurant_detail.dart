import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/restaurant_detail.dart';
import '../repositories/restaurant_detail_repository.dart';

class GetRestaurantDetail {
  final RestaurantDetailRepository repository;

  const GetRestaurantDetail(this.repository);

  Future<Either<Failure, RestaurantDetail>> call(String id) async {
    if (id.trim().isEmpty) {
      return const Left(ValidationFailure('Restaurant ID cannot be empty'));
    }

    return await repository.getRestaurantDetail(id.trim());
  }
}
