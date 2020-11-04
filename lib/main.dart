import 'package:Aiode/pages/Auth/Register/RegisterScreen.dart';
import 'package:Aiode/pages/Auth/Register/RegisterScreen5th.dart';
import 'package:Aiode/pages/Auth/Register/AvatarScreen.dart';
import 'package:Aiode/pages/HomeScreen.dart';
import 'package:Aiode/pages/User/AppointmentScreen.dart';

import 'package:Aiode/pages/User/ChecklistScreen.dart';

import 'package:Aiode/pages/User/LogsScreen.dart';
import 'package:Aiode/pages/User/MedicationScreen.dart';

import 'package:flutter/material.dart';
import 'pages/LandingScreen.dart';
import 'pages/HomeScreen.dart';
import 'pages/Auth/Login/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = prefs.getInt('id');
  String landing;
  print(id);
  if (id != null) {
    landing = '/home';
  } else {
    landing = '/landingScreen';
  }
  runApp(MaterialApp(
    initialRoute: landing,

    //initialRoute: '/register5th',
    routes: {
      //static screens
      '/landingScreen': (context) => LandingScreen(),
      '/login': (context) => LoginScreen(),
      //registerScreen file =>
      '/register': (context) => RegisterScreen(),
      '/register2nd': (context) => RegisterScreen2nd(),
      '/register3rd': (context) => RegisterScreen3rd(),
      '/register4th': (context) => RegisterScreen4th(),
      '/register5th': (context) => RegisterScreen5th(),
      '/checklist': (context) => ChecklistScreen(),
      '/medication': (context) => MedicationScreen(),
      '/appointment': (context) => AppointmentScreen(),
      '/logs': (context) => LogsScreen(),
      '/home': (context) => HomeScreen(),
      '/chooseImage': (context) => AvatarScreen(),
    },
  ));
}

//
