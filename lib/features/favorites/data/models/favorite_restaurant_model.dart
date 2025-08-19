import 'package:equatable/equatable.dart';
import '../../domain/entities/favorite_restaurant.dart';

class FavoriteRestaurantModel extends Equatable {
  final String id;
  final String name;
  final String city;
  final double rating;
  final String pictureId;
  final String description;
  final DateTime createdAt;

  const FavoriteRestaurantModel({
    required this.id,
    required this.name,
    required this.city,
    required this.rating,
    required this.pictureId,
    required this.description,
    required this.createdAt,
  });

  // Convert from Entity to Model
  factory FavoriteRestaurantModel.fromEntity(FavoriteRestaurant entity) {
    return FavoriteRestaurantModel(
      id: entity.id,
      name: entity.name,
      city: entity.city,
      rating: entity.rating,
      pictureId: entity.pictureId,
      description: entity.description,
      createdAt: entity.createdAt,
    );
  }

  // Convert from Database Map to Model
  factory FavoriteRestaurantModel.fromMap(Map<String, dynamic> map) {
    return FavoriteRestaurantModel(
      id: map['id'] as String,
      name: map['name'] as String,
      city: map['city'] as String,
      rating: (map['rating'] as num).toDouble(),
      pictureId: map['pictureId'] as String,
      description: map['description'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // Convert Model to Database Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'rating': rating,
      'pictureId': pictureId,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convert Model to Entity
  FavoriteRestaurant toEntity() {
    return FavoriteRestaurant(
      id: id,
      name: name,
      city: city,
      rating: rating,
      pictureId: pictureId,
      description: description,
      createdAt: createdAt,
    );
  }

  // Create a copy with updated fields
  FavoriteRestaurantModel copyWith({
    String? id,
    String? name,
    String? city,
    double? rating,
    String? pictureId,
    String? description,
    DateTime? createdAt,
  }) {
    return FavoriteRestaurantModel(
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
    return 'FavoriteRestaurantModel('
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