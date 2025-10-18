import 'package:flutter/material.dart';

import '../widgets/glassmorphism_container.dart';

class AppTheme {
  AppTheme._();

  static const Color royalBlue = Color(0xFF0F4C81);
  static const Color lightBlue = Color(0xFF72B5E7);

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: royalBlue,
        primary: royalBlue,
        secondary: lightBlue,
        background: const Color(0xFFF4F7FA),
      ),
      scaffoldBackgroundColor: const Color(0xFFF4F7FA),
      textTheme: base.textTheme.apply(
        displayColor: royalBlue,
        bodyColor: royalBlue.withOpacity(0.9),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: royalBlue,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: GlassmorphismContainer.defaultBorder,
        enabledBorder: GlassmorphismContainer.defaultBorder,
        focusedBorder: GlassmorphismContainer.defaultBorder.copyWith(
          borderSide: const BorderSide(color: lightBlue, width: 1.5),
        ),
        labelStyle: TextStyle(color: royalBlue.withOpacity(0.8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          backgroundColor: royalBlue,
        ).merge(
          ButtonStyle(
            overlayColor: WidgetStateProperty.all(lightBlue.withOpacity(0.3)),
          ),
        ),
      ),
    );
  }
}
