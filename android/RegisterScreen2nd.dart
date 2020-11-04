// import 'package:Aiode/pages/Auth/Register/tempRegisterModel.dart';
// import 'package:flutter/material.dart';
// import 'package:Aiode/helpers/size.dart';
// import 'package:Aiode/commons/MySpacer.dart';
// import 'package:intl/intl.dart';
// import 'package:group_radio_button/group_radio_button.dart';
// import 'package:flutter/services.dart';
// import 'package:toggle_switch/toggle_switch.dart';

// class RegisterScreen2nd extends StatefulWidget {
//   @override
//   _RegisterScreen2ndState createState() => _RegisterScreen2ndState();
// }

// var dobController = TextEditingController();
// String gender;
// String race;
// var heightController = TextEditingController();
// var weightController = TextEditingController();
// var heightUnit = "cm";
// var weightUnit = "lb";
// var tempWeight;

// void getUnit(unit, String bm) {
//   if (bm == "weight") {
//     if (unit == 0) {
//       weightUnit = "lb";
//     } else {
//       weightUnit = "kg";
//     }
//   } else if (bm == "height") {
//     if (unit == 0) {
//       heightUnit = "cm";
//     } else {
//       heightUnit = "in";
//     }
//   }
// }

// List<String> _status = ["Male", "Female"];
// DateTime now = new DateTime.now();

