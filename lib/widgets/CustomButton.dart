import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';

class CustomButton extends StatelessWidget {
  final String? title;
  final void Function()? onPress;
  final double? height, width, elevation, highlightElevation, borderRadius;
  final TextStyle? textStyle;
  final Color? splashColor, backgroundColor;
  final BorderSide? borderSide;
  const CustomButton({
    super.key,
    this.title,
    required this.onPress,
    this.height,
    this.width,
    this.textStyle,
    this.elevation,
    this.highlightElevation,
    this.borderRadius,
    this.splashColor,
    this.backgroundColor,
    this.borderSide,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightColor: context.theme.primaryColor.withAlpha(10),
      elevation: elevation ?? 0,
      splashColor:
          splashColor ?? context.theme.colorScheme.onSurface.withAlpha(50),
      color: backgroundColor ?? mainColor,
      highlightElevation: highlightElevation ?? 0,
      onPressed: onPress,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
        borderSide: borderSide ??
            BorderSide(
              width: 0,
              color: whiteColor,
            ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title ?? "",
        style: textStyle ??
            const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
      ),
    );
  }
}
