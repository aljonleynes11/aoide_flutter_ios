import 'package:Aiode/commons/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:Aiode/helpers/size.dart';
import 'package:Aiode/commons/MySpacer.dart';
import 'package:Aiode/commons/CustomTextFieldObscured.dart';
import 'package:intl/intl.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:flutter/services.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:Aiode/services/ChecklistServices.dart';
import 'package:Aiode/services/LogServices.dart';

import 'AvatarScreen.dart';

var finalEmail;
var finalUsername;
var finalPassword;
var finalConfirmPassword;
var finalBirthday;
var finalAge;
var finalGender;
var finalRace;
var finalHeight;
var finalWeight;
var finalHeightUnit;
var finalWeightUnit;
var finalHeartAttack;
var finalStroke;
var finalDiabetes;
var finalHighBlood;
var finalKidney;
var finalFamily;
var finalSmoke;
var finalAlcohol;
var finalDrugs;
var finalSexualPartner;
var bmiCategoryFinal;
var bmiFinal;
bool hadError = false;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

final TextEditingController emailController = new TextEditingController();
final TextEditingController usernameController = new TextEditingController();
final TextEditingController passwordController = new TextEditingController();
final TextEditingController confirmPasswordController =
    new TextEditingController();

class _RegisterScreenState extends State<RegisterScreen> {
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
                    height: 0.12,
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
                    "Getting to Know You",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Open-Sans-Regular',
                      color: Colors.black,
                    ),
                  )),
                  Container(
                      child: Text(
                    "Step 1",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Open-Sans-Regular',
                      color: Colors.grey[400],
                    ),
                  )),
                  MySpacer(
                    height: 0.02,
                  ),
                  Container(
                      width: displayWidth(context) * 0.6,
                      child: Text(
                        "Personal Information",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Open-Sans-Regular',
                          fontSize: 15,
                        ),
                      )),
                  MySpacer(
                    height: 0.01,
                  ),
                  Image.asset(
                    'assets/images/misc/step1.png',
                    height: displayHeight(context) * 0.07,
                  ),
                  MySpacer(
                    height: 0.01,
                  ),
                  Container(
                      width: displayWidth(context) * 0.7,
                      child: CustomTextField(
                        placeholder: 'Email',
                        controller: emailController,
                        maxLength: 30,
                      )),
                  MySpacer(
                    height: 0.004,
                  ),
                  Container(
                      width: displayWidth(context) * 0.7,
                      child: CustomTextField(
                        placeholder: 'Username',
                        controller: usernameController,
                        maxLength: 15,
                      )),
                  MySpacer(
                    height: 0.005,
                  ),
                  Container(
                      width: displayWidth(context) * 0.7,
                      child: CustomTextFieldObscured(
                        placeholder: 'Password',
                        controller: passwordController,
                        isHidden: _obscureTextPassword,
                        iconColor: togglePasswordColor,
                        onPressed: () {
                          _togglePassword();
                        },
                      )),
                  MySpacer(
                    height: 0.005,
                  ),
                  Container(
                      width: displayWidth(context) * 0.7,
                      child: CustomTextFieldObscured(
                        placeholder: 'Confirm Password',
                        controller: confirmPasswordController,
                        isHidden: _obscureTextConfirmPassword,
                        iconColor: toggleConfirmPasswordColor,
                        onPressed: () {
                          _toggleConfirmPassword();
                        },
                      )),
                  MySpacer(
                    height: 0.259,
                    //  height: 0.1,
                  ),
                  Container(
                      height: displayHeight(context) * 0.075,
                      width: displayWidth(context) * 1,
                      child: MaterialButton(
                          onPressed: () {
                            //api request here
                            print(emailController.text);
                            print(usernameController.text);
                            print(passwordController.text);
                            print(confirmPasswordController.text);
                            finalUsername = usernameController.text;
                            finalEmail = emailController.text;
                            finalPassword = passwordController.text;
                            finalConfirmPassword =
                                confirmPasswordController.text;
                            //hadError
                            Navigator.pushNamed(context, '/register2nd');
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Next Step',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Open-Sans-Regular',
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ],
                          ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  var togglePasswordColor = Colors.grey;
  var toggleConfirmPasswordColor = Colors.grey;
  // Toggles the password show status
  void _togglePassword() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
      if (togglePasswordColor == Colors.grey) {
        togglePasswordColor = Colors.blue;
      } else {
        togglePasswordColor = Colors.grey;
      }
    });
  }

  void _toggleConfirmPassword() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
      if (toggleConfirmPasswordColor == Colors.grey) {
        toggleConfirmPasswordColor = Colors.blue;
      } else {
        toggleConfirmPasswordColor = Colors.grey;
      }
    });
  }
}

