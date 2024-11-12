import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

const mainColor = Color.fromARGB(255, 85, 181, 223);
Color primaryColor = const Color(0xFFF7F7F7);
Color deepGrey = HexColor('#4E4E4E');
Color scaffoldColor = const Color(0xFFF7F7F7);
Color redColor = HexColor('#D11A2A');
Color inProgressColor = HexColor('#BC0606');
Color grey = const Color(0xFFE8E8E8);
Color gray6 = HexColor('#FAFAFA');
Color textColor = HexColor('#444444');
Color warningColor = Colors.amber;
Color bgColor = HexColor('#F5F5F5');
Color whiteColor = Colors.white;
var gradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xffF6D5F7),
    Color(0xffFBE9D7),
  ],
);
var gradientBtn = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomCenter,
  colors: [
    Color.fromARGB(255, 170, 190, 123),
    Color(0xffF9AFBB),
  ],
);
var shadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.05),
    spreadRadius: -1,
    blurRadius: 4,
  ),
];
