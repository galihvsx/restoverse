import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/restaurant_detail.dart';
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
}
