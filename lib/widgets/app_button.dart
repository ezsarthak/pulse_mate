import 'package:flutter/material.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/core/utils/dimensions.dart';
import 'package:pulse_mate/widgets/app_text.dart';

ElevatedButton appButton(
    {required double height,
    required double fontSize,
    required String text,
    required VoidCallback onTap}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: Size(double.maxFinite, height),
          backgroundColor: AppColors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      onPressed: onTap,
      child: appText(
          textName: text,
          textStyle: TextStyle(
              fontFamily: AppConstants.appFont,
              fontWeight: Dimensions.fontBold,
              color: AppColors.white,
              fontSize: fontSize)));
}
