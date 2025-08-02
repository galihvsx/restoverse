import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  @override
  List<Object?> get props => [id, name, description, pictureId, city, rating];

  @override
  String toString() {
    return 'Restaurant(id: $id, name: $name, city: $city, rating: $rating)';
  }
}
