import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: false);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.orange,
        secondary: AppColors.green,
      ),
      // ✅ Roboto applied globally — no need to set in every TextStyle
      textTheme: GoogleFonts.robotoTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.green,
      ),
    );
  }
}