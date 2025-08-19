import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/restaurant_detail/data/datasources/restaurant_detail_remote_datasource.dart';
import '../../features/restaurant_detail/data/repositories/restaurant_detail_repository_impl.dart';
import '../../features/restaurant_detail/domain/usecases/get_restaurant_detail.dart';
import '../../features/restaurant_detail/presentation/pages/restaurant_detail_page.dart';
import '../../features/restaurant_detail/presentation/providers/restaurant_detail_provider.dart';
import '../../features/review/data/datasources/review_remote_datasource.dart';
import '../../features/review/data/repositories/review_repository_impl.dart';
import '../../features/review/domain/usecases/add_review.dart';
import '../../features/review/presentation/providers/review_provider.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../navigation/main_navigation.dart';
import '../network/dio_client.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String restaurantDetail = '/restaurant-detail';
  static const String favorites = '/favorites';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _createRoute(
          const SplashPage(),
          settings,
          transitionType: RouteTransitionType.fade,
        );

      case home:
        return _createRoute(
          const MainNavigation(),
          settings,
          transitionType: RouteTransitionType.slideFromRight,
        );

      case restaurantDetail:
        final restaurantId = settings.arguments as String?;
        if (restaurantId == null) {
          return _createErrorRoute('Restaurant ID is required');
        }
        return _createRoute(
          _buildRestaurantDetailPage(restaurantId),
          settings,
          transitionType: RouteTransitionType.slideFromBottom,
        );

      case AppRouter.favorites:
        // Favorites is now handled by MainNavigation bottom tab
        return _createRoute(
          const MainNavigation(),
          settings,
          transitionType: RouteTransitionType.slideFromRight,
        );

      case AppRouter.settings:
        return _createRoute(
          _buildSettingsPage(),
          settings,
          transitionType: RouteTransitionType.slideFromRight,
        );

      default:
        return _createErrorRoute('Route not found: ${settings.name}');
    }
  }

  static PageRoute _createRoute(
    Widget page,
    RouteSettings settings, {
    RouteTransitionType transitionType = RouteTransitionType.fade,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    switch (transitionType) {
      case RouteTransitionType.fade:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: Duration(
            milliseconds: duration.inMilliseconds ~/ 2,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        );

      case RouteTransitionType.slideFromRight:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: Duration(
            milliseconds: duration.inMilliseconds ~/ 2,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
                ),
                child: child,
              ),
            );
          },
        );

      case RouteTransitionType.slideFromBottom:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: Duration(
            milliseconds: duration.inMilliseconds ~/ 2,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                  ),
                ),
                child: child,
              ),
            );
          },
        );

      case RouteTransitionType.scale:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: Duration(
            milliseconds: duration.inMilliseconds ~/ 2,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              ),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
        );
    }
  }

  static Route<dynamic> _createErrorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildRestaurantDetailPage(String restaurantId) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final dioClient = DioClient();
            final remoteDataSource = RestaurantDetailRemoteDataSourceImpl(
              dioClient: dioClient,
            );
            final repository = RestaurantDetailRepositoryImpl(
              remoteDataSource: remoteDataSource,
            );
            final getRestaurantDetail = GetRestaurantDetail(repository);

            return RestaurantDetailProvider(
              getRestaurantDetail: getRestaurantDetail,
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final dioClient = DioClient();
            final reviewRemote = ReviewRemoteDataSourceImpl(
              dioClient: dioClient,
            );
            final reviewRepo = ReviewRepositoryImpl(
              remoteDataSource: reviewRemote,
            );
            final addReview = AddReview(reviewRepo);
            return ReviewProvider(addReview: addReview);
          },
        ),
      ],
      child: RestaurantDetailPage(restaurantId: restaurantId),
    );
  }

  static Widget _buildSettingsPage() {
    return const SettingsPage();
  }
}

enum RouteTransitionType { fade, slideFromRight, slideFromBottom, scale }
