import 'package:bookapp/app/utils/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

class TAppTheme {
  TAppTheme._(); // Private constructor to avoid creating instances

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme:
        TTextTheme.lightTextTheme, // Corrected to match the naming convention
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme:
        TTextTheme.darkTextTheme, // Corrected to match the naming convention
  );
}
