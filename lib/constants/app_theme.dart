import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark, // Karanlık mod
      primaryColor: Colors.grey[900], // Ana renk
      scaffoldBackgroundColor: Colors.black, // Arka plan
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary, // Şeffaf AppBar
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Raleway',
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
          fontFamily: 'Raleway',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.grey[400],
          height: 1.5,
          fontFamily: 'Lato',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.grey[500],
          height: 1.4,
          fontFamily: 'Lato',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey[850], // Metin rengi
          shadowColor: Colors.grey[700],
          elevation: 6,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Yuvarlak kenarlar
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Raleway',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[600]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[700]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
            width: 1.5,
          ),
        ),
        labelStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
          fontFamily: 'Lato',
        ),
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 12,
          fontFamily: 'Lato',
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 28,
      ),
      dividerColor: Colors.grey[700],
      cardTheme: CardTheme(
        color: Colors.grey[850],
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
    );
  }
}
