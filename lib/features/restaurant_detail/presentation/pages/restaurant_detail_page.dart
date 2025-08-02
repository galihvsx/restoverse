import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/api_state.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/restaurant_detail_provider.dart';
import '../widgets/menu_section.dart';
import '../widgets/restaurant_header.dart';
import '../widgets/restaurant_info.dart';
import '../widgets/reviews_section.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
        widget.restaurantId,
      );
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, child) {
          final state = provider.restaurantDetailState;

          return switch (state) {
            ApiInitial() => const Center(
              child: Text('Loading restaurant details...'),
            ),
            ApiLoading() => Center(child: LoadingWidget(size: 200)),
            ApiSuccess(data: final restaurant) => _buildSuccessContent(
              context,
              restaurant,
              theme,
            ),
            ApiError(failure: final failure) => Scaffold(
              appBar: CustomAppBar(
                title: 'Restaurant Detail',
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: Center(
                child: CustomErrorWidget(
                  message: failure.message,
                  onRetry: () =>
                      provider.fetchRestaurantDetail(widget.restaurantId),
                ),
              ),
            ),
          };
        },
      ),
    );
  }

  Widget _buildSuccessContent(
    BuildContext context,
    dynamic restaurant,
    ThemeData theme,
  ) {
    _animationController.forward();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.onSurface,
          flexibleSpace: FlexibleSpaceBar(
            background: FadeTransition(
              opacity: _fadeAnimation,
              child: RestaurantHeader(restaurant: restaurant),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RestaurantInfo(restaurant: restaurant),
                  const SizedBox(height: 16),
                  MenuSection(menu: restaurant.menus),
                  const SizedBox(height: 16),
                  ReviewsSection(reviews: restaurant.customerReviews),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
