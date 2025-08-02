import 'restaurant_detail_model.dart';

class RestaurantDetailResponseModel {
  final bool error;
  final String message;
  final RestaurantDetailModel restaurant;

  const RestaurantDetailResponseModel({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponseModel(
      error: json['error'] as bool,
      message: json['message'] as String,
      restaurant: RestaurantDetailModel.fromJson(
        json['restaurant'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'restaurant': restaurant.toJson(),
    };
  }
}
