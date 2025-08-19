import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFFFF9800);
  static const Color tertiaryColor = Color(0xFF9C27B0);
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color successColor = Color(0xFF38A169);
  static const Color warningColor = Color(0xFFFFC107);

  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF8F9FA);
  static const Color lightOnBackground = Color(0xFF1A1A1A);
  static const Color lightOnSurface = Color(0xFF2D2D2D);
  static const Color lightOutline = Color(0xFF6B7280);

  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnBackground = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkOutline = Color(0xFF8A8A8A);

  static TextTheme get textTheme => GoogleFonts.poppinsTextTheme(
    ThemeData.light().textTheme,
  );

  static TextTheme get darkTextTheme => GoogleFonts.poppinsTextTheme(
    ThemeData.dark().textTheme,
  );

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      error: errorColor,
      surface: lightSurface,
      onSurface: lightOnSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      outline: lightOutline,
      background: lightBackground,
      onBackground: lightOnBackground,
    ),
    textTheme: textTheme.apply(
      bodyColor: lightOnBackground,
      displayColor: lightOnBackground,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightBackground,
      foregroundColor: lightOnBackground,
      elevation: 0,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: lightOnBackground,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: const CardThemeData(elevation: 4, margin: EdgeInsets.all(8)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      error: errorColor,
      surface: darkSurface,
      onSurface: darkOnSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      outline: darkOutline,
      background: darkBackground,
      onBackground: darkOnBackground,
    ),
    textTheme: darkTextTheme.apply(
      bodyColor: darkOnBackground,
      displayColor: darkOnBackground,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: darkOnBackground,
      elevation: 0,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: darkOnBackground,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: const CardThemeData(elevation: 4, margin: EdgeInsets.all(8)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
