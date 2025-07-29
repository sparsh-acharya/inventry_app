import 'package:flutter/material.dart';

class AppTheme {
  // Rich Color Palette - Premium Deep Teal & Gold Theme
  static const Color _primaryColor = Color(0xFF0F4C75); // Deep Ocean Blue
  static const Color _primaryVariant = Color(0xFF1B2951); // Darker Navy
  static const Color _secondaryColor = Color(0xFFBB86FC); // Rich Purple
  static const Color _accentColor = Color(0xFFFFB300); // Premium Gold
  static const Color _accentSecondary = Color(0xFF00BCD4); // Vibrant Teal

  // Surface Colors
  static const Color _surfaceColor = Color(0xFFF8F9FA); // Clean White
  static const Color _surfaceVariant = Color(0xFFE8EAF6); // Light Purple Tint
  static const Color _backgroundLight = Color(0xFFFAFBFC); // Off White
  static const Color _backgroundDark = Color(0xFF121212); // True Dark

  // Text Colors
  static const Color _onPrimary = Color(0xFFFFFFFF);
  static const Color _onSecondary = Color(0xFF000000);
  static const Color _onSurface = Color(0xFF1C1B1F);
  static const Color _onBackground = Color(0xFF1C1B1F);

  // Error Colors
  static const Color _errorColor = Color(0xFFBA1A1A);
  static const Color _onError = Color(0xFFFFFFFF);

  // Success & Info Colors
  static const Color _successColor = Color(0xFF388E3C);
  static const Color _warningColor = Color(0xFFF57C00);
  static const Color _infoColor = Color(0xFF1976D2);

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _primaryColor,
        onPrimary: _onPrimary,
        primaryContainer: Color(0xFFD1E4FF),
        onPrimaryContainer: Color(0xFF001D36),
        secondary: _secondaryColor,
        onSecondary: _onSecondary,
        secondaryContainer: Color(0xFFE8DEF8),
        onSecondaryContainer: Color(0xFF1D192B),
        tertiary: _accentColor,
        onTertiary: Color(0xFF000000),
        tertiaryContainer: Color(0xFFFFE082),
        onTertiaryContainer: Color(0xFF261900),
        error: _errorColor,
        onError: _onError,
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF410002),
        surface: _surfaceColor,
        onSurface: _onSurface,
        onSurfaceVariant: Color(0xFF43474E),
        background: _backgroundLight,
        onBackground: _onBackground,
        outline: Color(0xFF74777F),
        outlineVariant: Color(0xFFC4C7C5),
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFF2F3033),
        onInverseSurface: Color(0xFFF0F0F3),
        inversePrimary: Color(0xFF9DCAFF),
        surfaceTint: _primaryColor,
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: _primaryColor,
        foregroundColor: _onPrimary,
        titleTextStyle: TextStyle(
          color: _onPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: _onPrimary),
      ),

      // Card Theme
      cardTheme: CardTheme(
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: _surfaceColor,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: _onPrimary,
          elevation: 3,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 16,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _accentColor,
        foregroundColor: Colors.black,
        elevation: 6,
        shape: CircleBorder(),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _surfaceColor,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: _surfaceVariant,
        labelStyle: const TextStyle(color: _onSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: _surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        titleTextStyle: const TextStyle(
          color: _onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _primaryVariant,
        contentTextStyle: const TextStyle(color: _onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // List Tile Theme
      listTileTheme: const ListTileThemeData(
        tileColor: _surfaceColor,
        selectedTileColor: Color(0xFFE3F2FD),
        iconColor: _primaryColor,
        textColor: _onSurface,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _onSurface,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: _onBackground,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: _onBackground,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: _onBackground,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: _onBackground,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: _onBackground,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: _onBackground,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: _onBackground,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _onBackground,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _onBackground,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _onBackground,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _onBackground,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _onBackground,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _onBackground,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _onBackground,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _onBackground,
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF9DCAFF),
        onPrimary: Color(0xFF003258),
        primaryContainer: Color(0xFF004881),
        onPrimaryContainer: Color(0xFFD1E4FF),
        secondary: Color(0xFFCCC2DC),
        onSecondary: Color(0xFF332D41),
        secondaryContainer: Color(0xFF4A4458),
        onSecondaryContainer: Color(0xFFE8DEF8),
        tertiary: Color(0xFFEFBD47),
        onTertiary: Color(0xFF3E2E00),
        tertiaryContainer: Color(0xFF5A4300),
        onTertiaryContainer: Color(0xFFFFE082),
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
        errorContainer: Color(0xFF93000A),
        onErrorContainer: Color(0xFFFFDAD6),
        surface: _backgroundDark,
        onSurface: Color(0xFFE6E1E5),
        onSurfaceVariant: Color(0xFFC4C7C5),
        background: _backgroundDark,
        onBackground: Color(0xFFE6E1E5),
        outline: Color(0xFF8E9199),
        outlineVariant: Color(0xFF43474E),
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFFE6E1E5),
        onInverseSurface: Color(0xFF313033),
        inversePrimary: _primaryColor,
        surfaceTint: Color(0xFF9DCAFF),
      ),

      // AppBar Theme (Dark)
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Color(0xFF1F1F1F),
        foregroundColor: Color(0xFFE6E1E5),
        titleTextStyle: TextStyle(
          color: Color(0xFFE6E1E5),
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Color(0xFFE6E1E5)),
      ),

      // Card Theme (Dark)
      cardTheme: CardTheme(
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFF1F1F1F),
      ),

      // Input Decoration Theme (Dark)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF9DCAFF), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(
          color: Color(0xFFB0B0B0),
          fontSize: 16,
        ),
      ),
    );
  }

  // Custom Colors for specific use cases
  static const Color successColor = _successColor;
  static const Color warningColor = _warningColor;
  static const Color infoColor = _infoColor;
  static const Color primaryColor = _primaryColor;
  static const Color accentColor = _accentColor;
  static const Color accentSecondary = _accentSecondary;
}
