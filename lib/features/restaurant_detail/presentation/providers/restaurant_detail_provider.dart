import 'package:flutter/foundation.dart';

import '../../../../core/utils/api_state.dart';
import '../../domain/entities/restaurant_detail.dart';
import '../../domain/entities/review.dart';
import '../../domain/usecases/add_review.dart';
import '../../domain/usecases/get_restaurant_detail.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final GetRestaurantDetail getRestaurantDetail;
  final AddReview addReview;

  RestaurantDetailProvider({
    required this.getRestaurantDetail,
    required this.addReview,
  });

  ApiState<RestaurantDetail> _restaurantDetailState = const ApiInitial();

  ApiState<RestaurantDetail> get restaurantDetailState =>
      _restaurantDetailState;

  ApiState<List<Review>> _addReviewState = const ApiInitial();

  ApiState<List<Review>> get addReviewState => _addReviewState;

  RestaurantDetail? _currentRestaurant;

  RestaurantDetail? get currentRestaurant => _currentRestaurant;

  Future<void> fetchRestaurantDetail(String id) async {
    _setRestaurantDetailState(const ApiLoading());

    final result = await getRestaurantDetail(id);
    result.fold((failure) => _setRestaurantDetailState(ApiError(failure)), (
      restaurantDetail,
    ) {
      _currentRestaurant = restaurantDetail;
      _setRestaurantDetailState(ApiSuccess(restaurantDetail));
    });
  }

  Future<void> submitReview({
    required String id,
    required String name,
    required String review,
  }) async {
    _setAddReviewState(const ApiLoading());

    final result = await addReview(id: id, name: name, review: review);

    result.fold((failure) => _setAddReviewState(ApiError(failure)), (reviews) {
      _setAddReviewState(ApiSuccess(reviews));
      if (_currentRestaurant != null) {
        _currentRestaurant = RestaurantDetail(
          id: _currentRestaurant!.id,
          name: _currentRestaurant!.name,
          description: _currentRestaurant!.description,
          city: _currentRestaurant!.city,
          address: _currentRestaurant!.address,
          pictureId: _currentRestaurant!.pictureId,
          categories: _currentRestaurant!.categories,
          menus: _currentRestaurant!.menus,
          rating: _currentRestaurant!.rating,
          customerReviews: reviews,
        );
        _setRestaurantDetailState(ApiSuccess(_currentRestaurant!));
      }
    });
  }

  void clearAddReviewState() {
    _setAddReviewState(const ApiInitial());
  }

  void _setRestaurantDetailState(ApiState<RestaurantDetail> state) {
    _restaurantDetailState = state;
    notifyListeners();
  }

  void _setAddReviewState(ApiState<List<Review>> state) {
    _addReviewState = state;
    notifyListeners();
  }
}
