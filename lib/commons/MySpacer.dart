import 'package:flutter/material.dart';
import 'package:Aiode/helpers/size.dart';
class MySpacer extends StatelessWidget {
  final double height;
  MySpacer({this.height});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: displayHeight(context) * height
    );
  }
}
