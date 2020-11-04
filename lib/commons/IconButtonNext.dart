import 'package:flutter/material.dart';

class IconButtonNext extends StatelessWidget {
  final Function onPressed;
  final String buttonTitle;
  final Color bgColor;
  final Color color;

  IconButtonNext({this.onPressed, this.buttonTitle, this.bgColor, this.color});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: RaisedButton(
        onPressed: () {},
        child: const Text('Next', style: TextStyle(fontSize: 20)),
        color: bgColor,
        textColor: color,
        elevation: 3,
      ),
    );
  }
}
