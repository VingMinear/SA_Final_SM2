import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/Color.dart';

ThemeData theme() {
  return ThemeData(
    fontFamily: 'Urbanist',
    useMaterial3: true,
    scaffoldBackgroundColor: scaffoldColor,
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      surfaceTintColor: Colors.white,
      centerTitle: false,
      elevation: 0,
      backgroundColor: primaryColor,
      shadowColor: Colors.black38,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      modalBackgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    primaryColor: primaryColor,
    textTheme: TextTheme(
      displaySmall: TextStyle(
        color: textColor,
        fontSize: 8,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontSize: 15,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        color: textColor,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.white,
    ),
    colorScheme: ColorScheme.light(
      primary: mainColor,
    ).copyWith(secondary: mainColor),
  );
}
