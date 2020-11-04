import 'package:flutter/material.dart';

class CustomTextFieldObscured extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool isHidden;
  final Function onPressed;
  final Color iconColor;
  CustomTextFieldObscured(
      {this.controller,
      this.placeholder,
      this.isHidden,
      this.onPressed,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: TextStyle(
            fontFamily: 'Open-Sans-Regular', fontSize: 12, color: Colors.black),
        controller: controller,
        obscureText: isHidden,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(5.0, 10.0, 0, 0),
            hintText: placeholder,
            hintStyle: TextStyle(fontFamily: 'Open-Sans-Regular', fontSize: 12),
            suffixIcon: IconButton(
              onPressed: onPressed,
              icon: Icon(Icons.visibility, size: 25, color: iconColor),
            )));
  }
}

// bool _obscureTextPassword = true;
// bool _obscureTextConfirmPassword = true;
// var togglePasswordColor = Colors.grey;
// var toggleConfirmPasswordColor = Colors.grey;
// // Toggles the password show status
// void _togglePassword() {
//   setState(() {
//     _obscureTextPassword = !_obscureTextPassword;
//     if (togglePasswordColor == Colors.grey) {
//       togglePasswordColor = Colors.blue;
//     } else {
//       togglePasswordColor = Colors.grey;
//     }
//   });
// }

// void _toggleConfirmPassword() {
//   setState(() {
//     _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
//     if (toggleConfirmPasswordColor == Colors.grey) {
//       toggleConfirmPasswordColor = Colors.blue;
//     } else {
//       toggleConfirmPasswordColor = Colors.grey;
//     }
//   });
// }
