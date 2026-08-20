import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Classe que concentra as configurações de tema do App.
abstract class AppTheme {
  static ThemeData get dark => ThemeData(
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: AppColors.white,
          secondary: AppColors.secondary,
          onSecondary: AppColors.white,
        ).copyWith(
          tertiary: AppColors.accent,
          onTertiary: AppColors.primary,
        ),
        useMaterial3: true,
        primaryColor: AppColors.primary,
      );
}
