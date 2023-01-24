import 'package:flutter/material.dart';

class CustomColors {
  static const primaryPink = Color(0xFFc468ee);
  static const primaryBlue = Color(0xFF5bd8ec);
  static const backgroundDeepDark = Color(0xFF141417);
  static const backgroundDark = Color(0xFF2c2c30);

  static const black = Color(0xFF000000);
  static const extremeDarkGrey = Color.fromARGB(255, 20, 20, 20);
  static const darkGrey = Color(0xFF454545);
  static const grey = Color(0xFF858585);
  static const lightGrey = Color(0xFFDEDEE0);
  static const extremeLightGrey = Color(0xFFF8F8F8);
  static const white = Color(0xFFffffff);

  static const gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [CustomColors.primaryPink, CustomColors.primaryBlue],
  );

  static final darkTheme = ThemeData(
    backgroundColor: CustomColors.backgroundDeepDark,
    brightness: Brightness.dark,
    primaryColor: CustomColors.primaryBlue,
    appBarTheme:
        const AppBarTheme(backgroundColor: CustomColors.backgroundDeepDark),
    iconTheme: const IconThemeData(color: CustomColors.lightGrey),
    cardTheme: const CardTheme(color: CustomColors.extremeDarkGrey),
    textTheme: const TextTheme(
        bodyText1: TextStyle(color: CustomColors.extremeLightGrey),
        labelMedium: TextStyle(color: CustomColors.grey)),
    buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
  );

  static final lightTheme = ThemeData(
    backgroundColor: CustomColors.white,
    brightness: Brightness.light,
    primaryColor: CustomColors.primaryBlue,
    iconTheme: const IconThemeData(color: CustomColors.black),
    cardTheme: const CardTheme(color: CustomColors.extremeLightGrey),
    textTheme: const TextTheme(
      bodyText1: TextStyle(color: CustomColors.darkGrey),
    ),
    buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
  );
}
