import 'package:flutter/material.dart';

final ThemeData oceanTheme = ThemeData(
  fontFamily: 'MontserratAlternates',
  primaryColor: const Color.fromRGBO(55, 190, 176, 1),
  backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromRGBO(55, 190, 176, 1),
    onPrimary: Colors.white,
    primaryVariant: Color.fromRGBO(164, 229, 224, 1),
    secondary: Color.fromRGBO(12, 97, 112, 1),
    onSecondary: Colors.white70,
    secondaryVariant: Color.fromRGBO(219, 245, 240, 1),
    background: Color.fromRGBO(238, 238, 238, 1),
    onBackground: Colors.black45,
    surface: Colors.white,
    onSurface: Color.fromRGBO(44, 44, 44, 1),
    error: Colors.red,
    onError: Colors.white,
  ),
);
