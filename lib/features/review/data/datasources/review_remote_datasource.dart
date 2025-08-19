import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../restaurant_detail/data/models/add_review_response_model.dart';
import '../../../restaurant_detail/data/models/review_model.dart';

/// Remote data source responsible for sending new restaurant reviews to the
/// Dicoding Restaurant API and returning the updated list of customer reviews.
abstract class ReviewRemoteDataSource {
  /// Sends the review [name] and [review] for restaurant with [id].
  ///
  /// Returns the updated list of [ReviewModel] on success or throws
  /// [ServerException] / [NetworkException] otherwise.
  Future<List<ReviewModel>> addReview({
    required String id,
    required String name,
    required String review,
  });
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final DioClient dioClient;

  const ReviewRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ReviewModel>> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.addReviewEndpoint,
        data: {'id': id, 'name': name, 'review': review},
        options: ApiConstants.headers,
      );

      final addReviewResponse = AddReviewResponseModel.fromJson(response.data);

      if (addReviewResponse.error) {
        throw ServerException(addReviewResponse.message);
      }

      return addReviewResponse.customerReviews;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to add review: ${e.toString()}');
    }
  }
}
