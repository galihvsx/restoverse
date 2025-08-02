import 'package:flutter/foundation.dart';

import '../../../../core/utils/api_state.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/usecases/get_restaurants.dart';
import '../../domain/usecases/search_restaurants.dart';

class RestaurantListProvider extends ChangeNotifier {
  final GetRestaurants getRestaurants;
  final SearchRestaurants searchRestaurants;

  RestaurantListProvider({
    required this.getRestaurants,
    required this.searchRestaurants,
  });

  ApiState<List<Restaurant>> _restaurantListState = const ApiInitial();

  ApiState<List<Restaurant>> get restaurantListState => _restaurantListState;

  List<Restaurant> _allRestaurants = [];

  List<Restaurant> get allRestaurants => _allRestaurants;

  List<Restaurant> _displayedRestaurants = [];

  List<Restaurant> get displayedRestaurants => _displayedRestaurants;

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  bool get isSearching => _searchQuery.isNotEmpty;

  static const int _pageSize = 10;
  int _currentPage = 0;
  bool _isLoadingMore = false;

  bool get isLoadingMore => _isLoadingMore;

  bool get hasMoreData {
    if (isSearching) {
      return false;
    }
    return _displayedRestaurants.length < _allRestaurants.length;
  }

  Future<void> fetchRestaurants() async {
    _setRestaurantListState(const ApiLoading());
    _currentPage = 0;
    _displayedRestaurants.clear();

    final result = await getRestaurants();
    result.fold((failure) => _setRestaurantListState(ApiError(failure)), (
      restaurants,
    ) {
      _allRestaurants = restaurants;
      _loadInitialPage();
    });
  }

  void _loadInitialPage() {
    _currentPage = 0;
    final endIndex = (_currentPage + 1) * _pageSize;
    _displayedRestaurants = _allRestaurants.take(endIndex).toList();
    _setRestaurantListState(ApiSuccess(_displayedRestaurants));
  }

  Future<void> loadMoreData() async {
    if (_isLoadingMore || !hasMoreData || isSearching) return;

    _isLoadingMore = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _currentPage++;
    final startIndex = _currentPage * _pageSize;
    final endIndex = startIndex + _pageSize;

    final newItems = _allRestaurants.skip(startIndex).take(_pageSize).toList();
    _displayedRestaurants.addAll(newItems);

    _isLoadingMore = false;
    _setRestaurantListState(ApiSuccess(_displayedRestaurants));
  }

  Future<void> searchRestaurantsQuery(String query) async {
    _searchQuery = query;

    if (query.trim().isEmpty) {
      _loadInitialPage();
      notifyListeners();
      return;
    }

    _setRestaurantListState(const ApiLoading());

    final result = await searchRestaurants(query);
    result.fold((failure) => _setRestaurantListState(ApiError(failure)), (
      restaurants,
    ) {
      _displayedRestaurants = restaurants;
      _setRestaurantListState(ApiSuccess(restaurants));
    });
  }

  void clearSearch() {
    _searchQuery = '';
    _loadInitialPage();
  }

  Future<void> refreshRestaurants() async {
    await fetchRestaurants();
  }

  void _setRestaurantListState(ApiState<List<Restaurant>> state) {
    _restaurantListState = state;
    notifyListeners();
  }
}
