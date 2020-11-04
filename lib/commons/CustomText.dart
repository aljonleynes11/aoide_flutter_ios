import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final fontSize;
  final Color textColor;

  CustomText({this.text, this.fontSize, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Open-Sans-Regular',
          color: textColor,
        ));
  }
}
