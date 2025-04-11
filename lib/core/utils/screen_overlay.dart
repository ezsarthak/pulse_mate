import 'package:flutter/material.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';

void showOverlay({
  required BuildContext context,
  required Widget content,
  Duration animationDuration = const Duration(milliseconds: 500),
  Curve animationCurve = Curves.easeOutBack,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Dismiss",
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: animationDuration,
    pageBuilder: (_, __, ___) => const SizedBox(), // Not used but required
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      // Create curved animations
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: animationCurve,
      );

      return ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
          child: AlertDialog(
            backgroundColor: AppColors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            content: content,
          ),
        ),
      );
    },
  );
}

// For a more advanced animation with content reveal
void showAnimatedOverlay({
  required BuildContext context,
  required Widget content,
  Duration animationDuration = const Duration(milliseconds: 400),
  Curve animationCurve = const Cubic(0.17, 0.89, 0.32, 1.0),
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Dismiss",
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: animationDuration,
    pageBuilder: (_, __, ___) => const SizedBox(), // Not used but required
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      // Create curved animations
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: animationCurve,
      );

      return AnimatedBuilder(
        animation: curvedAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: Tween<double>(begin: 0.8, end: 1.0)
                .animate(curvedAnimation)
                .value,
            child: Opacity(
              opacity: Tween<double>(begin: 0.0, end: 1.0)
                  .animate(curvedAnimation)
                  .value
                  .clamp(0.0, 1.0),
              child: AlertDialog(
                backgroundColor: AppColors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                content: AnimatedContentWrapper(
                  animation: curvedAnimation,
                  child: content,
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

// A wrapper that animates the content inside the dialog
class AnimatedContentWrapper extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const AnimatedContentWrapper({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Staggered animation for content
    final contentAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(0.3, 1.0, curve: Curves.easeOutQuad),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      child: AnimatedBuilder(
        animation: contentAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: contentAnimation.value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - contentAnimation.value)),
              child: child,
            ),
          );
        },
        child: child,
      ),
    );
  }
}
