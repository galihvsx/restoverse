import 'package:flutter/foundation.dart';

import '../../../../core/utils/api_state.dart';
import '../../domain/usecases/add_review.dart';
import '../../../restaurant_detail/domain/entities/review.dart';

/// Provider that manages the state of adding customer reviews and the list of
/// reviews associated with a restaurant.
class ReviewProvider extends ChangeNotifier {
  final AddReview addReview;

  ReviewProvider({required this.addReview});

  ApiState<List<Review>> _reviewState = const ApiInitial();
  ApiState<List<Review>> get reviewState => _reviewState;

  List<Review> _reviews = [];
  List<Review> get reviews => _reviews;

  /// Sets the initial reviews, typically called when opening the detail page
  /// so the form has the latest list before any new submission.
  void setInitialReviews(List<Review> initialReviews) {
    _reviews = initialReviews;
    _setReviewState(ApiSuccess(initialReviews));
  }

  /// Submits a new customer review using [AddReview] use case.
  Future<void> submitReview({
    required String restaurantId,
    required String name,
    required String review,
  }) async {
    _setReviewState(const ApiLoading());

    final result = await addReview(
      id: restaurantId,
      name: name,
      review: review,
    );

    result.fold(
      (failure) => _setReviewState(ApiError(failure)),
      (updatedReviews) {
        _reviews = updatedReviews;
        _setReviewState(ApiSuccess(updatedReviews));
      },
    );
  }

  void _setReviewState(ApiState<List<Review>> state) {
    _reviewState = state;
    notifyListeners();
  }
}