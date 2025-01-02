import 'package:flutter/material.dart';

/// Typography class following standard design system guidelines
class AppTypography {
  // Display styles - for hero headers and major features
  static Text displayLarge({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) => Text(
    text,
    style: TextStyle(
      fontSize: 57,  // Display Large
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
      height: 1.12,
      color: color ?? Colors.black,
      fontFamily: 'Poppins',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );

  static Text displayMedium({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) => Text(
    text,
    style: TextStyle(
      fontSize: 45,  // Display Medium
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.15,
      color: color ?? Colors.black,
      fontFamily: 'Poppins',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );

  static Text displaySmall({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) => Text(
    text,
    style: TextStyle(
      fontSize: 36,  // Display Small
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.22,
      color: color ?? Colors.black,
      fontFamily: 'Poppins',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );

  // Headline styles
  static Text headlineLarge({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) => Text(
    text,
    style: TextStyle(
      fontSize: 32,  // Headline Large
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.25,
      color: color ?? Colors.black,
      fontFamily: 'Poppins',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );

  static Text headlineMedium({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) => Text(
    text,
    style: TextStyle(
      fontSize: 28,  // Headline Medium
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      height: 1.29,
      color: color ?? Colors.black,
      fontFamily: 'Poppins',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );

  static Text headlineSmall({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) => Text(
    text,
    style: TextStyle(
      fontSize: 24,  // Headline Small
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      height: 1.33,
      color: color ?? Colors.black,
      fontFamily: 'Poppins',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );

  // Title styles
  static Text titleLarge({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) => Text(
    text,
    style: TextStyle(
      fontSize: 22,  // Title Large
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      height: 1.27,
      color: color ?? Colors.black,
      fontFamily: 'Poppins',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );

  static Text titleMedium({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) => Text(
    text,
    style: TextStyle(
      fontSize: 16,  // Title Medium
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.5,
      color: color ?? Colors.black,
      fontFamily: 'Poppins',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );

  static Text titleSmall({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) => Text(
    text,
    style: TextStyle(
      fontSize: 14,  // Title Small
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      color: color ?? Colors.black,
      fontFamily: 'Poppins',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );

  // Body styles
  static Text bodyLarge({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    FontWeight? fontWeight,
  }) => Text(
    text,
    style: TextStyle(
      fontSize: 16,  // Body Large
      fontWeight: fontWeight ?? FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.5,
      color: color ?? Colors.black,
      fontFamily: 'Poppins',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );

  static Text bodyMedium({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    FontWeight? fontWeight,
  }) => Text(
    text,
    style: TextStyle(
      fontSize: 14,  // Body Medium
      fontWeight: fontWeight ?? FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
      color: color ?? Colors.black,
      fontFamily: 'Poppins',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );

  static Text bodySmall({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    FontWeight? fontWeight,
  }) => Text(
    text,
    style: TextStyle(
      fontSize: 12,  // Body Small
      fontWeight: fontWeight ?? FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
      color: color ?? Colors.black,
      fontFamily: 'Poppins',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );

  // Label styles
  static Text labelLarge({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) => Text(
    text,
    style: TextStyle(
      fontSize: 14,  // Label Large
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      color: color ?? Colors.black,
      fontFamily: 'Poppins',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );

  static Text labelMedium({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) => Text(
    text,
    style: TextStyle(
      fontSize: 12,  // Label Medium
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
      color: color ?? Colors.black,
      fontFamily: 'Poppins',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );

  static Text labelSmall({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) => Text(
    text,
    style: TextStyle(
      fontSize: 11,  // Label Small
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
      color: color ?? Colors.black,
      fontFamily: 'Poppins',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );
}