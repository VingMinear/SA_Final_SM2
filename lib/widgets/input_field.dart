import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/Color.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final bool obscureText, readOnly, animate, autofocus;
  final Widget? suffixIcon;
  final int? delay, maxLines;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  const InputField({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    required this.controller,
    this.onChanged,
    this.readOnly = false,
    this.delay,
    this.animate = true,
    this.autofocus = false,
    this.maxLines,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return animate
        ? FadeInDown(
            from: 20,
            delay: Duration(milliseconds: delay ?? 0),
            child: field(),
          )
        : field();
  }

  TextField field() {
    return TextField(
      readOnly: readOnly,
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.black,
      keyboardType: keyboardType,
      obscuringCharacter: '●',
      onChanged: onChanged,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: grey.withOpacity(0.4),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
