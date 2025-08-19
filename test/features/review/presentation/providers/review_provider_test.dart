import 'package:dartz/dartz.dart';
import 'package:dcresto/core/errors/failures.dart';
import 'package:dcresto/core/utils/api_state.dart';
import 'package:dcresto/features/review/presentation/providers/review_provider.dart';
import 'package:dcresto/features/restaurant_detail/domain/entities/review.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late MockAddReview mockAddReview;
  late ReviewProvider provider;

  setUp(() {
    mockAddReview = MockAddReview();
    provider = ReviewProvider(addReview: mockAddReview);
  });

  group('Initial State', () {
    test('should have ApiInitial state on creation', () {
      expect(provider.reviewState, isA<ApiInitial<List<Review>>>());
      expect(provider.reviews, isEmpty);
    });
  });

  group('Set Initial Reviews', () {
    const tInitialReview = Review(
      name: 'John',
      review: 'Nice',
      date: 'Today',
    );
    final tInitialList = [tInitialReview];

    test('should set initial reviews and emit success state', () {
      provider.setInitialReviews(tInitialList);

      expect(provider.reviewState, isA<ApiSuccess<List<Review>>>());
      final state = provider.reviewState as ApiSuccess<List<Review>>;
      expect(state.data, tInitialList);
      expect(provider.reviews, tInitialList);
    });
  });

  group('Submit Review', () {
    const tRestaurantId = 'abc';
    const tName = 'Tester';
    const tReviewText = 'Great food!';

    const tNewReview = Review(
      name: tName,
      review: tReviewText,
      date: 'Now',
    );

    final tUpdatedList = [tNewReview];

    test('should emit loading then success when add review succeeds', () async {
      // arrange
      when(mockAddReview(
        id: anyNamed('id'),
        name: anyNamed('name'),
        review: anyNamed('review'),
      )).thenAnswer((_) async => Right(tUpdatedList));

      // act
      final future = provider.submitReview(
        restaurantId: tRestaurantId,
        name: tName,
        review: tReviewText,
      );

      // assert
      expect(provider.reviewState, isA<ApiLoading<List<Review>>>());
      await future;
      expect(provider.reviewState, isA<ApiSuccess<List<Review>>>());
      final state = provider.reviewState as ApiSuccess<List<Review>>;
      expect(state.data, tUpdatedList);
      expect(provider.reviews, tUpdatedList);
    });

    test('should emit loading then error when add review fails', () async {
      // arrange
      when(mockAddReview(
        id: anyNamed('id'),
        name: anyNamed('name'),
        review: anyNamed('review'),
      )).thenAnswer((_) async => const Left(ServerFailure('Server Error')));

      // act
      final future = provider.submitReview(
        restaurantId: tRestaurantId,
        name: tName,
        review: tReviewText,
      );

      // assert
      expect(provider.reviewState, isA<ApiLoading<List<Review>>>());
      await future;
      expect(provider.reviewState, isA<ApiError<List<Review>>>());
      final state = provider.reviewState as ApiError<List<Review>>;
      expect(state.failure, isA<ServerFailure>());
    });
  });
}