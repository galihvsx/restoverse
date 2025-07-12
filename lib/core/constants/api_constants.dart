class ApiConstants {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';
  
  static const String restaurantList = '/list';
  static const String restaurantDetail = '/detail';
  static const String searchRestaurant = '/search';
  static const String addReview = '/review';
  
  static const String smallImageUrl = '$baseUrl/images/small';
  static const String mediumImageUrl = '$baseUrl/images/medium';
  static const String largeImageUrl = '$baseUrl/images/large';
  
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
}