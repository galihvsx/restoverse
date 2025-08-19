import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_router.dart';
import 'core/preferences/preferences_helper.dart';
import 'core/services/navigation_service.dart';
import 'core/database/database_helper.dart';
import 'features/theme/presentation/providers/theme_provider.dart';
import 'core/notifications/notification_helper.dart';
import 'features/settings/presentation/providers/reminder_provider.dart';
import 'features/favorites/data/datasources/favorite_local_datasource.dart';
import 'features/favorites/data/repositories/favorite_repository_impl.dart';
import 'features/favorites/domain/usecases/add_favorite.dart';
import 'features/favorites/domain/usecases/get_favorites.dart';
import 'features/favorites/domain/usecases/is_favorite.dart';
import 'features/favorites/domain/usecases/remove_favorite.dart';
import 'features/favorites/presentation/providers/favorite_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesHelper.instance.init();
  // Initialize local notifications
  await NotificationHelper.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(preferencesHelper: PreferencesHelper.instance),
        ),
        ChangeNotifierProvider(
          create: (_) {
            final databaseHelper = DatabaseHelper.instance;
            final localDataSource = FavoriteLocalDataSourceImpl(
              databaseHelper: databaseHelper,
            );
            final repository = FavoriteRepositoryImpl(
              localDataSource: localDataSource,
            );
            final getFavorites = GetFavorites(repository);
            final addFavorite = AddFavorite(repository);
            final removeFavorite = RemoveFavorite(repository);
            final isFavorite = IsFavorite(repository);
            
            return FavoriteProvider(
              getFavorites: getFavorites,
              addFavorite: addFavorite,
              removeFavorite: removeFavorite,
              isFavorite: isFavorite,
            );
          },
        ),
        // Add ReminderProvider
        ChangeNotifierProvider(
          create: (_) => ReminderProvider(
            preferencesHelper: PreferencesHelper.instance,
            notificationHelper: NotificationHelper.instance,
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            navigatorKey: NavigationService.navigatorKey,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRouter.splash,
          );
        },
      ),
    );
  }
}
