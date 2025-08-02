import 'package:flutter/foundation.dart';

import '../../../../core/utils/api_state.dart';
import '../../domain/entities/restaurant_detail.dart';
import '../../domain/usecases/get_restaurant_detail.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final GetRestaurantDetail getRestaurantDetail;

  RestaurantDetailProvider({required this.getRestaurantDetail});

  ApiState<RestaurantDetail> _restaurantDetailState = const ApiInitial();

  ApiState<RestaurantDetail> get restaurantDetailState =>
      _restaurantDetailState;

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

  void _setRestaurantDetailState(ApiState<RestaurantDetail> state) {
    _restaurantDetailState = state;
    notifyListeners();
  }
}
