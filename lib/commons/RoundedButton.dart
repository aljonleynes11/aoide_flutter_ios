import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget{
  final Function onPressed;
  final String buttonTitle;
  final Color bgColor;
  final Color color;


  RoundedButton({this.onPressed, this.buttonTitle, this.bgColor, this.color});
  @override
  Widget build(BuildContext context) {
   return MaterialButton(
     shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(18.0),
       ),
     color: bgColor,
     textColor: color,
     padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
     onPressed: onPressed,
     child: Text(
       buttonTitle,
       style: TextStyle(
         fontSize: 14.0,
         fontFamily: 'Open-Sans-Regular',
       ),
     ),
   );
  }
}
