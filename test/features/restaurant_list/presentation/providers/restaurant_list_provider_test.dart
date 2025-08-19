import 'package:dartz/dartz.dart';
import 'package:dcresto/core/errors/failures.dart';
import 'package:dcresto/core/utils/api_state.dart';
import 'package:dcresto/features/restaurant_list/domain/entities/restaurant.dart';
import 'package:dcresto/features/restaurant_list/presentation/providers/restaurant_list_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetRestaurants mockGetRestaurants;
  late MockSearchRestaurants mockSearchRestaurants;
  late RestaurantListProvider provider;

  setUp(() {
    mockGetRestaurants = MockGetRestaurants();
    mockSearchRestaurants = MockSearchRestaurants();
    provider = RestaurantListProvider(
      getRestaurants: mockGetRestaurants,
      searchRestaurants: mockSearchRestaurants,
    );
  });

  group('Initial State', () {
    test('should have ApiInitial state on creation', () {
      expect(provider.restaurantListState, isA<ApiInitial<List<Restaurant>>>());
      expect(provider.displayedRestaurants, isEmpty);
    });
  });

  group('Fetch Restaurants', () {
    const tRestaurant = Restaurant(
      id: '1',
      name: 'Testaurant',
      description: 'Desc',
      pictureId: 'pic',
      city: 'City',
      rating: 4.5,
    );

    final tRestaurantList = [tRestaurant];

    test('should return data when call to usecase is successful', () async {
      // arrange
      when(
        mockGetRestaurants(),
      ).thenAnswer((_) async => Right(tRestaurantList));

      // act
      await provider.fetchRestaurants();

      // assert
      expect(provider.restaurantListState, isA<ApiSuccess<List<Restaurant>>>());
      final state =
          provider.restaurantListState as ApiSuccess<List<Restaurant>>;
      expect(state.data, tRestaurantList);
    });

    test('should return error when call to usecase is unsuccessful', () async {
      // arrange
      when(
        mockGetRestaurants(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));

      // act
      await provider.fetchRestaurants();

      // assert
      expect(provider.restaurantListState, isA<ApiError<List<Restaurant>>>());
      final state = provider.restaurantListState as ApiError<List<Restaurant>>;
      expect(state.failure, isA<ServerFailure>());
    });
  });
}
