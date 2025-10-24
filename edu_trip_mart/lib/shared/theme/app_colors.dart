import 'package:flutter/material.dart';

/// 앱 전체에서 사용하는 색상 정의
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1976D2);
  
  // Primary Blue Shades
  static const Color primaryBlue50 = Color(0xFFE3F2FD);
  static const Color primaryBlue100 = Color(0xFFBBDEFB);
  static const Color primaryBlue300 = Color(0xFF64B5F6);
  static const Color primaryBlue400 = Color(0xFF42A5F5);
  static const Color primaryBlue500 = Color(0xFF2196F3);
  static const Color primaryBlue600 = Color(0xFF1E88E5);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF4CAF50);
  static const Color secondaryLight = Color(0xFF81C784);
  static const Color secondaryDark = Color(0xFF388E3C);
  
  // Secondary Coral Shades
  static const Color secondaryCoral400 = Color(0xFFFF7043);
  static const Color secondaryCoral500 = Color(0xFFFF5722);
  static const Color secondaryCoral600 = Color(0xFFF4511E);
  
  // Accent Colors
  static const Color accent = Color(0xFFFF9800);
  static const Color accentLight = Color(0xFFFFB74D);
  static const Color accentDark = Color(0xFFF57C00);
  
  // Neutral Colors
  static const Color neutralGray50 = Color(0xFFFAFAFA);
  static const Color neutralGray100 = Color(0xFFF5F5F5);
  static const Color neutralGray200 = Color(0xFFEEEEEE);
  static const Color neutralGray300 = Color(0xFFE0E0E0);
  static const Color neutralGray400 = Color(0xFFBDBDBD);
  static const Color neutralGray500 = Color(0xFF9E9E9E);
  static const Color neutralGray600 = Color(0xFF757575);
  static const Color neutralGray700 = Color(0xFF616161);
  static const Color neutralGray800 = Color(0xFF424242);
  static const Color neutralGray900 = Color(0xFF212121);
  
  // Text Colors (Light Theme)
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textDisabledLight = Color(0xFFBDBDBD);
  
  // Text Colors (Dark Theme)
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);
  
  // Common Text Colors (for backward compatibility)
  static const Color textDark = textPrimaryLight;
  static const Color textSecondary = textSecondaryLight;
  static const Color textLight = textPrimaryDark;
  static const Color textDisabledDark = Color(0xFF757575);
  
  // Surface Colors (Light Theme)
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF5F5F5);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);
  
  // Surface Colors (Dark Theme)
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceVariantDark = Color(0xFF1E1E1E);
  
  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF000000);
  
  // Error Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color errorDark = Color(0xFFC62828);
  static const Color errorRed400 = Color(0xFFEF5350);
  static const Color errorRed500 = Color(0xFFD32F2F);
  
  // Success Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);
  static const Color successGreen = Color(0xFF4CAF50);
  
  // Warning Colors
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);
  static const Color warningYellow = Color(0xFFFFD700);
  
  // Info Colors
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);
  
  // Shimmer Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  
  // Additional Colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color shadow = Color(0xFF000000);
  static const Color placeholder = Color(0xFFE0E0E0);
  static const Color iconDisabled = Color(0xFFBDBDBD);
  
  // Rating Colors
  static const Color ratingFilled = Color(0xFFFFD700);
  static const Color ratingEmpty = Color(0xFFE0E0E0);
  
  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF2196F3),
    Color(0xFF21CBF3),
  ];
  
  static const List<Color> secondaryGradient = [
    Color(0xFF4CAF50),
    Color(0xFF8BC34A),
  ];
  
  static const List<Color> accentGradient = [
    Color(0xFFFF9800),
    Color(0xFFFFC107),
  ];
  
  // Color Schemes for Theme
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: primary,
    secondary: secondary,
    surface: surfaceLight,
    error: error,
  );
  
  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: primary,
    secondary: secondary,
    surface: surfaceDark,
    error: error,
  );
}