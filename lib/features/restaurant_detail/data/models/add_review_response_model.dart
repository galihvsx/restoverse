import 'review_model.dart';

class AddReviewResponseModel {
  final bool error;
  final String message;
  final List<ReviewModel> customerReviews;

  const AddReviewResponseModel({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory AddReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return AddReviewResponseModel(
      error: json['error'] as bool,
      message: json['message'] as String,
      customerReviews: (json['customerReviews'] as List<dynamic>)
          .map((review) => ReviewModel.fromJson(review as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'customerReviews': customerReviews
          .map((review) => review.toJson())
          .toList(),
    };
  }
}