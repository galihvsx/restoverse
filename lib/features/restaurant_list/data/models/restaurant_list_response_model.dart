import 'restaurant_model.dart';

class RestaurantListResponseModel {
  final bool error;
  final String? message;
  final int count;
  final List<RestaurantModel> restaurants;

  const RestaurantListResponseModel({
    required this.error,
    this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantListResponseModel.fromJson(Map<String, dynamic> json) {
    return RestaurantListResponseModel(
      error: json['error'] as bool,
      message: json['message'] as String?,
      count: (json['count'] ?? json['founded'] ?? 0) as int,
      restaurants: (json['restaurants'] as List<dynamic>)
          .map(
            (restaurant) =>
                RestaurantModel.fromJson(restaurant as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'count': count,
      'restaurants': restaurants
          .map((restaurant) => restaurant.toJson())
          .toList(),
    };
  }
}
