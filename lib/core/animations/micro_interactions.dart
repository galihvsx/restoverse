import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MicroInteractions {
  static Widget animatedButton({
    required Widget child,
    required VoidCallback? onPressed,
    Duration duration = const Duration(milliseconds: 150),
    double scaleValue = 0.95,
    Color? splashColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
  }) {
    return AnimatedButton(
      onPressed: onPressed,
      duration: duration,
      scaleValue: scaleValue,
      splashColor: splashColor,
      highlightColor: highlightColor,
      borderRadius: borderRadius,
      child: child,
    );
  }

  static Widget pulseAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1000),
    double minScale = 0.95,
    double maxScale = 1.05,
    bool repeat = true,
  }) {
    return PulseAnimation(
      duration: duration,
      minScale: minScale,
      maxScale: maxScale,
      repeat: repeat,
      child: child,
    );
  }

  static Widget shakeAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    double offset = 5.0,
    int shakeCount = 3,
  }) {
    return ShakeAnimation(
      duration: duration,
      offset: offset,
      shakeCount: shakeCount,
      child: child,
    );
  }

  static Widget bounceAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 600),
    double bounceHeight = 10.0,
  }) {
    return BounceAnimation(
      duration: duration,
      bounceHeight: bounceHeight,
      child: child,
    );
  }

  static Widget rippleEffect({
    required Widget child,
    required VoidCallback? onTap,
    Color? rippleColor,
    BorderRadius? borderRadius,
    Duration duration = const Duration(milliseconds: 200),
  }) {
    return RippleEffect(
      onTap: onTap,
      rippleColor: rippleColor,
      borderRadius: borderRadius,
      duration: duration,
      child: child,
    );
  }

  static Widget loadingDots({
    Color? color,
    double size = 8.0,
    Duration duration = const Duration(milliseconds: 1200),
  }) {
    return LoadingDots(color: color, size: size, duration: duration);
  }

  static Widget morphingContainer({
    required Widget child,
    required bool isExpanded,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    double? height,
    double? width,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      height: isExpanded ? height : 0,
      width: isExpanded ? width : 0,
      padding: isExpanded ? padding : EdgeInsets.zero,
      margin: isExpanded ? margin : EdgeInsets.zero,
      decoration: decoration,
      child: isExpanded ? child : const SizedBox.shrink(),
    );
  }

  static Widget slideReveal({
    required Widget child,
    required bool isVisible,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    SlideDirection direction = SlideDirection.fromBottom,
  }) {
    return SlideReveal(
      isVisible: isVisible,
      duration: duration,
      curve: curve,
      direction: direction,
      child: child,
    );
  }

  static void hapticFeedback(HapticFeedbackType type) {
    switch (type) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }
}

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration duration;
  final double scaleValue;
  final Color? splashColor;
  final Color? highlightColor;
  final BorderRadius? borderRadius;

  const AnimatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.duration = const Duration(milliseconds: 150),
    this.scaleValue = 0.95,
    this.splashColor,
    this.highlightColor,
    this.borderRadius,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleValue,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    MicroInteractions.hapticFeedback(HapticFeedbackType.light);
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool repeat;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.repeat = true,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.repeat) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(scale: _animation.value, child: widget.child);
      },
    );
  }
}

class ShakeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final int shakeCount;

  const ShakeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.offset = 5.0,
    this.shakeCount = 3,
  });

  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void shake() {
    _controller.forward().then((_) => _controller.reset());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value * widget.offset, 0),
          child: widget.child,
        );
      },
    );
  }
}

class BounceAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double bounceHeight;

  const BounceAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.bounceHeight = 10.0,
  });

  @override
  State<BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void bounce() {
    _controller.forward().then((_) => _controller.reset());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_animation.value * widget.bounceHeight),
          child: widget.child,
        );
      },
    );
  }
}

class RippleEffect extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? rippleColor;
  final BorderRadius? borderRadius;
  final Duration duration;

  const RippleEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.rippleColor,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            MicroInteractions.hapticFeedback(HapticFeedbackType.selection);
            onTap!();
          }
        },
        splashColor:
            rippleColor ??
            Theme.of(context).primaryColor.withValues(alpha: 0.3),
        highlightColor:
            rippleColor?.withValues(alpha: 0.1) ??
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}

class LoadingDots extends StatefulWidget {
  final Color? color;
  final double size;
  final Duration duration;

  const LoadingDots({
    super.key,
    this.color,
    this.size = 8.0,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (index) => AnimationController(duration: widget.duration, vsync: this),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    _startAnimations();
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).primaryColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.2),
              child: Opacity(
                opacity: 0.3 + (_animations[index].value * 0.7),
                child: Transform.scale(
                  scale: 0.7 + (_animations[index].value * 0.3),
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class SlideReveal extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;
  final Curve curve;
  final SlideDirection direction;

  const SlideReveal({
    super.key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.direction = SlideDirection.fromBottom,
  });

  @override
  State<SlideReveal> createState() => _SlideRevealState();
}

class _SlideRevealState extends State<SlideReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    Offset begin;
    switch (widget.direction) {
      case SlideDirection.fromTop:
        begin = const Offset(0, -1);
        break;
      case SlideDirection.fromBottom:
        begin = const Offset(0, 1);
        break;
      case SlideDirection.fromLeft:
        begin = const Offset(-1, 0);
        break;
      case SlideDirection.fromRight:
        begin = const Offset(1, 0);
        break;
    }

    _slideAnimation = Tween<Offset>(
      begin: begin,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(SlideReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
    );
  }
}

enum HapticFeedbackType { light, medium, heavy, selection }

enum SlideDirection { fromTop, fromBottom, fromLeft, fromRight }
