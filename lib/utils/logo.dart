import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, this.width, this.height});
  final double? width, height;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 140,
      height: height ?? 140,
      child: Image.asset(
        'assets/images/logo2.jpg',
      ),
    );
  }
}
