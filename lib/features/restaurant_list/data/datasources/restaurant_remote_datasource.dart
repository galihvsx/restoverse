import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/restaurant_list_response_model.dart';
import '../models/restaurant_model.dart';

abstract class RestaurantRemoteDataSource {
  Future<List<RestaurantModel>> getRestaurants();

  Future<List<RestaurantModel>> searchRestaurants(String query);
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final DioClient dioClient;

  const RestaurantRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<RestaurantModel>> getRestaurants() async {
    try {
      final response = await dioClient.get(ApiConstants.restaurantListEndpoint);

      final restaurantListResponse = RestaurantListResponseModel.fromJson(
        response.data,
      );

      if (restaurantListResponse.error) {
        throw ServerException(
          restaurantListResponse.message ?? 'Server error occurred',
        );
      }

      return restaurantListResponse.restaurants;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to get restaurants: ${e.toString()}');
    }
  }

  @override
  Future<List<RestaurantModel>> searchRestaurants(String query) async {
    try {
      final response = await dioClient.get(
        ApiConstants.searchRestaurantEndpoint,
        queryParameters: {'q': query},
      );

      final restaurantListResponse = RestaurantListResponseModel.fromJson(
        response.data,
      );

      if (restaurantListResponse.error) {
        throw ServerException(
          restaurantListResponse.message ?? 'Server error occurred',
        );
      }

      return restaurantListResponse.restaurants;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to search restaurants: ${e.toString()}');
    }
  }
}
