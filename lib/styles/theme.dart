import 'package:flutter/material.dart';

final ThemeData mainTheme = ThemeData(
  fontFamily: 'MontserratAlternates',
  primaryColor: const Color.fromRGBO(255, 92, 77, 1),
  backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromRGBO(255, 92, 77, 1),
    onPrimary: Colors.white,
    primaryVariant: Color.fromRGBO(218, 216, 112, 1),
    secondary: Color.fromRGBO(255, 150, 54, 1),
    onSecondary: Colors.white70,
    secondaryVariant: Color.fromRGBO(255, 205, 88, 1),
    background: Color.fromRGBO(238, 238, 238, 1),
    onBackground: Colors.black45,
    surface: Colors.white,
    onSurface: Color.fromRGBO(44, 44, 44, 1),
    error: Colors.red,
    onError: Colors.white,
  ),
);

class GlobalColor {
  static const Color dim = Color.fromRGBO(200, 200, 200, 1);
}
