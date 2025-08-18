import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/favorite_card.dart';
import '../../../../core/routes/app_router.dart';
import '../../domain/entities/favorite_restaurant.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    // Load favorites when page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Restaurants'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          return switch (favoriteProvider.state) {
            FavoriteInitial() => const Center(
                child: Text('Pull to refresh to load favorites'),
              ),
            FavoriteLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            FavoriteError(message: final message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: $message',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        favoriteProvider.clearError();
                        favoriteProvider.loadFavorites();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            FavoriteLoaded(favorites: final favorites) => favorites.isEmpty
                ? _buildEmptyState(context)
                : RefreshIndicator(
                    onRefresh: () => favoriteProvider.loadFavorites(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final restaurant = favorites[index];
                        return FavoriteCard(
                          restaurant: restaurant,
                          onTap: () => _navigateToDetail(context, restaurant.id),
                          onRemove: () => _showRemoveDialog(
                            context,
                            restaurant,
                            favoriteProvider,
                          ),
                        );
                      },
                    ),
                  ),
          };
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<FavoriteProvider>().loadFavorites(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 24),
                Text(
                  'No Favorite Restaurants',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Start adding restaurants to your favorites\nby tapping the heart icon',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  icon: const Icon(Icons.restaurant),
                  label: const Text('Browse Restaurants'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, String restaurantId) {
    Navigator.of(context).pushNamed(
      AppRouter.restaurantDetail,
      arguments: restaurantId,
    );
  }

  void _showRemoveDialog(
    BuildContext context,
    FavoriteRestaurant restaurant,
    FavoriteProvider favoriteProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove from Favorites'),
          content: Text(
            'Are you sure you want to remove "${restaurant.name}" from your favorites?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                favoriteProvider.removeFromFavorites(restaurant.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${restaurant.name} removed from favorites'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}