class RegisterScreen2nd extends StatefulWidget {
  @override
  _RegisterScreen2ndState createState() => _RegisterScreen2ndState();
}

var dobController = TextEditingController();
String gender;
String race;
var heightController = TextEditingController();
var weightController = TextEditingController();

var tempWeight;
var heightUnit = 'cm';
var weightUnit = 'lb';
void getUnit(unit, String bm) {
  if (bm == "weight") {
    if (unit == 0) {
      weightUnit = 'lb';
    } else {
      weightUnit = 'kg';
    }
  } else if (bm == 'height') {
    if (unit == 0) {
      heightUnit = 'cm';
    } else {
      heightUnit = 'in';
    }
  }
}

List<String> _status = ["Male", "Female"];
DateTime now = new DateTime.now();
getBMI() {
  if (finalWeightUnit == 'kg') {
    //convert to kg
    finalWeight = finalWeight * 2.2046;
    finalWeightUnit = 'lb';
    // now in kg
    print('$finalWeight $finalWeightUnit');
  }

  if (finalHeightUnit == 'cm') {
    // convert to inches
    finalHeight = finalHeight / 2.54;
    finalHeightUnit = 'in';
    // now in inches
    print('$finalHeight $finalHeightUnit');
  }
  bmiFinal = finalWeight / finalHeight / finalHeight * 703;

  if (bmiFinal < 15) {
    bmiCategoryFinal = "Very severely underweight";
  } else if (bmiFinal == 15) {
    bmiCategoryFinal = "Severely underweight";
  } else if (bmiFinal >= 16 && bmiFinal <= 18.4) {
    bmiCategoryFinal = "Underweight";
  } else if (bmiFinal >= 18.5 && bmiFinal <= 24) {
    bmiCategoryFinal = "Normal (healthy weight)";
  } else if (bmiFinal >= 25 && bmiFinal <= 29) {
    bmiCategoryFinal = "Overweight";
  } else {
    bmiCategoryFinal = "Obese";
  }
  print(bmiFinal);
  print(bmiCategoryFinal);
}

