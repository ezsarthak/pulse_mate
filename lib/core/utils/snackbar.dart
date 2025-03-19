import 'package:flutter/material.dart';
import 'package:pulse_mate/core/utils/snackbar.dart';

void showSnackbar(BuildContext context, SnackBar snackbar) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackbar,
        snackBarAnimationStyle: AnimationStyle(
            curve: Curves.easeInOut, duration: Duration(milliseconds: 800)));
}
