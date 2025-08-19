import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/utils/api_state.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../providers/restaurant_list_provider.dart';
import '../widgets/restaurant_list_view.dart';
import '../widgets/search_bar.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantListProvider>().fetchRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Restoverse', centerTitle: true),
      body: Column(
        children: [
          Consumer<RestaurantListProvider>(
            builder: (context, provider, child) {
              return RestaurantSearchBar(
                initialValue: provider.searchQuery,
                onChanged: (query) {
                  provider.searchRestaurantsQuery(query);
                },
                onClear: () {
                  provider.clearSearch();
                },
              );
            },
          ),
          Expanded(
            child: Consumer<RestaurantListProvider>(
              builder: (context, provider, child) {
                final state = provider.restaurantListState;

                return switch (state) {
                  ApiInitial() => const Center(
                    child: Text('Welcome to Restoverse!'),
                  ),
                  ApiLoading() => RestaurantListView(
                    restaurants: provider.displayedRestaurants,
                    isLoading: true,
                    onRefresh: provider.refreshRestaurants,
                  ),
                  ApiSuccess(data: final restaurants) => RestaurantListView(
                    restaurants: restaurants,
                    onRestaurantTap: (restaurant) {
                      _navigateToRestaurantDetail(restaurant.id);
                    },
                    onRefresh: provider.refreshRestaurants,
                    onLoadMore: provider.loadMoreData,
                    hasMoreData: provider.hasMoreData,
                    isLoadingMore: provider.isLoadingMore,
                  ),
                  ApiError(failure: final failure) => RestaurantListView(
                    restaurants: const [],
                    errorMessage: failure.message,
                    onRetry: () {
                      if (provider.isSearching) {
                        provider.searchRestaurantsQuery(provider.searchQuery);
                      } else {
                        provider.fetchRestaurants();
                      }
                    },
                    onRefresh: provider.refreshRestaurants,
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToRestaurantDetail(String restaurantId) {
    NavigationService.pushNamed(
      AppRouter.restaurantDetail,
      arguments: restaurantId,
    );
  }
}
