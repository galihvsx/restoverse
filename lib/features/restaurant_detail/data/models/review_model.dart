import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.name,
    required super.review,
    required super.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      name: json['name'] as String,
      review: json['review'] as String,
      date: json['date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'review': review, 'date': date};
  }

  Review toEntity() {
    return Review(name: name, review: review, date: date);
  }

  factory ReviewModel.fromEntity(Review review) {
    return ReviewModel(
      name: review.name,
      review: review.review,
      date: review.date,
    );
  }
}
