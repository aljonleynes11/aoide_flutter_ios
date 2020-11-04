// import 'package:Aiode/pages/Auth/Register/tempRegisterModel.dart';
// import 'package:flutter/material.dart';
// import 'package:Aiode/helpers/size.dart';
// import 'package:Aiode/commons/MySpacer.dart';
// import 'package:auto_size_text/auto_size_text.dart';

// class RegisterScreen3rd extends StatefulWidget {
//   @override
//   _RegisterScreen3rdState createState() => _RegisterScreen3rdState();
// }

// bool heartAttack = false;
// bool stroke = false;
// bool diabetes = false;
// bool highBlood = false;
// bool kidney = false;
// bool family = false;

// class _RegisterScreen3rdState extends State<RegisterScreen3rd> {
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
//             child: Center(
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
//                     "Step 3",
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
//                         "Medical History",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontFamily: 'Open-Sans-Regular',
//                           fontSize: 14,
//                         ),
//                       )),
//                   MySpacer(
//                     height: 0.001,
//                   ),
//                   Image.asset(
//                     'assets/images/misc/step3.png',
//                     height: displayHeight(context) * 0.07,
//                   ),
//                   MySpacer(
//                     height: 0.001,
//                   ),
//                   Container(
//                       width: displayWidth(context) * 0.8,
//                       child: Text(
//                         "Do you have any of the following medical conditions? ( Select all that apply )",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontFamily: 'Open-Sans-Regular',
//                           fontSize: 14,
//                         ),
//                       )),
//                   MySpacer(
//                     height: 0.03,
//                   ),
//                   Container(
//                       width: displayWidth(context) * 0.8,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: displayWidth(context) * 0.6,
//                             child: AutoSizeText(
//                               "Prior heartAttack attack/coronary artery disease",
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontFamily: 'Open-Sans-Regular',
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                           Switch(
//                             value: heartAttack,
//                             onChanged: (value) => setState(() {
//                               heartAttack = value;
//                               print(heartAttack);
//                             }),
//                             activeTrackColor: Colors.grey,
//                             activeColor: Colors.blue,
//                           ),
//                         ],
//                       )),
//                   MySpacer(
//                     height: 0.001,
//                   ),
//                   Container(
//                       width: displayWidth(context) * 0.8,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: displayWidth(context) * 0.6,
//                             child: AutoSizeText(
//                               "Stroke",
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontFamily: 'Open-Sans-Regular',
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                           Switch(
//                             value: stroke,
//                             onChanged: (value) => setState(() {
//                               stroke = value;
//                               print(stroke);
//                             }),
//                             activeTrackColor: Colors.grey,
//                             activeColor: Colors.blue,
//                           ),
//                         ],
//                       )),
//                   MySpacer(
//                     height: 0.001,
//                   ),
//                   Container(
//                       width: displayWidth(context) * 0.8,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: displayWidth(context) * 0.6,
//                             child: AutoSizeText(
//                               "Diabetes",
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontFamily: 'Open-Sans-Regular',
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                           Switch(
//                             value: diabetes,
//                             onChanged: (value) => setState(() {
//                               diabetes = value;
//                               print(diabetes);
//                             }),
//                             activeTrackColor: Colors.grey,
//                             activeColor: Colors.blue,
//                           ),
//                         ],
//                       )),
//                   MySpacer(
//                     height: 0.001,
//                   ),
//                   Container(
//                       width: displayWidth(context) * 0.8,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: displayWidth(context) * 0.6,
//                             child: AutoSizeText(
//                               "High blood pressure /  Hypertension",
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontFamily: 'Open-Sans-Regular',
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                           Switch(
//                             value: highBlood,
//                             onChanged: (value) => setState(() {
//                               highBlood = value;
//                               print(highBlood);
//                             }),
//                             activeTrackColor: Colors.grey,
//                             activeColor: Colors.blue,
//                           ),
//                         ],
//                       )),
//                   MySpacer(
//                     height: 0.001,
//                   ),
//                   Container(
//                       width: displayWidth(context) * 0.8,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: displayWidth(context) * 0.6,
//                             child: AutoSizeText(
//                               "Kidney disease",
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontFamily: 'Open-Sans-Regular',
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                           Switch(
//                             value: kidney,
//                             onChanged: (value) => setState(() {
//                               kidney = value;
//                               print(kidney);
//                             }),
//                             activeTrackColor: Colors.grey,
//                             activeColor: Colors.blue,
//                           ),
//                         ],
//                       )),
//                   Container(
//                       margin: const EdgeInsets.only(left: 40.0, right: 40.0),
//                       child: Divider(
//                         color: Colors.grey,
//                         height: 5,
//                       )),
//                   MySpacer(
//                     height: 0.001,
//                   ),
//                   Container(
//                       width: displayWidth(context) * 0.8,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: displayWidth(context) * 0.6,
//                             child: AutoSizeText(
//                               "Do you have any family history of a heart attack, stroke or diabetes?",
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontFamily: 'Open-Sans-Regular',
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                           Switch(
//                             value: family,
//                             onChanged: (value) => setState(() {
//                               family = value;
//                               print(family);
//                             }),
//                             activeTrackColor: Colors.grey,
//                             activeColor: Colors.blue,
//                           ),
//                         ],
//                       )),
//                   MySpacer(
//                     height: 0.03,
//                   ),
//                   Container(
//                       height: displayHeight(context) * 0.075,
//                       width: displayWidth(context) * 1,
//                       child: MaterialButton(
//                           onPressed: () {
//                             //api request here
//                             print('heart attack: $heartAttack');
//                             print('stroke : $stroke');
//                             print('diabetes : $diabetes');
//                             print('highBlood : $highBlood');
//                             print('kidney : $kidney');
//                             print('family : $family');
//                             // RegisterScreen3Data data = RegisterScreen3Data();
//                             // data.heartAttack = heartAttack;
//                             // data.stroke = stroke;
//                             // data.diabetes = diabetes;
//                             // data.highBlood = highBlood;
//                             // data.kidney = kidney;
//                             // data.family = family;

//                             Navigator.pushNamed(context, '/register4th');
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
