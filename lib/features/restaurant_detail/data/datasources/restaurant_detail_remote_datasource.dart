import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/add_review_response_model.dart';
import '../models/restaurant_detail_model.dart';
import '../models/restaurant_detail_response_model.dart';
import '../models/review_model.dart';

abstract class RestaurantDetailRemoteDataSource {
  Future<RestaurantDetailModel> getRestaurantDetail(String id);

  Future<List<ReviewModel>> addReview({
    required String id,
    required String name,
    required String review,
  });
}

class RestaurantDetailRemoteDataSourceImpl
    implements RestaurantDetailRemoteDataSource {
  final DioClient dioClient;

  const RestaurantDetailRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<RestaurantDetailModel> getRestaurantDetail(String id) async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.restaurantDetailEndpoint}/$id',
      );

      final restaurantDetailResponse = RestaurantDetailResponseModel.fromJson(
        response.data,
      );

      if (restaurantDetailResponse.error) {
        throw ServerException(restaurantDetailResponse.message);
      }

      return restaurantDetailResponse.restaurant;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to get restaurant detail: ${e.toString()}');
    }
  }

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
