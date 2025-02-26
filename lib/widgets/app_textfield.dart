import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/core/utils/dimensions.dart';

Widget appTextFormField({
  required String hint,
  required String label,
  required TextEditingController textEditingController,
  required String? Function(String?) validator,
  VoidCallback? onTap,
  ValueChanged<String>? onChanged,
  TextInputType? textInputType,
  int maxCharacters = 50,
  bool onlyNumbers = false,
  double? fontSize,
  Color? textColor,
  FontWeight? fontWeight,
  double? lineHeight,
  Widget? icon,
  Widget? suffixIcon,
  bool? isSearchBox = false,
  bool obscureText = false,
  required Dimensions appDimensions,
}) {
  return TextFormField(
    controller: textEditingController,
    validator: validator,
    onTap: onTap,
    obscureText: obscureText,
    onChanged: onChanged,
    keyboardType: textInputType ?? TextInputType.text,
    cursorColor: AppColors.red,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    inputFormatters: [
      LengthLimitingTextInputFormatter(
        maxCharacters,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
      ),
      if (onlyNumbers) FilteringTextInputFormatter.digitsOnly,
    ],
    decoration: InputDecoration(
      hintText: hint,
      label: Text(
        label,
        style: TextStyle(
          fontSize: appDimensions.h7,
          fontFamily: AppConstants.appFont,
          color: textColor ?? AppColors.black.withValues(alpha: 0.4),
          fontWeight: fontWeight ?? Dimensions.fontRegular,
          letterSpacing: 1,
          height: lineHeight ?? 1.0,
        ),
      ),
      hintStyle: TextStyle(
        fontSize: appDimensions.h6,
        fontFamily: AppConstants.appFont,
        color: textColor ?? AppColors.black.withValues(alpha: 0.7),
        fontWeight: fontWeight ?? Dimensions.fontRegular,
        letterSpacing: 1,
        height: lineHeight ?? 1.0,
      ),
      prefixIcon: icon,
      prefixIconConstraints: const BoxConstraints(minHeight: 25, minWidth: 25),
      suffixIcon: suffixIcon,
      suffixIconConstraints: const BoxConstraints(minHeight: 25, minWidth: 25),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.border,
        ),
      ),
      errorStyle: const TextStyle(height: 0),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isSearchBox! ? AppColors.red : AppColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
    ),
  );
}
