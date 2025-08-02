class ApiConstants {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';

  static const String restaurantList = '/list';
  static const String restaurantDetail = '/detail';
  static const String searchRestaurant = '/search';
  static const String addReview = '/review';

  static const String smallImageUrl = '$baseUrl/images/small';
  static const String mediumImageUrl = '$baseUrl/images/medium';
  static const String largeImageUrl = '$baseUrl/images/large';

  static const String searchRestaurantEndpoint = '/search';
  static const String addReviewEndpoint = '/review';

  static const String imageBaseUrl =
      'https://restaurant-api.dicoding.dev/images/';
  static const String smallImagePath = 'small/';
  static const String mediumImagePath = 'medium/';
  static const String largeImagePath = 'large/';

  static const String restaurantListEndpoint = '/list';
  static const String restaurantDetailEndpoint = '/detail';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
}
