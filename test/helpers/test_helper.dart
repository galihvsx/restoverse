import 'package:mockito/annotations.dart';
import 'package:dcresto/features/restaurant_list/domain/usecases/get_restaurants.dart';
import 'package:dcresto/features/restaurant_list/domain/usecases/search_restaurants.dart';
import 'package:dcresto/features/review/domain/usecases/add_review.dart';
import 'package:dcresto/features/review/domain/repositories/review_repository.dart';

@GenerateMocks([
  GetRestaurants,
  SearchRestaurants,
  AddReview,
  ReviewRepository,
])
void main() {}