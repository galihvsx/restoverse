import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_remote_datasource.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;

  const RestaurantRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Restaurant>>> getRestaurants() async {
    try {
      final restaurantModels = await remoteDataSource.getRestaurants();
      final restaurants = restaurantModels
          .map((model) => model.toEntity())
          .toList();
      return Right(restaurants);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Restaurant>>> searchRestaurants(
    String query,
  ) async {
    try {
      final restaurantModels = await remoteDataSource.searchRestaurants(query);
      final restaurants = restaurantModels
          .map((model) => model.toEntity())
          .toList();
      return Right(restaurants);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