class _RegisterScreen2ndState extends State<RegisterScreen2nd> {
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
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MySpacer(
                    height: 0.12,
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
                    "Getting to Know You",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Open-Sans-Regular',
                      color: Colors.black,
                    ),
                  )),
                  Container(
                      child: Text(
                    "Step 2",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Open-Sans-Regular',
                      color: Colors.grey[400],
                    ),
                  )),
                  MySpacer(
                    height: 0.02,
                  ),
                  Container(
                      width: displayWidth(context) * 0.6,
                      child: Text(
                        "Personal Information",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Open-Sans-Regular',
                          fontSize: 15,
                        ),
                      )),
                  MySpacer(
                    height: 0.01,
                  ),
                  Image.asset(
                    'assets/images/misc/step2.png',
                    height: displayHeight(context) * 0.076,
                  ),
                  MySpacer(
                    height: 0.001,
                  ),
                  Container(
                    width: displayWidth(context) * 0.76,
                    child: TextField(
                        style: TextStyle(
                            fontFamily: 'Open-Sans-Regular', fontSize: 12),
                        //showCursor: true,
                        readOnly: true,
                        controller: dobController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5.0),
                          hintText: "Birthday",
                          hintStyle: TextStyle(
                              fontFamily: 'Open-Sans-Regular', fontSize: 12),
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900, 1),
                              lastDate: DateTime.now(),
                              builder: (BuildContext context, Widget picker) {
                                return Theme(
                                  data: ThemeData(
                                    buttonTheme: ButtonThemeData(
                                        textTheme: ButtonTextTheme.primary),
                                    dialogBackgroundColor: Colors.white,
                                  ),
                                  child: picker,
                                );
                              }).then((selectedDate) {
                            if (selectedDate != null) {
                              dobController.text = DateFormat('MMMM dd, yyyy')
                                  .format(selectedDate);
                            }
                          });
                        }),
                  ),
                  MySpacer(
                    height: 0.02,
                  ),
                  Container(
                    width: displayWidth(context) * 0.76,
                    child: Row(
                      children: [
                        Text(
                          'Gender',
                          style: TextStyle(
                              fontSize: 12, fontFamily: 'Open-Sans-Regular'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: displayWidth(context) * 0.76,
                    child: Row(
                      children: [
                        RadioGroup<String>.builder(
                          direction: Axis.horizontal,
                          groupValue: gender,
                          onChanged: (value) => setState(() {
                            gender = value;
                          }),
                          items: _status,
                          itemBuilder: (item) => RadioButtonBuilder(
                            item,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      width: displayWidth(context) * 0.76,
                      child: DropdownButton(
                        hint: race == null
                            ? Text(
                                '  Race',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Open-Sans-Regular',
                                ),
                              )
                            : Text(
                                '  $race',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Open-Sans-Regular',
                                    color: Colors.black),
                              ),
                        isExpanded: true,
                        iconSize: 30.0,
                        items: [
                          'Asian',
                          'American Indian / Alaska Native',
                          'Native Hawaiian / Other Pacific Islander',
                          'Black',
                          'White',
                          'More than one race'
                        ].map(
                          (val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          },
                        ).toList(),
                        onChanged: (val) {
                          setState(
                            () {
                              race = val;
                              print(race);
                            },
                          );
                        },
                      )),
                  MySpacer(
                    height: 0.005,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                        width: displayWidth(context) * 0.555,
                        child: TextFormField(
                            style: TextStyle(
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 12,
                                color: Colors.black),
                            keyboardType: TextInputType.number,
                            controller: heightController,
                            maxLength: 5,
                            decoration: InputDecoration(
                              counterText: "",
                              contentPadding: const EdgeInsets.all(5.0),
                              hintText: 'Height',
                              hintStyle: TextStyle(
                                  fontFamily: 'Open-Sans-Regular',
                                  fontSize: 12),
                            ))),
                    ToggleSwitch(
                      minWidth: 50.0,
                      minHeight: 20.0,
                      cornerRadius: 0,
                      activeBgColor: Colors.blue,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.grey,
                      labels: ['cm', 'in'],
                      onToggle: (index) {
                        print('switched to: $index');
                        getUnit(index, "height");
                      },
                    ),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: displayWidth(context) * 0.555,
                          child: TextFormField(
                              style: TextStyle(
                                  fontFamily: 'Open-Sans-Regular',
                                  fontSize: 12),
                              keyboardType: TextInputType.number,
                              controller: weightController,
                              maxLength: 5,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(5.0),
                                hintText: 'Weight',
                                counterText: "",
                                hintStyle: TextStyle(
                                  fontFamily: 'Open-Sans-Regular',
                                  fontSize: 12,
                                ),
                              ))),
                      ToggleSwitch(
                        minWidth: 50.0,
                        minHeight: 20.0,
                        cornerRadius: 0,
                        activeBgColor: Colors.blue,
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.grey,
                        labels: ['lb', 'kg'],
                        onToggle: (index2) {
                          print('switched to: $index2');
                          getUnit(index2, "weight");
                        },
                      ),
                    ],
                  ),
                  MySpacer(
                    height: 0.18,
                  ),
                  Container(
                      width: displayWidth(context) * 1,
                      height: displayHeight(context) * 0.075,
                      child: MaterialButton(
                          onPressed: () {
                            //api request here

                            Navigator.pushNamed(context, '/register3rd');
                            var height = heightController.text;
                            var weight = weightController.text;

                            var birthday = new DateFormat("MMMM dd, yyyy")
                                .parse(dobController.text);

                            finalBirthday =
                                DateFormat('yyyy-MM-dd').format(birthday);
                            print(birthday);
                            double tempAge =
                                DateTime.now().difference(birthday).inDays /
                                    365;
                            int age = tempAge.toInt();
                            print(birthday);
                            print(age);
                            print(gender);
                            print(race);
                            print(weightUnit);
                            print('$height $heightUnit');
                            print('$weight $weightUnit');
                            // finalBirthday = birthday;
                            finalAge = age;
                            finalGender = gender;
                            finalRace = race;
                            finalHeight = double.parse(height);
                            finalWeight = double.parse(weight);
                            finalHeightUnit = heightUnit;
                            finalWeightUnit = weightUnit;
                            getBMI();
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Next Step',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Open-Sans-Regular',
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ],
                          ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen3rd extends StatefulWidget {
  @override
  _RegisterScreen3rdState createState() => _RegisterScreen3rdState();
}

bool heartAttack = false;
bool stroke = false;
bool diabetes = false;
bool highBlood = false;
bool kidney = false;
bool family = false;

class _RegisterScreen3rdState extends State<RegisterScreen3rd> {
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
                    height: 0.12,
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
                    "Getting to Know You",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Open-Sans-Regular',
                      color: Colors.black,
                    ),
                  )),
                  Container(
                      child: Text(
                    "Step 3",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Open-Sans-Regular',
                      color: Colors.grey[400],
                    ),
                  )),
                  MySpacer(
                    height: 0.02,
                  ),
                  Container(
                      width: displayWidth(context) * 0.6,
                      child: Text(
                        "Medical History",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Open-Sans-Regular',
                          fontSize: 14,
                        ),
                      )),
                  MySpacer(
                    height: 0.001,
                  ),
                  Image.asset(
                    'assets/images/misc/step3.png',
                    height: displayHeight(context) * 0.07,
                  ),
                  MySpacer(
                    height: 0.001,
                  ),
                  Container(
                      width: displayWidth(context) * 0.8,
                      child: Text(
                        "Do you have any of the following medical conditions? ( Select all that apply )",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open-Sans-Regular',
                          fontSize: 14,
                        ),
                      )),
                  MySpacer(
                    height: 0.03,
                  ),
                  Container(
                      width: displayWidth(context) * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: displayWidth(context) * 0.6,
                            child: AutoSizeText(
                              "Prior heartAttack attack/coronary artery disease",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                            value: heartAttack,
                            onChanged: (value) => setState(() {
                              heartAttack = value;
                              print(heartAttack);
                            }),
                            activeTrackColor: Colors.grey,
                            activeColor: Colors.blue,
                          ),
                        ],
                      )),
                  MySpacer(
                    height: 0.001,
                  ),
                  Container(
                      width: displayWidth(context) * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: displayWidth(context) * 0.6,
                            child: AutoSizeText(
                              "Stroke",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                            value: stroke,
                            onChanged: (value) => setState(() {
                              stroke = value;
                              print(stroke);
                            }),
                            activeTrackColor: Colors.grey,
                            activeColor: Colors.blue,
                          ),
                        ],
                      )),
                  MySpacer(
                    height: 0.001,
                  ),
                  Container(
                      width: displayWidth(context) * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: displayWidth(context) * 0.6,
                            child: AutoSizeText(
                              "Diabetes",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                            value: diabetes,
                            onChanged: (value) => setState(() {
                              diabetes = value;
                              print(diabetes);
                            }),
                            activeTrackColor: Colors.grey,
                            activeColor: Colors.blue,
                          ),
                        ],
                      )),
                  MySpacer(
                    height: 0.001,
                  ),
                  Container(
                      width: displayWidth(context) * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: displayWidth(context) * 0.6,
                            child: AutoSizeText(
                              "High blood pressure /  Hypertension",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                            value: highBlood,
                            onChanged: (value) => setState(() {
                              highBlood = value;
                              print(highBlood);
                            }),
                            activeTrackColor: Colors.grey,
                            activeColor: Colors.blue,
                          ),
                        ],
                      )),
                  MySpacer(
                    height: 0.001,
                  ),
                  Container(
                      width: displayWidth(context) * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: displayWidth(context) * 0.6,
                            child: AutoSizeText(
                              "Kidney disease",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                            value: kidney,
                            onChanged: (value) => setState(() {
                              kidney = value;
                              print(kidney);
                            }),
                            activeTrackColor: Colors.grey,
                            activeColor: Colors.blue,
                          ),
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                      child: Divider(
                        color: Colors.grey,
                        height: 5,
                      )),
                  MySpacer(
                    height: 0.001,
                  ),
                  Container(
                      width: displayWidth(context) * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: displayWidth(context) * 0.6,
                            child: AutoSizeText(
                              "Do you have any family history of a heart attack, stroke or diabetes?",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                            value: family,
                            onChanged: (value) => setState(() {
                              family = value;
                              print(family);
                            }),
                            activeTrackColor: Colors.grey,
                            activeColor: Colors.blue,
                          ),
                        ],
                      )),
                  MySpacer(
                    height: 0.1,
                  ),
                  Container(
                      height: displayHeight(context) * 0.075,
                      width: displayWidth(context) * 1,
                      child: MaterialButton(
                          onPressed: () {
                            //api request here
                            print('heart attack: $heartAttack');
                            print('stroke : $stroke');
                            print('diabetes : $diabetes');
                            print('highBlood : $highBlood');
                            print('kidney : $kidney');
                            print('family : $family');
                            finalHeartAttack = heartAttack;
                            finalStroke = stroke;
                            finalDiabetes = diabetes;
                            finalHighBlood = highBlood;
                            finalKidney = kidney;
                            finalFamily = family;

                            Navigator.pushNamed(context, '/register4th');
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Next Step',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Open-Sans-Regular',
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ],
                          ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen4th extends StatefulWidget {
  @override
  _RegisterScreen4thState createState() => _RegisterScreen4thState();
}

bool smoke = false;
bool alcohol = false;
bool drugs = false;
bool sexualPartner = false;

class _RegisterScreen4thState extends State<RegisterScreen4th> {
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
                    height: 0.12,
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
                    "Getting to Know You",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Open-Sans-Regular',
                      color: Colors.black,
                    ),
                  )),
                  Container(
                      child: Text(
                    "Step 4",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Open-Sans-Regular',
                      color: Colors.grey[400],
                    ),
                  )),
                  MySpacer(
                    height: 0.02,
                  ),
                  Container(
                      width: displayWidth(context) * 0.6,
                      child: Text(
                        "Medical History",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Open-Sans-Regular',
                          fontSize: 14,
                        ),
                      )),
                  MySpacer(
                    height: 0.001,
                  ),
                  Image.asset(
                    'assets/images/misc/step4.png',
                    height: displayHeight(context) * 0.07,
                  ),
                  MySpacer(
                    height: 0.001,
                  ),
                  // Container(
                  //     width: displayWidth(context) * 0.8,
                  //     child: Text(
                  //       "Do you have any of the following medical conditions? ( Select all that apply )",
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         color: Colors.black,
                  //         fontFamily: 'Open-Sans-Regular',
                  //         fontSize: 14,
                  //       ),
                  //     )),
                  MySpacer(
                    height: 0.03,
                  ),
                  Container(
                      width: displayWidth(context) * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: displayWidth(context) * 0.6,
                            child: AutoSizeText(
                              "Have you ever smoked?",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                            value: smoke,
                            onChanged: (value) => setState(() {
                              smoke = value;
                              print(smoke);
                            }),
                            activeTrackColor: Colors.grey,
                            activeColor: Colors.blue,
                          ),
                        ],
                      )),
                  MySpacer(
                    height: 0.001,
                  ),
                  Container(
                      width: displayWidth(context) * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: displayWidth(context) * 0.6,
                            child: AutoSizeText(
                              "Do you drink alcohol?",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                            value: alcohol,
                            onChanged: (value) => setState(() {
                              alcohol = value;
                              print(alcohol);
                            }),
                            activeTrackColor: Colors.grey,
                            activeColor: Colors.blue,
                          ),
                        ],
                      )),
                  MySpacer(
                    height: 0.001,
                  ),
                  Container(
                      width: displayWidth(context) * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: displayWidth(context) * 0.6,
                            child: AutoSizeText(
                              "Have you ever used elicit drugs?",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                            value: drugs,
                            onChanged: (value) => setState(() {
                              drugs = value;
                              print(drugs);
                            }),
                            activeTrackColor: Colors.grey,
                            activeColor: Colors.blue,
                          ),
                        ],
                      )),
                  MySpacer(
                    height: 0.001,
                  ),
                  Container(
                      width: displayWidth(context) * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: displayWidth(context) * 0.6,
                            child: AutoSizeText(
                              "Have you had more than 1 sexual partner within the past 12 months?",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                            value: sexualPartner,
                            onChanged: (value) => setState(() {
                              sexualPartner = value;
                              print(sexualPartner);
                            }),
                            activeTrackColor: Colors.grey,
                            activeColor: Colors.blue,
                          ),
                        ],
                      )),
                  MySpacer(
                    height: 0.27,
                  ),
                  Container(
                      width: displayWidth(context) * 1,
                      height: displayHeight(context) * 0.075,
                      child: MaterialButton(
                          onPressed: () {
                            //api request here
                            finalSmoke = smoke;
                            finalAlcohol = alcohol;
                            finalDrugs = drugs;
                            finalSexualPartner = sexualPartner;
                            // print('smoke: $smoke');
                            // print('alcohol : $alcohol');
                            // print('drugs : $drugs');
                            // print('sexualPartner : $sexualPartner');
                            registerData();
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Show Me',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Open-Sans-Regular',
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ],
                          )))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  setPreferences(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    {
      await prefs.setInt('id', id);
      await prefs.setString('heightInches', finalHeight.toStringAsFixed(2));
    }
  }

  registerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await post(
      'https://www.aoide.tk/api/register',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_name': finalUsername,
        'email_address': finalEmail,
        'user_password': finalPassword,
        "confirm_user_password": finalConfirmPassword,
      }),
    );
    final res = json.decode(response.body);
    if (response.statusCode == 200) {
      if (response.body.contains('errors')) {
        hadError = true;
        Navigator.pushNamed(context, '/register');
        if ((res['errors']['user_name'] != null) &&
            (res['errors']['user_name'] != null)) {
          var userError = res['errors']['user_name'][0].toString();
          var emailError = res['errors']['email_address'][0].toString();
          showAlert('$userError\n\n$emailError');
        } else if (res['errors']['user_name'] != null) {
          showAlert(
            res['errors']['user_name'][0].toString(),
          );
        } else if (res['errors']['email_address'] != null) {
          showAlert(
            res['errors']['email_address'][0].toString(),
          );
        } else {
          showAlert(res['errors']);
        }
        return;
      }
      print('registration successs');
      await setPreferences(res['data']['id']);
      //print(res['data']['id']);
      print(res);
      var id = prefs.getInt('id');
      registerDataPg2() async {
        if (finalGender == 'Male') {
          finalGender = 'M';
        } else if (finalGender == 'Female') {
          finalGender = 'F';
        }

        final response = await put(
          'https://www.aoide.tk/api/users/general-infos/$id',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'birthday': finalBirthday.toString(),
            'age': finalAge.toString(),
            // 'image': userAvatar,
            'gender': finalGender.toString(),
            'race': finalRace.toString(),
            'height': finalHeight.toString(),
            'height_unit': finalHeightUnit.toString(),
            'weight': finalWeight.toString(),
            'weight_unit': finalWeightUnit.toString(),
            'bmi': bmiFinal.toStringAsFixed(2),
            'bmi_category': bmiCategoryFinal.toString(),
          }),
        );
        final res = json.decode(response.body);
        if (response.statusCode == 200) {
          print('registration successs 2');
          print(res);

          if (response.body.contains('errors')) {
            Navigator.pushNamed(context, '/register2nd');
          }
        }
      }

      saveWeight() async {
        try {
          final response = await post(
            'https://aoide.tk/api/users/weight-history/$id',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'weight': finalWeight.toString(),
              'weight_unit': finalWeightUnit.toString(),
              'bmi': bmiFinal.toStringAsFixed(2),
              // 'created_at': get,
              // 'date': get,
            }),
          );
          final res = json.decode(response.body);
          if (response.statusCode == 200) {
            print(res);
          } else {
            print(res);
          }
        } catch (Exception) {
          print(Exception);
        }
      }

      registerDataPg3() async {
        if (finalGender == 'Male') {
          finalGender = 'M';
        } else if (finalGender == 'Female') {
          finalGender = 'F';
        }

        final response = await put(
          'https://www.aoide.tk/api/users/medical-conditions/$id',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, bool>{
            'has_prior_heart_attack_or_coronary_artery_disease':
                finalHeartAttack,
            'has_stroke': finalStroke,
            // 'image': userAvatar,
            'has_diabetes': finalDiabetes,
            'has_high_blood_pressure_or_hypertension': finalHighBlood,
            'has_kidney_disease': finalKidney,
            'has_family_history_of_heart_attack_stroke_diabetes': finalFamily,
          }),
        );
        final res = json.decode(response.body);
        if (response.statusCode == 200) {
          print('registration successs 3');
          print(res);
          if (response.body.contains('errors')) {
            Navigator.pushNamed(context, '/register3rd');
          }
        }
      }

      registerDataPg4() async {
        final response = await put(
          'https://aoide.tk/api/users/bad-habits/$id',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, bool>{
            'smoke': finalSmoke,
            'alcohol': finalAlcohol,
            // 'image': userAvatar,
            'illicit_drugs': finalDrugs,
            'more_than_one_sexual_partner': finalSexualPartner,
          }),
        );
        final res = json.decode(response.body);
        if (response.statusCode == 200) {
          print('registration successs 4');
          // Navigator.pushNamedAndRemoveUntil(
          //     context, "/home", (Route<dynamic> route) => false);
          print(res);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          {
            await prefs.setString('gender', finalGender);
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AvatarScreen(
                  gender: finalGender,
                ),
              ));
          if (response.body.contains('errors')) {
            Navigator.pushNamed(context, '/register4th');
          }
        }
      }

      await registerDataPg2();
      await registerDataPg3();
      await saveWeight();
      // await createLog('added', 'Added weight');
      await registerDataPg4();
      await getCategories();
      await checklist(
          finalAge,
          finalGender,
          bmiFinal,
          bmiCategoryFinal.toString(),
          finalSexualPartner,
          finalSmoke,
          finalHeartAttack,
          finalDiabetes);
    } else if (response.body.contains('errors')) {
      print(res['errors']);
      Navigator.pushNamed(context, '/register');
    }
  }

  showAlert(String message) {
    Alert(
      context: context,
      style: alertStyle,
      title: "",
      desc: message,
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

  // print(finalEmail);
  // print(finalUsername);
  // print(finalPassword);
  // print(finalConfirmPassword);
  // print(finalBirthday);
  // print(finalAge);
  // print(finalGender);
  // print(finalRace);
  // print(finalHeight);
  // print(finalWeight);
  // print(finalHeightUnit);
  // print(finalWeightUnit);
  // print(finalHeartAttack);
  // print(finalStroke);
  // print(finalDiabetes);
  // print(finalHighBlood);
  // print(finalKidney);
  // print(finalFamily);
  // print(finalSmoke);
  // print(finalAlcohol);
  // print(finalDrugs);
  // print(finalSexualPartner);
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
