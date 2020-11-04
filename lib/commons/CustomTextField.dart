import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final int maxLength;

  CustomTextField(
      {this.controller, this.placeholder, @required this.maxLength});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
          fontFamily: 'Open-Sans-Regular', fontSize: 12, color: Colors.black),
      controller: controller,
      maxLength: maxLength,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(5.0),
          hintText: placeholder,
          hintStyle: TextStyle(fontFamily: 'Open-Sans-Regular', fontSize: 12),
          counterText: ""),
    );
  }
}
