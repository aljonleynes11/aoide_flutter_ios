import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String placeholder;
  final String record;
  final Color bgColor;
  final Widget myIcon;
  final Function onPressed;
  CustomCard(
      {this.placeholder,
      this.bgColor,
      this.myIcon,
      this.record,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
          elevation: 5,
          color: bgColor,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  myIcon,
                  Text(
                    placeholder,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Open-Sans-Regular',
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    record,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Open-Sans-Regular',
                      fontSize: 12,
                    ),
                  ),
                ],
              ))),
    );
  }
}
