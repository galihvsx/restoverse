import 'package:flutter/material.dart';

class PageTransitions {
  static const Duration defaultDuration = Duration(milliseconds: 300);
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration slowDuration = Duration(milliseconds: 500);

  static PageRouteBuilder fadeTransition({
    required Widget page,
    RouteSettings? settings,
    Duration duration = defaultDuration,
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: Duration(
        milliseconds: duration.inMilliseconds ~/ 2,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: curve),
          child: child,
        );
      },
    );
  }

  static PageRouteBuilder slideFromRight({
    required Widget page,
    RouteSettings? settings,
    Duration duration = defaultDuration,
    Curve curve = Curves.easeOutCubic,
  }) {
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
  }

  static PageRouteBuilder slideFromLeft({
    required Widget page,
    RouteSettings? settings,
    Duration duration = defaultDuration,
    Curve curve = Curves.easeOutCubic,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: Duration(
        milliseconds: duration.inMilliseconds ~/ 2,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  static PageRouteBuilder slideFromBottom({
    required Widget page,
    RouteSettings? settings,
    Duration duration = defaultDuration,
    Curve curve = Curves.easeOutCubic,
  }) {
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
  }

  static PageRouteBuilder slideFromTop({
    required Widget page,
    RouteSettings? settings,
    Duration duration = defaultDuration,
    Curve curve = Curves.easeOutCubic,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: Duration(
        milliseconds: duration.inMilliseconds ~/ 2,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, -1.0);
        const end = Offset.zero;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  static PageRouteBuilder scaleTransition({
    required Widget page,
    RouteSettings? settings,
    Duration duration = defaultDuration,
    Curve curve = Curves.easeOutBack,
    double beginScale = 0.8,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: Duration(
        milliseconds: duration.inMilliseconds ~/ 2,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: beginScale,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  static PageRouteBuilder rotationTransition({
    required Widget page,
    RouteSettings? settings,
    Duration duration = defaultDuration,
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: Duration(
        milliseconds: duration.inMilliseconds ~/ 2,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.8,
              end: 1.0,
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: child,
          ),
        );
      },
    );
  }

  static PageRouteBuilder customTransition({
    required Widget page,
    required Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    )
    transitionsBuilder,
    RouteSettings? settings,
    Duration duration = defaultDuration,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: Duration(
        milliseconds: duration.inMilliseconds ~/ 2,
      ),
      transitionsBuilder: transitionsBuilder,
    );
  }

  static PageRouteBuilder heroTransition({
    required Widget page,
    required String heroTag,
    RouteSettings? settings,
    Duration duration = defaultDuration,
  }) {
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
            curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
          ),
          child: child,
        );
      },
    );
  }
}
