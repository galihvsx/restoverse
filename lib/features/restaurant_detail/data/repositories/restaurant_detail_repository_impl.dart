import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/restaurant_detail.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/restaurant_detail_repository.dart';
import '../datasources/restaurant_detail_remote_datasource.dart';

class RestaurantDetailRepositoryImpl implements RestaurantDetailRepository {
  final RestaurantDetailRemoteDataSource remoteDataSource;

  const RestaurantDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RestaurantDetail>> getRestaurantDetail(
    String id,
  ) async {
    try {
      final restaurantDetailModel = await remoteDataSource.getRestaurantDetail(
        id,
      );
      final restaurantDetail = restaurantDetailModel.toEntity();
      return Right(restaurantDetail);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Review>>> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      final reviewModels = await remoteDataSource.addReview(
        id: id,
        name: name,
        review: review,
      );
      final reviews = reviewModels.map((model) => model.toEntity()).toList();
      return Right(reviews);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
