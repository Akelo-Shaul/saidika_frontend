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

  static Color primaryColor = const Color(0xFFF88020);
  static Color primaryLightColor = const Color(0xFFFFB366);
  static Color white = const Color(0xffffffff);
  static Color scafoldColor = const Color(0xfff6f6f6);
  static Color textColor = const Color(0xff171717);
  static Color textColorLight = const Color(0xff8c8c8c);
  static Color grey = const Color(0xffefeeee);
  static Color orange = const Color(0xFFFF9800);
  static Color orangeLight = const Color(0xFFFFE0B2);
  static Color red = const Color(0xff750000);
  static Color redLight = const Color(0xffFF8A8A);
  static Color green = const Color(0xff007500);
  static Color greenLight = const Color(0xffe0ffe0);
  static Color googleBgColor = const Color(0xffe01e3c);
  static Color fbBgColor = const Color(0xff39569c);
  static Color appleBgColor = const Color(0xff000000);
}
