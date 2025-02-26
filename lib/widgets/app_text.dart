import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text appText({
  required final String textName,
  final double? fontSize,
  final FontWeight? fontWeight,
  final double? letterSpacing,
  lineHeight,
  final int? maxLines,
  final bool? softWrap,
  final TextOverflow? textOverflow,
  final TextAlign? textAlign,
  final TextStyle? textStyle,
}) {
  return Text(textName,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      softWrap: softWrap,
      overflow: textOverflow,
      style: textStyle);
}
