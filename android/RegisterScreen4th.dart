// import 'package:Aiode/pages/Auth/Register/RegisterScreen.dart';
// import 'package:Aiode/pages/Auth/Register/TempRegisterModel.dart';
// import 'package:flutter/material.dart';
// import 'package:Aiode/helpers/size.dart';
// import 'package:Aiode/commons/MySpacer.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:http/http.dart';
// import 'dart:convert';

// class RegisterScreen4th extends StatefulWidget {
//   @override
//   _RegisterScreen4thState createState() => _RegisterScreen4thState();
// }

// bool smoke = false;
// bool alcohol = false;
// bool drugs = false;
// bool sexualPartner = false;

// class _RegisterScreen4thState extends State<RegisterScreen4th> {
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
//                     "Step 4",
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
//                     'assets/images/misc/step4.png',
//                     height: displayHeight(context) * 0.07,
//                   ),
//                   MySpacer(
//                     height: 0.001,
//                   ),
//                   // Container(
//                   //     width: displayWidth(context) * 0.8,
//                   //     child: Text(
//                   //       "Do you have any of the following medical conditions? ( Select all that apply )",
//                   //       textAlign: TextAlign.center,
//                   //       style: TextStyle(
//                   //         color: Colors.black,
//                   //         fontFamily: 'Open-Sans-Regular',
//                   //         fontSize: 14,
//                   //       ),
//                   //     )),
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
//                               "Have you ever smoked?",
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontFamily: 'Open-Sans-Regular',
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                           Switch(
//                             value: smoke,
//                             onChanged: (value) => setState(() {
//                               smoke = value;
//                               print(smoke);
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
//                               "Do you drink alcohol?",
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontFamily: 'Open-Sans-Regular',
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                           Switch(
//                             value: alcohol,
//                             onChanged: (value) => setState(() {
//                               alcohol = value;
//                               print(alcohol);
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
//                               "Have you ever used elicit drugs?",
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontFamily: 'Open-Sans-Regular',
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                           Switch(
//                             value: drugs,
//                             onChanged: (value) => setState(() {
//                               drugs = value;
//                               print(drugs);
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
//                               "Have you had more than 1 sexual partner within the past 12 months?",
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontFamily: 'Open-Sans-Regular',
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                           Switch(
//                             value: sexualPartner,
//                             onChanged: (value) => setState(() {
//                               sexualPartner = value;
//                               print(sexualPartner);
//                             }),
//                             activeTrackColor: Colors.grey,
//                             activeColor: Colors.blue,
//                           ),
//                         ],
//                       )),
//                   MySpacer(
//                     height: 0.175,
//                   ),
//                   Container(
//                       width: displayWidth(context) * 1,
//                       height: displayHeight(context) * 0.075,
//                       child: MaterialButton(
//                           onPressed: () {
//                             //api request here
//                             // RegisterScreen4Data data = RegisterScreen4Data();
//                             // RegisterScreen1Data data1 = RegisterScreen1Data();
//                             // data.smoke = smoke;
//                             // data.alcohol = alcohol;
//                             // data.drugs = drugs;
//                             // data.sexualPartner = sexualPartner;
//                             print('smoke: $smoke');
//                             print('alcohol : $alcohol');
//                             print('drugs : $drugs');
//                             print('sexualPartner : $sexualPartner');

//                           },
//                           color: Colors.blue,
//                           textColor: Colors.white,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Show Me',
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
//                           )))
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   RegisterScreen1Data data1 = RegisterScreen1Data();
//   registerData1() {
//     //   final response = await post(
//     //     'https://www.aoide.tk/api/register',
//     //     headers: <String, String>{
//     //       'Content-Type': 'application/json; charset=UTF-8',
//     //     },
//     //     body: jsonEncode(<String, String>{
//     //       'user_name': data1.username,
//     //       'email_address': data1.email,
//     //       'user_password': data1.password,
//     //       "confirm_user_password": data1.confirmPassword,
//     //     }),
//     //   );
//     //   final res = json.decode(response.body);
//     //   if (response.statusCode == 200) {
//     //     print('registration successs');
//     //   } else if (res.contains('errors')) {}
//     //
//     print(data1.username);
//   }
// }