// class _RegisterScreen2ndState extends State<RegisterScreen2nd> {
//   @override
//   Widget build(BuildContext context) {
//     final bottom = MediaQuery.of(context).viewInsets.bottom;

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SingleChildScrollView(
//         reverse: true,
//         child: Padding(
//           padding: EdgeInsets.only(bottom: bottom),
//           child: Container(
//             color: Colors.white,
//             child: Container(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   MySpacer(
//                     height: 0.12,
//                   ),
//                   Image.asset(
//                     'assets/images/misc/logo.png',
//                     height: displayHeight(context) * 0.1,
//                   ),
//                   MySpacer(
//                     height: 0.02,
//                   ),
//                   Container(
//                       child: Text(
//                     "Getting to Know You",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 20.0,
//                       fontFamily: 'Open-Sans-Regular',
//                       color: Colors.black,
//                     ),
//                   )),
//                   Container(
//                       child: Text(
//                     "Step 2",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontFamily: 'Open-Sans-Regular',
//                       color: Colors.grey[400],
//                     ),
//                   )),
//                   MySpacer(
//                     height: 0.02,
//                   ),
//                   Container(
//                       width: displayWidth(context) * 0.6,
//                       child: Text(
//                         "Personal Information",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontFamily: 'Open-Sans-Regular',
//                           fontSize: 15,
//                         ),
//                       )),
//                   MySpacer(
//                     height: 0.01,
//                   ),
//                   Image.asset(
//                     'assets/images/misc/step2.png',
//                     height: displayHeight(context) * 0.076,
//                   ),
//                   MySpacer(
//                     height: 0.001,
//                   ),
//                   Container(
//                     width: displayWidth(context) * 0.76,
//                     child: TextField(
//                         style: TextStyle(
//                             fontFamily: 'Open-Sans-Regular', fontSize: 12),
//                         //showCursor: true,
//                         readOnly: true,
//                         controller: dobController,
//                         decoration: InputDecoration(
//                           contentPadding: const EdgeInsets.all(5.0),
//                           hintText: "Birthday",
//                           hintStyle: TextStyle(
//                               fontFamily: 'Open-Sans-Regular', fontSize: 12),
//                         ),
//                         onTap: () {
//                           FocusScope.of(context).requestFocus(new FocusNode());
//                           showDatePicker(
//                               context: context,
//                               initialDate: DateTime.now(),
//                               firstDate: DateTime(1900, 1),
//                               lastDate: DateTime.now(),
//                               builder: (BuildContext context, Widget picker) {
//                                 return Theme(
//                                   data: ThemeData(
//                                     buttonTheme: ButtonThemeData(
//                                         textTheme: ButtonTextTheme.primary),
//                                     dialogBackgroundColor: Colors.white,
//                                   ),
//                                   child: picker,
//                                 );
//                               }).then((selectedDate) {
//                             if (selectedDate != null) {
//                               dobController.text = DateFormat('MMMM dd, yyyy')
//                                   .format(selectedDate);
//                             }
//                           });
//                         }),
//                   ),
//                   MySpacer(
//                     height: 0.02,
//                   ),
//                   Container(
//                     width: displayWidth(context) * 0.76,
//                     child: Row(
//                       children: [
//                         Text(
//                           'Gender',
//                           style: TextStyle(
//                               fontSize: 12, fontFamily: 'Open-Sans-Regular'),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     width: displayWidth(context) * 0.76,
//                     child: Row(
//                       children: [
//                         RadioGroup<String>.builder(
//                           direction: Axis.horizontal,
//                           groupValue: gender,
//                           onChanged: (value) => setState(() {
//                             gender = value;
//                           }),
//                           items: _status,
//                           itemBuilder: (item) => RadioButtonBuilder(
//                             item,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                       width: displayWidth(context) * 0.76,
//                       child: DropdownButton(
//                         hint: race == null
//                             ? Text(
//                                 '  Race',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontFamily: 'Open-Sans-Regular',
//                                 ),
//                               )
//                             : Text(
//                                 '  $race',
//                                 style: TextStyle(
//                                     fontSize: 14,
//                                     fontFamily: 'Open-Sans-Regular',
//                                     color: Colors.black),
//                               ),
//                         isExpanded: true,
//                         iconSize: 30.0,
//                         items: [
//                           'Asian',
//                           'American Indian / Alaska Native',
//                           'Native Hawaiian / Other Pacific Islander',
//                           'Black',
//                           'White',
//                           'More than one race'
//                         ].map(
//                           (val) {
//                             return DropdownMenuItem<String>(
//                               value: val,
//                               child: Text(val),
//                             );
//                           },
//                         ).toList(),
//                         onChanged: (val) {
//                           setState(
//                             () {
//                               race = val;
//                               print(race);
//                             },
//                           );
//                         },
//                       )),
//                   MySpacer(
//                     height: 0.005,
//                   ),
//                   Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                     Container(
//                         width: displayWidth(context) * 0.555,
//                         child: TextField(
//                             style: TextStyle(
//                                 fontFamily: 'Open-Sans-Regular',
//                                 fontSize: 12,
//                                 color: Colors.black),
//                             keyboardType: TextInputType.number,
//                             controller: heightController,
//                             decoration: InputDecoration(
//                               contentPadding: const EdgeInsets.all(5.0),
//                               hintText: 'Height',
//                               hintStyle: TextStyle(
//                                   fontFamily: 'Open-Sans-Regular',
//                                   fontSize: 12),
//                             ))),
//                     ToggleSwitch(
//                       minWidth: 40.0,
//                       minHeight: 20.0,
//                       cornerRadius: 0,
//                       activeBgColor: Colors.blue,
//                       activeFgColor: Colors.white,
//                       inactiveBgColor: Colors.grey,
//                       inactiveFgColor: Colors.grey,
//                       labels: ['cm', 'in'],
//                       onToggle: (index) {
//                         print('switched to: $index');
//                         getUnit(index, "height");
//                       },
//                     ),
//                   ]),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                           width: displayWidth(context) * 0.555,
//                           child: TextField(
//                               style: TextStyle(
//                                   fontFamily: 'Open-Sans-Regular',
//                                   fontSize: 12),
//                               keyboardType: TextInputType.number,
//                               controller: weightController,
//                               decoration: InputDecoration(
//                                 contentPadding: const EdgeInsets.all(5.0),
//                                 hintText: 'Weight',
//                                 hintStyle: TextStyle(
//                                     fontFamily: 'Open-Sans-Regular',
//                                     fontSize: 12,
//                                     color: Colors.black),
//                               ))),
//                       ToggleSwitch(
//                         minWidth: 40.0,
//                         minHeight: 20.0,
//                         cornerRadius: 0,
//                         activeBgColor: Colors.blue,
//                         activeFgColor: Colors.white,
//                         inactiveBgColor: Colors.grey,
//                         inactiveFgColor: Colors.grey,
//                         labels: ['lb', 'kg'],
//                         onToggle: (index2) {
//                           print('switched to: $index2');
//                           getUnit(index2, "weight");
//                         },
//                       ),
//                     ],
//                   ),
//                   MySpacer(
//                     height: 0.115,
//                   ),
//                   Container(
//                       width: displayWidth(context) * 1,
//                       height: displayHeight(context) * 0.075,
//                       child: MaterialButton(
//                           onPressed: () {
//                             //api request here
//                             Navigator.pushNamed(context, '/register3rd');
//                             var height = heightController.text;
//                             var weight = weightController.text;

//                             var birthday = new DateFormat("MMMM dd, yyyy")
//                                 .parse(dobController.text);

//                             double tempAge =
//                                 DateTime.now().difference(birthday).inDays /
//                                     365;
//                             int age = tempAge.toInt();
//                             print(birthday);
//                             print(age);
//                             print(gender);
//                             print(race);
//                             print('$height $heightUnit');
//                             print('$weight $weightUnit');

//                             RegisterScreen2Data data = RegisterScreen2Data();
//                             data.birthday = birthday;
//                             data.age = age;
//                             data.gender = gender;
//                             data.race = race;
//                             data.height = double.parse(height);
//                             data.weight = double.parse(weight);
//                             data.heightUnit = heightUnit;
//                             data.weightUnit = weightUnit;
//                           },
//                           color: Colors.blue,
//                           textColor: Colors.white,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Next Step',
//                                 style: TextStyle(
//                                   fontSize: 14.0,
//                                   fontFamily: 'Open-Sans-Regular',
//                                 ),
//                               ),
//                               Icon(
//                                 Icons.arrow_forward,
//                                 color: Colors.white,
//                                 size: 20.0,
//                               ),
//                             ],
//                           ))),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
