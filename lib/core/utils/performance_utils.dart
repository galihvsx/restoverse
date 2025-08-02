import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PerformanceUtils {
  static void enablePerformanceOverlay(bool enable) {
    if (enable) {
      debugPaintSizeEnabled = false;
      debugRepaintRainbowEnabled = false;
    }
  }

  static Widget buildLazyWidget({
    required Widget child,
    required bool isVisible,
    Widget? placeholder,
  }) {
    if (!isVisible) {
      return placeholder ?? const SizedBox.shrink();
    }
    return child;
  }

  static Widget buildOptimizedListItem({
    required Widget child,
    required int index,
    required int itemCount,
    int visibilityThreshold = 5,
  }) {
    return RepaintBoundary(child: child);
  }

  static void preloadImages(List<String> imageUrls, BuildContext context) {
    for (final url in imageUrls) {
      precacheImage(NetworkImage(url), context);
    }
  }

  static Widget buildMemoryEfficientImage({
    required String imageUrl,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: width.toInt(),
      cacheHeight: height.toInt(),
      filterQuality: FilterQuality.medium,
    );
  }

  static void optimizeScrollPerformance(ScrollController controller) {
    controller.addListener(() {
      if (controller.position.userScrollDirection == ScrollDirection.idle) {
        return;
      }
    });
  }

  static Widget buildOptimizedCard({
    required Widget child,
    bool addRepaintBoundary = true,
  }) {
    if (addRepaintBoundary) {
      return RepaintBoundary(child: child);
    }
    return child;
  }

  static void scheduleFrameCallback(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  static void deferredExecution(
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 16),
  }) {
    Future.delayed(delay, callback);
  }

  static Widget buildConditionalBuilder({
    required bool condition,
    required Widget Function() builder,
    Widget? fallback,
  }) {
    if (condition) {
      return builder();
    }
    return fallback ?? const SizedBox.shrink();
  }

  static void disposeResources(List<dynamic> resources) {
    for (final resource in resources) {
      if (resource is ChangeNotifier) {
        resource.dispose();
      } else if (resource is AnimationController) {
        resource.dispose();
      } else if (resource is ScrollController) {
        resource.dispose();
      }
    }
  }

  static Widget buildCachedBuilder({
    required String cacheKey,
    required Widget Function() builder,
    Duration cacheDuration = const Duration(minutes: 5),
  }) {
    return Builder(
      builder: (context) {
        return builder();
      },
    );
  }
}

class LazyLoadingListView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final int preloadThreshold;

  const LazyLoadingListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.preloadThreshold = 3,
  });

  @override
  State<LazyLoadingListView> createState() => _LazyLoadingListViewState();
}

class _LazyLoadingListViewState extends State<LazyLoadingListView> {
  late ScrollController _controller;
  final Set<int> _loadedItems = {};

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
    _controller.addListener(_onScroll);
    _preloadInitialItems();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    final position = _controller.position;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = position.pixels;

    if (currentScroll >= maxScroll * 0.8) {
      _preloadMoreItems();
    }
  }

  void _preloadInitialItems() {
    for (int i = 0; i < widget.preloadThreshold && i < widget.itemCount; i++) {
      _loadedItems.add(i);
    }
  }

  void _preloadMoreItems() {
    final currentMax = _loadedItems.isEmpty
        ? 0
        : _loadedItems.reduce((a, b) => a > b ? a : b);
    for (
      int i = currentMax + 1;
      i < currentMax + 1 + widget.preloadThreshold && i < widget.itemCount;
      i++
    ) {
      _loadedItems.add(i);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        if (_loadedItems.contains(index)) {
          return RepaintBoundary(child: widget.itemBuilder(context, index));
        }
        return const SizedBox(
          height: 240,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class MemoryEfficientImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const MemoryEfficientImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
      filterQuality: FilterQuality.medium,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? const Center(child: Icon(Icons.error));
      },
    );
  }
}
