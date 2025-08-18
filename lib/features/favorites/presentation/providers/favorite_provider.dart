import 'package:flutter/foundation.dart';
import '../../domain/entities/favorite_restaurant.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/is_favorite.dart';
import '../../domain/usecases/remove_favorite.dart';

// Sealed class for favorite state
sealed class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<FavoriteRestaurant> favorites;
  
  FavoriteLoaded(this.favorites);
}

class FavoriteError extends FavoriteState {
  final String message;
  
  FavoriteError(this.message);
}

class FavoriteProvider extends ChangeNotifier {
  final GetFavorites _getFavorites;
  final AddFavorite _addFavorite;
  final RemoveFavorite _removeFavorite;
  final IsFavorite _isFavorite;

  FavoriteProvider({
    required GetFavorites getFavorites,
    required AddFavorite addFavorite,
    required RemoveFavorite removeFavorite,
    required IsFavorite isFavorite,
  })
      : _getFavorites = getFavorites,
        _addFavorite = addFavorite,
        _removeFavorite = removeFavorite,
        _isFavorite = isFavorite;

  FavoriteState _state = FavoriteInitial();
  FavoriteState get state => _state;

  List<FavoriteRestaurant> get favorites {
    if (_state is FavoriteLoaded) {
      return (_state as FavoriteLoaded).favorites;
    }
    return [];
  }

  void _setState(FavoriteState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    _setState(FavoriteLoading());
    
    final result = await _getFavorites();
    result.fold(
      (failure) => _setState(FavoriteError(failure.message)),
      (favorites) => _setState(FavoriteLoaded(favorites)),
    );
  }

  Future<void> addToFavorites(FavoriteRestaurant restaurant) async {
    final result = await _addFavorite(restaurant);
    result.fold(
      (failure) {
        _setState(FavoriteError(failure.message));
      },
      (_) {
        // Reload favorites after adding
        loadFavorites();
      },
    );
  }

  Future<void> removeFromFavorites(String restaurantId) async {
    final result = await _removeFavorite(restaurantId);
    result.fold(
      (failure) {
        _setState(FavoriteError(failure.message));
      },
      (_) {
        // Reload favorites after removing
        loadFavorites();
      },
    );
  }

  Future<bool> checkIsFavorite(String restaurantId) async {
    final result = await _isFavorite(restaurantId);
    return result.fold(
      (failure) {
        if (kDebugMode) {
          print('Error checking favorite status: ${failure.message}');
        }
        return false;
      },
      (isFavorite) => isFavorite,
    );
  }

  Future<void> toggleFavorite(FavoriteRestaurant restaurant) async {
    final isFavorite = await checkIsFavorite(restaurant.id);
    
    if (isFavorite) {
      await removeFromFavorites(restaurant.id);
    } else {
      await addToFavorites(restaurant);
    }
  }

  void clearError() {
    if (_state is FavoriteError) {
      _setState(FavoriteInitial());
    }
  }
}