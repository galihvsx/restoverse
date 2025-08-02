import 'package:equatable/equatable.dart';

import 'category.dart';
import 'menu.dart';
import 'review.dart';

class RestaurantDetail extends Equatable {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final List<Category> categories;
  final Menu menus;
  final double rating;
  final List<Review> customerReviews;

  const RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    city,
    address,
    pictureId,
    categories,
    menus,
    rating,
    customerReviews,
  ];

  @override
  String toString() {
    return 'RestaurantDetail(id: $id, name: $name, city: $city, rating: $rating)';
  }
}
