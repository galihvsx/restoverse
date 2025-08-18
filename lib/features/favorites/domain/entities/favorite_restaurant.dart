import 'package:equatable/equatable.dart';

class FavoriteRestaurant extends Equatable {
  final String id;
  final String name;
  final String city;
  final double rating;
  final String pictureId;
  final String description;
  final DateTime createdAt;

  const FavoriteRestaurant({
    required this.id,
    required this.name,
    required this.city,
    required this.rating,
    required this.pictureId,
    required this.description,
    required this.createdAt,
  });

  // Create a copy with updated fields
  FavoriteRestaurant copyWith({
    String? id,
    String? name,
    String? city,
    double? rating,
    String? pictureId,
    String? description,
    DateTime? createdAt,
  }) {
    return FavoriteRestaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      pictureId: pictureId ?? this.pictureId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        city,
        rating,
        pictureId,
        description,
        createdAt,
      ];

  @override
  String toString() {
    return 'FavoriteRestaurant('
        'id: $id, '
        'name: $name, '
        'city: $city, '
        'rating: $rating, '
        'pictureId: $pictureId, '
        'description: $description, '
        'createdAt: $createdAt'
        ')';
  }
}