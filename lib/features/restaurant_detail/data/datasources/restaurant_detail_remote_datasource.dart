import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/restaurant_detail_model.dart';
import '../models/restaurant_detail_response_model.dart';

abstract class RestaurantDetailRemoteDataSource {
  Future<RestaurantDetailModel> getRestaurantDetail(String id);
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
}
