import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../restaurant_detail/data/models/review_model.dart';
import '../../../restaurant_detail/domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_datasource.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  const ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Review>>> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      final List<ReviewModel> reviewModels = await remoteDataSource.addReview(
        id: id,
        name: name,
        review: review,
      );
      final reviews = reviewModels.map((e) => e.toEntity()).toList();
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
