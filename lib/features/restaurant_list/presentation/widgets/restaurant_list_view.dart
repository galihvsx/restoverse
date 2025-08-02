import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/widgets/error_widget.dart';
import '../../domain/entities/restaurant.dart';
import 'restaurant_card.dart';

class RestaurantListView extends StatefulWidget {
  final List<Restaurant> restaurants;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final Function(Restaurant)? onRestaurantTap;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoadMore;
  final bool hasMoreData;
  final bool isLoadingMore;

  const RestaurantListView({
    super.key,
    required this.restaurants,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.onRestaurantTap,
    this.onRefresh,
    this.onLoadMore,
    this.hasMoreData = true,
    this.isLoadingMore = false,
  });

  @override
  State<RestaurantListView> createState() => _RestaurantListViewState();
}

class _RestaurantListViewState extends State<RestaurantListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.hasMoreData &&
          !widget.isLoadingMore &&
          !widget.isLoading &&
          widget.onLoadMore != null) {
        widget.onLoadMore!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.errorMessage != null) {
      return CustomErrorWidget(
        message: widget.errorMessage!,
        onRetry: widget.onRetry,
      );
    }

    if (widget.isLoading && widget.restaurants.isEmpty) {
      return _buildSkeletonList();
    }

    if (widget.restaurants.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh?.call();
      },
      child: Skeletonizer(
        enabled: widget.isLoading && widget.restaurants.isEmpty,
        child: ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: widget.restaurants.length + (widget.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == widget.restaurants.length) {
              return _buildLoadMoreIndicator();
            }

            final restaurant = widget.restaurants[index];
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 100)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: RestaurantCard(
                      restaurant: restaurant,
                      onTap: () => widget.onRestaurantTap?.call(restaurant),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildSkeletonList() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 6,
        itemBuilder: (context, index) {
          return RestaurantCard(
            restaurant: Restaurant(
              id: 'skeleton-$index',
              name: 'Restaurant Name Placeholder',
              description:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              pictureId: '14',
              city: 'City Name',
              rating: 4.5,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 80,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No restaurants found',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or check back later',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: widget.onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
