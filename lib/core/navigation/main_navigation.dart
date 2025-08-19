import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/favorites/data/datasources/favorite_local_datasource.dart';
import '../../features/favorites/data/repositories/favorite_repository_impl.dart';
import '../../features/favorites/domain/usecases/add_favorite.dart';
import '../../features/favorites/domain/usecases/get_favorites.dart';
import '../../features/favorites/domain/usecases/is_favorite.dart';
import '../../features/favorites/domain/usecases/remove_favorite.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/favorites/presentation/providers/favorite_provider.dart';
import '../../features/restaurant_list/presentation/pages/restaurant_home_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../database/database_helper.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late PageController _pageController;
  late FavoriteProvider _favoriteProvider;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeFavoriteProvider();
  }

  void _initializeFavoriteProvider() {
    // Create dependencies
    final databaseHelper = DatabaseHelper.instance;
    final localDataSource = FavoriteLocalDataSourceImpl(
      databaseHelper: databaseHelper,
    );
    final repository = FavoriteRepositoryImpl(localDataSource: localDataSource);

    // Create use cases
    final getFavorites = GetFavorites(repository);
    final addFavorite = AddFavorite(repository);
    final removeFavorite = RemoveFavorite(repository);
    final isFavorite = IsFavorite(repository);

    _favoriteProvider = FavoriteProvider(
      getFavorites: getFavorites,
      addFavorite: addFavorite,
      removeFavorite: removeFavorite,
      isFavorite: isFavorite,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _favoriteProvider.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildFavoritesPage() {
    return ChangeNotifierProvider.value(
      value: _favoriteProvider,
      child: const FavoritesPage(),
    );
  }

  Widget _buildSettingsPage() {
    return const SettingsPage();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider.value(
      value: _favoriteProvider,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            const RestaurantHomePage(),
            _buildFavoritesPage(),
            _buildSettingsPage(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withAlpha(25), // 0.1 * 255 ≈ 25
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: theme.colorScheme.surface,
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: theme.colorScheme.onSurfaceVariant,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline),
                activeIcon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
