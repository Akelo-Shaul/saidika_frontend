import 'package:flutter/material.dart';

extension AppColors on ColorScheme {
  static MaterialColor primaryApp = MaterialColor(
    0xFFF88020,  // Updated base color to F88020
    <int, Color>{
      50: primaryColor,
      100: primaryColor,
      200: primaryColor,
      300: primaryColor,
      400: primaryColor,
      500: primaryColor,
      600: primaryColor,
      700: primaryColor,
      800: primaryColor,
      900: primaryColor,
    },
  );

  static Color primaryColor = Color(0xFFF88020);
  static Color primaryLightColor = Color(0xFFFFB366);
  static Color white = Color(0xffffffff);
  static Color scafoldColor = Color(0xfff6f6f6);
  static Color textColor = Color(0xff171717);
  static Color textColorLight = Color(0xff8c8c8c);
  static Color grey = Color(0xffefeeee);
  static Color orange = Color(0xFFFF9800);
  static Color orangeLight = Color(0xFFFFE0B2);
  static Color red = Color(0xff750000);
  static Color redLight = Color(0xffFF8A8A);
  static Color green = Color(0xff007500);
  static Color greenLight = Color(0xffe0ffe0);
  static Color googleBgColor = Color(0xffe01e3c);
  static Color fbBgColor = Color(0xff39569c);
  static Color appleBgColor = Color(0xff000000);
}
