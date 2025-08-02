import 'package:flutter/material.dart';

class StaggeredAnimations {
  static const Duration defaultItemDelay = Duration(milliseconds: 100);
  static const Duration defaultAnimationDuration = Duration(milliseconds: 600);

  static Widget staggeredListItem({
    required Widget child,
    required int index,
    required AnimationController controller,
    Duration delay = defaultItemDelay,
    Duration duration = defaultAnimationDuration,
    Curve curve = Curves.easeOutCubic,
    StaggeredAnimationType type = StaggeredAnimationType.slideFromBottom,
  }) {
    final itemDelay = delay.inMilliseconds * index;
    final totalDuration = duration.inMilliseconds;
    final startTime = itemDelay / (totalDuration + itemDelay);
    final endTime = (totalDuration + itemDelay) / (totalDuration + itemDelay);

    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        startTime.clamp(0.0, 1.0),
        endTime.clamp(0.0, 1.0),
        curve: curve,
      ),
    );

    switch (type) {
      case StaggeredAnimationType.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );

      case StaggeredAnimationType.slideFromRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.5, 0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );

      case StaggeredAnimationType.slideFromLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-0.5, 0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );

      case StaggeredAnimationType.scale:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );

      case StaggeredAnimationType.fade:
        return FadeTransition(opacity: animation, child: child);

      case StaggeredAnimationType.rotation:
        return RotationTransition(
          turns: Tween<double>(begin: 0.1, end: 0.0).animate(animation),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          ),
        );
    }
  }

  static Widget staggeredGrid({
    required List<Widget> children,
    required AnimationController controller,
    int crossAxisCount = 2,
    Duration delay = defaultItemDelay,
    Duration duration = defaultAnimationDuration,
    Curve curve = Curves.easeOutCubic,
    StaggeredAnimationType type = StaggeredAnimationType.slideFromBottom,
  }) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.0,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return staggeredListItem(
          child: children[index],
          index: index,
          controller: controller,
          delay: delay,
          duration: duration,
          curve: curve,
          type: type,
        );
      },
    );
  }

  static Widget staggeredColumn({
    required List<Widget> children,
    required AnimationController controller,
    Duration delay = defaultItemDelay,
    Duration duration = defaultAnimationDuration,
    Curve curve = Curves.easeOutCubic,
    StaggeredAnimationType type = StaggeredAnimationType.slideFromBottom,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        return staggeredListItem(
          child: child,
          index: index,
          controller: controller,
          delay: delay,
          duration: duration,
          curve: curve,
          type: type,
        );
      }).toList(),
    );
  }

  static Widget staggeredRow({
    required List<Widget> children,
    required AnimationController controller,
    Duration delay = defaultItemDelay,
    Duration duration = defaultAnimationDuration,
    Curve curve = Curves.easeOutCubic,
    StaggeredAnimationType type = StaggeredAnimationType.slideFromRight,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        return staggeredListItem(
          child: child,
          index: index,
          controller: controller,
          delay: delay,
          duration: duration,
          curve: curve,
          type: type,
        );
      }).toList(),
    );
  }

  static Widget staggeredWrap({
    required List<Widget> children,
    required AnimationController controller,
    Duration delay = defaultItemDelay,
    Duration duration = defaultAnimationDuration,
    Curve curve = Curves.easeOutCubic,
    StaggeredAnimationType type = StaggeredAnimationType.scale,
    Axis direction = Axis.horizontal,
    WrapAlignment alignment = WrapAlignment.start,
    double spacing = 0.0,
    double runSpacing = 0.0,
  }) {
    return Wrap(
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runSpacing: runSpacing,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        return staggeredListItem(
          child: child,
          index: index,
          controller: controller,
          delay: delay,
          duration: duration,
          curve: curve,
          type: type,
        );
      }).toList(),
    );
  }

  static AnimationController createController({
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 1200),
  }) {
    return AnimationController(duration: duration, vsync: vsync);
  }

  static void startStaggeredAnimation(
    AnimationController controller, {
    Duration delay = Duration.zero,
  }) {
    Future.delayed(delay, () {
      if (controller.isCompleted) {
        controller.reset();
      }
      controller.forward();
    });
  }

  static void resetStaggeredAnimation(AnimationController controller) {
    controller.reset();
  }
}

enum StaggeredAnimationType {
  slideFromBottom,
  slideFromRight,
  slideFromLeft,
  scale,
  fade,
  rotation,
}

class StaggeredListView extends StatefulWidget {
  final List<Widget> children;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final StaggeredAnimationType type;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;

  const StaggeredListView({
    super.key,
    required this.children,
    this.delay = StaggeredAnimations.defaultItemDelay,
    this.duration = StaggeredAnimations.defaultAnimationDuration,
    this.curve = Curves.easeOutCubic,
    this.type = StaggeredAnimationType.slideFromBottom,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
  });

  @override
  State<StaggeredListView> createState() => _StaggeredListViewState();
}

class _StaggeredListViewState extends State<StaggeredListView>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StaggeredAnimations.createController(vsync: this);
    StaggeredAnimations.startStaggeredAnimation(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: widget.physics,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return StaggeredAnimations.staggeredListItem(
          child: widget.children[index],
          index: index,
          controller: _controller,
          delay: widget.delay,
          duration: widget.duration,
          curve: widget.curve,
          type: widget.type,
        );
      },
    );
  }
}
