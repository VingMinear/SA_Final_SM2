import 'package:flutter/material.dart';

import '../constants/Color.dart';

class CustomCheckbox extends StatefulWidget {
  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isChecked ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(4.0),
          border:
              isChecked ? null : Border.all(color: Colors.black12, width: 1.5),
        ),
        width: 20,
        height: 20,
        child: isChecked
            ? Icon(
                Icons.check,
                size: 20,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
