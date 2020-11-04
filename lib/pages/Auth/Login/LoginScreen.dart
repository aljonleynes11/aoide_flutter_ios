import 'package:Aiode/commons/CustomTextFieldObscured.dart';
import 'package:flutter/material.dart';
import 'package:Aiode/helpers/size.dart';
import 'package:Aiode/commons/RoundedButton.dart';
import 'package:Aiode/commons/MySpacer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:Aiode/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

var usernameController = new TextEditingController();
var passwordController = new TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordHidden = true;
  var togglePasswordColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottom),
              child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MySpacer(
                          height: 0.2,
                        ),
                        Image.asset(
                          'assets/images/misc/logo.png',
                          height: displayHeight(context) * 0.1,
                        ),
                        MySpacer(
                          height: 0.02,
                        ),
                        Container(
                            child: Text(
                          "Sign in",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Open-Sans-Regular',
                            color: Colors.grey[700],
                          ),
                        )),
                        MySpacer(
                          height: 0.02,
                        ),
                        Container(
                            width: displayWidth(context) * 0.6,
                            child: Text(
                              "Enter your username and password to access your account.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 12,
                              ),
                            )),
                        MySpacer(
                          height: 0.05,
                        ),
                        Container(
                            width: displayWidth(context) * 0.76,
                            child: TextFormField(
                              maxLength: 20,
                              controller: usernameController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(5.0),
                                hintText: 'Username',
                                hintStyle: TextStyle(
                                    fontFamily: 'Open-Sans-Regular',
                                    fontSize: 12),
                              ),
                            )),
                        MySpacer(
                          height: 0.005,
                        ),
                        Container(
                            width: displayWidth(context) * 0.76,
                            child: CustomTextFieldObscured(
                              controller: passwordController,
                              placeholder: 'Password',
                              isHidden: _passwordHidden,
                              iconColor: togglePasswordColor,
                              onPressed: () {
                                _togglePassword();
                              },
                            )),
                        MySpacer(
                          height: 0.02,
                        ),
                        Container(
                            width: displayWidth(context) * 0.8,
                            child: RoundedButton(
                              onPressed: () {
                                login();
                              },
                              bgColor: Colors.blue,
                              color: Colors.white,
                              buttonTitle: 'Sign in',
                            )),
                      ],
                    ),
                  )),
            )));
  }

  void _togglePassword() {
    setState(() {
      _passwordHidden = !_passwordHidden;
      if (togglePasswordColor == Colors.grey) {
        togglePasswordColor = Colors.blue;
      } else {
        togglePasswordColor = Colors.grey;
      }
    });
  }

  User user = User();
  Future<User> login() async {
    final response = await post(
      'https://aoide.tk/api/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );
    final res = json.decode(response.body);
    print(res);
    if (response.statusCode == 200) {
      print('success');

      print(res['data']['id'].toString());
      var heightUnit = res['data']['general_infos']['height_unit'];
      var height = res['data']['general_infos']['height'];
      if (heightUnit == 'cm') {
        // convert to inches
        height = double.parse(height);
        height = height / 2.54;
        heightUnit = 'in';
        // now in inches
        height = height.toStringAsFixed(2);
      }
      setPreferences(res['data']['id'], height, res['data']['username'],
          res['data']['general_infos']['gender']);
      user = User.fromJson(res);
      setState(() {
        usernameController.clear();
        passwordController.clear();
      });

      Navigator.popAndPushNamed(context, '/home');
    } else if (response.body.contains('errors')) {
      Alert(
        context: context,
        style: alertStyle,
        title: "",
        desc: res['message'],
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open-Sans-Regular',
                  color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    } else if (res['status'] == false) {
      print("wrong creds");
      Alert(
        context: context,
        style: alertStyle,
        title: "",
        desc: res['message'],
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open-Sans-Regular',
                  color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
    return User.fromJson(json.decode(response.body));
  }

  setPreferences(
      int id, String heightInches, String username, String gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    {
      await prefs.setInt('id', id);
      await prefs.setString('heightInches', heightInches);
      await prefs.setString('username', username);
      await prefs.setString('gender', gender);
    }
  }

  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(
        fontSize: 16.0,
        fontFamily: 'Open-Sans-Regular',
        color: Colors.black,
      ),
      descTextAlign: TextAlign.start,
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ),
      alertAlignment: Alignment.center);
}
