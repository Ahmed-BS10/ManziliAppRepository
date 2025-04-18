import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.amber;
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color lightTextColor = Colors.grey;
  static const Color successColor = Colors.green;

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: textColor,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: lightTextColor,
  );

  // Button Styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Cairo', // Arabic-friendly font
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: headingStyle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: primaryButtonStyle,
      ),
      textTheme: const TextTheme(
        titleLarge: headingStyle,
        titleMedium: subheadingStyle,
        bodyLarge: bodyStyle,
        bodySmall: captionStyle,
      ),
    );
  }
}

