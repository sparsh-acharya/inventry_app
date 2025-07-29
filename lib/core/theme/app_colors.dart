import 'package:flutter/material.dart';

/// Custom color utilities and extensions for the InventryApp
/// This provides additional semantic colors beyond the standard theme
class AppColors {
  // Functional Colors
  static const Color success = Color(0xFF388E3C); // Rich Green
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF2E7D32);

  static const Color warning = Color(0xFFF57C00); // Vibrant Orange
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFE65100);

  static const Color info = Color(0xFF1976D2); // Professional Blue
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1565C0);

  static const Color danger = Color(0xFFD32F2F); // Alert Red
  static const Color dangerLight = Color(0xFFEF5350);
  static const Color dangerDark = Color(0xFFC62828);

  // Premium Accent Colors
  static const Color gold = Color(0xFFFFB300);
  static const Color goldLight = Color(0xFFFFCA28);
  static const Color goldDark = Color(0xFFF57F17);

  static const Color platinum = Color(0xFFE5E5E5);
  static const Color silver = Color(0xFFC0C0C0);

  // Business Category Colors
  static const Color inventory = Color(0xFF6A1B9A); // Deep Purple
  static const Color sales = Color(0xFF388E3C); // Green
  static const Color analytics = Color(0xFF1976D2); // Blue
  static const Color team = Color(0xFFF57C00); // Orange

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF0F4C75),
    Color(0xFF3282B8),
  ];

  static const List<Color> accentGradient = [
    Color(0xFFFFB300),
    Color(0xFFFF8F00),
  ];

  static const List<Color> successGradient = [
    Color(0xFF388E3C),
    Color(0xFF66BB6A),
  ];
}

/// Extension to add custom color methods to ThemeData
extension AppThemeExtension on ThemeData {
  /// Get success color based on current brightness
  Color get successColor => brightness == Brightness.light
    ? AppColors.success
    : AppColors.successLight;

  /// Get warning color based on current brightness
  Color get warningColor => brightness == Brightness.light
    ? AppColors.warning
    : AppColors.warningLight;

  /// Get info color based on current brightness
  Color get infoColor => brightness == Brightness.light
    ? AppColors.info
    : AppColors.infoLight;

  /// Get danger color based on current brightness
  Color get dangerColor => brightness == Brightness.light
    ? AppColors.danger
    : AppColors.dangerLight;

  /// Get gold accent color
  Color get goldColor => AppColors.gold;
}

/// Extension to add semantic color methods to ColorScheme
extension ColorSchemeExtension on ColorScheme {
  /// Success color for positive actions and states
  Color get success => brightness == Brightness.light
    ? AppColors.success
    : AppColors.successLight;

  /// Warning color for cautionary actions and states
  Color get warning => brightness == Brightness.light
    ? AppColors.warning
    : AppColors.warningLight;

  /// Info color for informational content
  Color get info => brightness == Brightness.light
    ? AppColors.info
    : AppColors.infoLight;

  /// Danger color for destructive actions and error states
  Color get danger => brightness == Brightness.light
    ? AppColors.danger
    : AppColors.dangerLight;

  /// Premium gold color for special elements
  Color get gold => AppColors.gold;

  /// Inventory-specific color
  Color get inventory => AppColors.inventory;

  /// Sales-specific color
  Color get sales => AppColors.sales;

  /// Analytics-specific color
  Color get analytics => AppColors.analytics;

  /// Team-specific color
  Color get team => AppColors.team;
}

/// Utility class for creating themed gradients
class AppGradients {
  static LinearGradient primary({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) => LinearGradient(
    begin: begin,
    end: end,
    colors: AppColors.primaryGradient,
  );

  static LinearGradient accent({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) => LinearGradient(
    begin: begin,
    end: end,
    colors: AppColors.accentGradient,
  );

  static LinearGradient success({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) => LinearGradient(
    begin: begin,
    end: end,
    colors: AppColors.successGradient,
  );

  /// Shimmer gradient for loading states
  static LinearGradient shimmer() => LinearGradient(
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    stops: const [0.0, 0.5, 1.0],
    colors: [
      const Color(0xFFEBEBF4).withOpacity(0.6),
      const Color(0xFFF4F4F4).withOpacity(0.9),
      const Color(0xFFEBEBF4).withOpacity(0.6),
    ],
  );
}
