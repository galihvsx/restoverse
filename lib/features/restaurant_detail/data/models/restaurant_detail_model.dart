import '../../domain/entities/restaurant_detail.dart';
import 'category_model.dart';
import 'menu_model.dart';
import 'review_model.dart';

class RestaurantDetailModel extends RestaurantDetail {
  const RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.description,
    required super.city,
    required super.address,
    required super.pictureId,
    required super.categories,
    required super.menus,
    required super.rating,
    required super.customerReviews,
  });

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      pictureId: json['pictureId'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map(
            (category) =>
                CategoryModel.fromJson(category as Map<String, dynamic>),
          )
          .toList(),
      menus: MenuModel.fromJson(json['menus'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toDouble(),
      customerReviews: (json['customerReviews'] as List<dynamic>)
          .map((review) => ReviewModel.fromJson(review as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'city': city,
      'address': address,
      'pictureId': pictureId,
      'categories': categories
          .map((category) => (category as CategoryModel).toJson())
          .toList(),
      'menus': (menus as MenuModel).toJson(),
      'rating': rating,
      'customerReviews': customerReviews
          .map((review) => (review as ReviewModel).toJson())
          .toList(),
    };
  }

  RestaurantDetail toEntity() {
    return RestaurantDetail(
      id: id,
      name: name,
      description: description,
      city: city,
      address: address,
      pictureId: pictureId,
      categories: categories,
      menus: menus,
      rating: rating,
      customerReviews: customerReviews,
    );
  }

  factory RestaurantDetailModel.fromEntity(RestaurantDetail restaurantDetail) {
    return RestaurantDetailModel(
      id: restaurantDetail.id,
      name: restaurantDetail.name,
      description: restaurantDetail.description,
      city: restaurantDetail.city,
      address: restaurantDetail.address,
      pictureId: restaurantDetail.pictureId,
      categories: restaurantDetail.categories,
      menus: restaurantDetail.menus,
      rating: restaurantDetail.rating,
      customerReviews: restaurantDetail.customerReviews,
    );
  }
}
