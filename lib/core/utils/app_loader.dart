import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bg,
      child: Center(
        child: Lottie.asset('assets/loader.json',
            repeat: true, height: double.maxFinite, width: double.maxFinite),
      ),
    );
  }
}
