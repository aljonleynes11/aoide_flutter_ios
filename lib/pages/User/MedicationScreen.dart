import 'dart:convert';

import 'package:Aiode/commons/BottomNavBar.dart';
import 'package:Aiode/commons/CustomIcons.dart';
import 'package:Aiode/commons/TopNavBar.dart';
import 'package:Aiode/helpers/size.dart';
import 'package:Aiode/commons/MySpacer.dart';
import 'package:Aiode/commons/BottomNavBar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Aiode/helpers/size.dart';
import 'package:Aiode/commons/MySpacer.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'dart:math';
import 'package:Aiode/services/LogServices.dart';

class MedicationScreen extends StatefulWidget {
  @override
  _MedicationScreenState createState() => _MedicationScreenState();
}

String textHeader =
    'Make a list of medications you are taking now. Include the dose, how often you take them, the imprint on each tablet or capsule, and the name of the pharmacy. The imprint can help you identify a drug when you get refills.';
var frequencyList = [
  "Once a day",
  "Twice a day",
  "Three times a day",
  "Every 6 hours",
  "Every other day",
  "Once in a week",
];
double percentage = 0.1;
var drugNameController = TextEditingController();
var dosageController = TextEditingController();
var timeTextFieldController = TextEditingController();
var frequencyController = TextEditingController();

@override
class _MedicationScreenState extends State<MedicationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TopNavBar(
      activeIndex: 1,
      iconButton: new IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/home');
          }),
      screenBody: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "assets/images/backgrounds/background-perfect-cut.png"),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                MySpacer(height: 0.13),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 5),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white24,
                          child: IconButton(
                            icon: Icon(
                              CustomIcons.pill,
                              size: 25,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Text(
                        "Medication",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Open-Sans-Regular',
                          letterSpacing: 2.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                MySpacer(height: 0.02),
                header(),
                addButton(),
                collapsible(),
              ]))),
    );
    // return FutureBuilder(
    //     future: getData(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Scaffold(
    //             body: Center(
    //                 child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Image.asset(
    //               'assets/images/misc/logo.png',
    //               height: displayHeight(context) * 0.1,
    //             ),
    //             Image.asset(
    //               'assets/images/misc/profile-loading.gif',
    //               height: displayHeight(context) * 0.2,
    //             ),
    //           ],
    //         )));
    //       } else {
    //         if (snapshot.hasError)
    //           return Scaffold(
    //               body: Center(
    //                   child: Text(
    //                       'Please make sure you have internet connection')));
    //         else if (snapshot.hasData)

    //       }
    //     });
  }

  void showModalInputSheet() {
    Alert(
        context: context,
        title: 'Add Medication',
        style: alertStyle,
        content: Column(
          children: <Widget>[
            Container(
              width: displayWidth(context) * 0.6,
              child: TextFormField(
                maxLength: 30,
                controller: drugNameController,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open-Sans-Regular',
                ),
                decoration: InputDecoration(
                  icon: Icon(
                    CustomIcons.pill,
                    size: 50,
                  ),
                  labelText: 'Medication',
                ),
                validator: (String value) {
                  return value.contains('@') ? 'Please enter drug name' : null;
                },
              ),
            ),
            Container(
              width: displayWidth(context) * 0.6,
              child: TextFormField(
                maxLength: 4,
                controller: dosageController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open-Sans-Regular',
                ),
                decoration: InputDecoration(
                  icon: Icon(
                    CustomIcons.pill,
                    size: 0,
                  ),
                  labelText: 'Dosage in mg',
                ),
              ),
            ),
            Container(
              width: displayWidth(context) * 0.6,
              child: TextField(
                  controller: timeTextFieldController,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Open-Sans-Regular',
                  ),
                  decoration: InputDecoration(
                    icon: Icon(
                      CustomIcons.pill,
                      size: 0,
                    ),
                    labelText: 'Time',
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    dateTimePicker();
                  }),
            ),
            //frequency
            MySpacer(height: 0.03),
            Container(
              width: displayWidth(context) * 0.6,
              child: TextField(
                  controller: frequencyController,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Open-Sans-Regular',
                  ),
                  decoration: InputDecoration(
                    icon: Icon(
                      CustomIcons.pill,
                      size: 0,
                    ),
                    labelText: 'Frequency',
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    frequencySlider();
                  }),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              Navigator.pop(context);
              String tempVar = timeTextFieldController.text;
              DateTime tempDate = new DateFormat("hh:mm a").parse(tempVar);
              String toInt = DateFormat('HHmm').format(tempDate);
              String toSave = DateFormat('HH:mm').format(tempDate);
              int nowInInt = int.parse(toInt);
              print(nowInInt.toString());
              if (nowInInt >= 0000 && nowInInt <= 1159) {
                print('morning');
                await saveNewData(drugNameController.text,
                    dosageController.text, toSave, 'morning');
                // setState(() {

                // });
              } else if (nowInInt >= 1200 && nowInInt <= 1759) {
                print('afternoon');
                await saveNewData(drugNameController.text,
                    dosageController.text, toSave, 'afternoon');
              } else {
                print('evening');
                await saveNewData(drugNameController.text,
                    dosageController.text, toSave, 'evening');
              }
              setState(() {
                dosageController.clear();
                timeTextFieldController.clear();
                drugNameController.clear();
                frequencyController.clear();
              });
            },
            child: Text(
              "Add Medication",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ]).show();
  }

  Widget addButton() {
    return Container(
        width: displayWidth(context) * 1,
        color: Colors.white,
        child: Center(
            child: Container(
          width: displayWidth(context) * 0.78,
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            color: Colors.blue[600],
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 70, vertical: 6),
            onPressed: () async {
              print('add data');
              showModalInputSheet();
            },
            child: Text(
              'Add Medication',
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Open-Sans-Regular',
              ),
            ),
          ),
        )));
  }

  Widget header() {
    return Center(
      child: Card(
        color: Colors.transparent,
        child: Container(
          width: displayWidth(context) * 1,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Text(
            '$textHeader',
            style: TextStyle(
                fontSize: 11,
                fontFamily: 'Open-Sans-Regular',
                color: Colors.white),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }

  var morningList;
  var afternoonList;
  var eveningList;

  Future<String> getDataMorning() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    final response =
        await get('https://www.aoide.tk/api/users/morning-medications/$id');
    if (response.statusCode == 200) {
      var myJson = json.decode(response.body);
      //print(myJson);
      morningList = myJson['data']['morning_medication'];
      morningList.forEach((medication) {
        bool isActive = false;
        if (medication['is_active'] == 1) {
          medication['is_active'] = true;
        } else {
          medication['is_active'] = false;
        }
        DateTime tempDate =
            new DateFormat("hh:mm:ss").parse(medication['time'].toString());
        medication['time'] = DateFormat("hh:mm a").format(tempDate);
      });
    }
    return 'Data Fetched';
  }

  Future<String> getDataAfternoon() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    final response =
        await get('https://www.aoide.tk/api/users/afternoon-medications/$id');
    if (response.statusCode == 200) {
      var myJson = json.decode(response.body);
      afternoonList = myJson['data']['afternoon_medication'];
      afternoonList.forEach((medication) {
        bool isActive = false;
        if (medication['is_active'] == 1) {
          medication['is_active'] = true;
        } else {
          medication['is_active'] = false;
        }

        DateTime tempDate =
            new DateFormat("hh:mm:ss").parse(medication['time'].toString());
        medication['time'] = DateFormat("hh:mm a").format(tempDate);
      });
    }
    return 'Data Fetched';
  }

  Future<String> getDataEvening() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    final response =
        await get('https://www.aoide.tk/api/users/evening-medications/$id');
    if (response.statusCode == 200) {
      var myJson = json.decode(response.body);
      eveningList = myJson['data']['evening_medication'];
      eveningList.forEach((medication) {
        bool isActive = false;
        if (medication['is_active'] == 1) {
          medication['is_active'] = true;
        } else {
          medication['is_active'] = false;
        }
        DateTime tempDate =
            new DateFormat("hh:mm:ss").parse(medication['time'].toString());
        medication['time'] = DateFormat("hh:mm a").format(tempDate);
      });
    }
    return 'Data Fetched';
  }

  //    String feature;
  // int id;
  // bool isActive;
  // bool isChecked;
  saveNewData(
    String drugName,
    String dosage,
    String time,
    String timeOfDay,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    String url;
    if (timeOfDay == 'morning') {
      url = 'https://www.aoide.tk/api/users/morning-medications/$id';
    } else if (timeOfDay == 'afternoon') {
      url = 'https://www.aoide.tk/api/users/afternoon-medications/$id';
    } else if (timeOfDay == 'evening') {
      url = 'https://www.aoide.tk/api/users/evening-medications/$id';
    }

    try {
      final response = await post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'drug': drugName.toString(),
          'dose': dosage.toString() + 'mg',
          'time': time.toString(),
          'is_active': true,
          //
          'monday': false,
          'tuesday': false,
          'wednesday': false,
          'thursday': false,
          'friday': false,
          'saturday': false,
          'sunday': false,
        }),
      );
      final res = json.decode(response.body);
      if (response.statusCode == 200) {
        await createLog('added', 'Added a Medication');
        setState(() {
          drugNameController.clear();
          dosageController.clear();
          timeTextFieldController.clear();
        });
      }
      print(res);
    } catch (e) {
      print(e);
    }
  }

  saveDataStateMorning(bool value, int dataId) async {
    String url;
    (value == false)
        ? url =
            'https://aoide.tk/api/users/deactivate/morning-medications/$dataId'
        : url =
            'https://aoide.tk/api/users/activate/morning-medications/$dataId';

    try {
      final response = await put(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      final res = json.decode(response.body);
      if (response.statusCode == 200) {
        await createLog('change', 'Change state of morning medication');
        setState(() {});
      }
      print(res);
    } catch (e) {
      print(e);
    }
  }

  saveDataStateAfternoon(bool value, int dataId) async {
    String url;
    (value == false)
        ? url =
            'https://aoide.tk/api/users/deactivate/afternoon-medications/$dataId'
        : url =
            'https://aoide.tk/api/users/activate/afternoon-medications/$dataId';

    try {
      final response = await put(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      final res = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() {});
        await createLog('change', 'Change state of afternoon medication');
      }
      print(res);
    } catch (e) {
      print(e);
    }
  }

  saveDataStateEvening(bool value, int dataId) async {
    String url;
    (value == false)
        ? url =
            'https://aoide.tk/api/users/deactivate/evening-medications/$dataId'
        : url =
            'https://aoide.tk/api/users/activate/evening-medications/$dataId';

    try {
      final response = await put(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      final res = json.decode(response.body);
      if (response.statusCode == 200) {}
      await createLog('change', 'Change state of evening medication');
      print(res);
    } catch (e) {
      print(e);
    }
  }

  deleteDataMorning(int dataId) async {
    try {
      final response = await delete(
          'https://www.aoide.tk/api/users/morning-medications/$dataId',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      final res = json.decode(response.body);
      if (response.statusCode == 200) {
        await createLog('deleted', 'Deleted morning medication');
        Navigator.popAndPushNamed(context, '/medication');
      }
      print(res);
    } catch (e) {
      print(e);
    }
  }

  deleteDataAfternoon(int dataId) async {
    try {
      final response = await delete(
          'https://www.aoide.tk/api/users/afternoon-medications/$dataId',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      final res = json.decode(response.body);
      if (response.statusCode == 200) {
        await createLog('deleted', 'Deleted afternoon medication');
      }
      print(res);
    } catch (e) {
      print(e);
    }
  }

  deleteDataEvening(int dataId) async {
    try {
      final response = await delete(
          'https://www.aoide.tk/api/users/evening-medications/$dataId',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      final res = json.decode(response.body);
      if (response.statusCode == 200) {
        await createLog('deleted', 'Deleted evening medication');
      }
      print(res);
    } catch (e) {
      print(e);
    }
  }

  frequencySlider() {
    String frequencyString = "Choose a frequency";
    Alert(
        context: context,
        title: 'Frequency',
        style: alertStyle,
        content: Container(
          width: displayWidth(context) * 0.6,
          child: DropdownButton(
            hint: frequencyString == null
                ? Text(
                    '  provider',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Open-Sans-Regular',
                    ),
                  )
                : Text(
                    '  $frequencyString',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Open-Sans-Regular',
                        color: Colors.black),
                  ),
            isExpanded: true,
            iconSize: 30.0,
            items: [for (var i in frequencyList) i].map(
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
                  frequencyString = val;
                  frequencyController.text = frequencyString;
                  Navigator.pop(context);
                },
              );
              print(frequencyString);
            },
          ),
        ),
        // Container(
        //     width: displayWidth(context) * 0.6,
        //     height: displayHeight(context) * 0.05,
        //     child: Center(
        //         child: new Swiper(
        //             itemBuilder: (BuildContext context, int index) {
        //               return new Container(
        //                   child: Text(
        //                 frequencyList[index],
        //                 textAlign: TextAlign.left,
        //                 style: TextStyle(
        //                   fontFamily: 'Open-Sans-Regular',
        //                   color: Colors.black,
        //                   fontSize: 12,
        //                 ),
        //               ));
        //             },
        //             itemCount: frequencyList.length,
        //             autoplay: false,
        //             viewportFraction: 0.6,
        //             scale: 1,
        //             onIndexChanged: (index) {
        //               frequencyController.text = frequencyList[index];
        //             }))
        //             ),
        buttons: [
          DialogButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text(
              "Set time",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ]).show();
  }

// dateTimePicker(),
  void dateTimePicker() {
    Alert(
        context: context,
        title: 'Choose a time',
        style: alertStyle,
        content: TimePickerSpinner(
          is24HourMode: false,
          normalTextStyle: TextStyle(fontSize: 12, color: Colors.grey),
          highlightedTextStyle: TextStyle(fontSize: 12, color: Colors.black),
          itemHeight: 50,
          isForce2Digits: false,
          onTimeChange: (time) {
            setState(() {
              String getTime = DateFormat('hh:mm a').format(time);
              timeTextFieldController.text = getTime.toString();
            });
          },
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text(
              "Set time",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ]).show();
  }

  Widget collapsible() {
    return Container(
      color: Colors.white,
      child: Column(children: [
        FutureBuilder(
            future: getDataMorning(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Container(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator()));
              }
              return Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: ExpansionTile(
                    leading: Icon(CustomIcons.sunrise),
                    title: Text(
                      "Morning",
                    ),
                    // backgroundColor: Colors.blueGrey[800],
                    // subtitle: Text("  Sub Title's"),
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 0),
                          height: displayHeight(context) * 0.3,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                          child: (morningList.length > 0)
                              ? ListView.builder(
                                  itemCount: morningList.length,
                                  itemBuilder: (context, index) {
                                    final med = morningList[index];
                                    return Dismissible(
                                      key: Key(med['drug']),
                                      onDismissed: (direction) async {
                                        await deleteDataMorning(med['id']);
                                        Toast.show(
                                            med['drug'] + ' deleted', context,
                                            duration: Toast.LENGTH_LONG,
                                            gravity: Toast.TOP);
                                        //   Alert(
                                        //       context: context,
                                        //       title: 'Are you sure to delete? ' +
                                        //           med['drug'],
                                        //       style: alertStyle,
                                        //       content: Container(),
                                        //       buttons: [
                                        //         DialogButton(
                                        //           onPressed: () async {
                                        //             Navigator.pop(context);
                                        //             //morning

                                        //           },
                                        //           color: Colors.white,
                                        //           border: Border.all(
                                        //               color: Colors.blueAccent),
                                        //           child: Text(
                                        //             "Yes",
                                        //             style: TextStyle(
                                        //                 color: Colors.blue,
                                        //                 fontSize: 16),
                                        //           ),
                                        //         ),
                                        //         DialogButton(
                                        //           onPressed: () async {
                                        //             Navigator.pop(context);
                                        //             setState(() {});
                                        //           },
                                        //           color: Colors.blue,
                                        //           child: Text(
                                        //             "No",
                                        //             style: TextStyle(
                                        //                 color: Colors.white,
                                        //                 fontSize: 16),
                                        //           ),
                                        //         ),
                                        //       ]).show();
                                        // },
                                      },

                                      background: Container(
                                        color: Colors.red,
                                        child: Icon(Icons.delete,
                                            color: Colors.white, size: 35),
                                      ),

                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                med['time']
                                                        .toString()
                                                        .substring(0, 5) +
                                                    ' AM',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    med['drug'].toString() +
                                                        ' - ' +
                                                        med['dose'].toString(),
                                                  ),
                                                ),
                                                Switch(
                                                  value: med['is_active'],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      saveDataStateMorning(
                                                          value, med['id']);
                                                    });
                                                  },
                                                  activeTrackColor: Colors.grey,
                                                  activeColor: Colors.blue,
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.grey,
                                              height: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // child:
                                      //     ListTile(title: Text(med['drug'].toString())),
                                    );
                                  })
                              : Center(
                                  child: Text(
                                      'You have no listed morning medication')))
                    ]),
              );
            }),
        FutureBuilder(
            future: getDataAfternoon(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Container(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator()));
              }
              return Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: ExpansionTile(
                    leading: Icon(Icons.wb_sunny),
                    title: Text("Afternoon"),

                    // subtitle: Text("  Sub Title's"),
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 0),
                          height: displayHeight(context) * 0.3,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                          child: (afternoonList.length > 0)
                              ? ListView.builder(
                                  itemCount: afternoonList.length,
                                  itemBuilder: (context, index) {
                                    final med = afternoonList[index];
                                    return Dismissible(
                                      key: Key(med['drug']),
                                      onDismissed: (direction) async {
                                        await deleteDataAfternoon(med['id']);
                                        Toast.show(
                                            med['drug'] + ' deleted', context,
                                            duration: Toast.LENGTH_LONG,
                                            gravity: Toast.TOP);
                                        // Alert(
                                        //     context: context,
                                        //     title: 'Are you sure to delete? ' +
                                        //         med['drug'],
                                        //     style: alertStyle,
                                        //     content: Container(),
                                        //     buttons: [
                                        //       DialogButton(
                                        //         onPressed: () async {
                                        //           Navigator.pop(context);

                                        //           setState(() {
                                        //             med.remove(index);
                                        //           });
                                        //         },
                                        //         color: Colors.white,
                                        //         border: Border.all(
                                        //             color: Colors.blueAccent),
                                        //         child: Text(
                                        //           "Yes",
                                        //           style: TextStyle(
                                        //               color: Colors.blue,
                                        //               fontSize: 16),
                                        //         ),
                                        //       ),
                                        //       DialogButton(
                                        //         onPressed: () async {
                                        //           Navigator.pop(context);
                                        //           setState(() {});
                                        //         },
                                        //         color: Colors.blue,
                                        //         child: Text(
                                        //           "No",
                                        //           style: TextStyle(
                                        //               color: Colors.white,
                                        //               fontSize: 16),
                                        //         ),
                                        //       ),
                                        //     ]).show();
                                      },
                                      background: Container(
                                        color: Colors.red,
                                        child: Icon(Icons.delete,
                                            color: Colors.white, size: 35),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                med['time']
                                                        .toString()
                                                        .substring(0, 5) +
                                                    ' PM',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    med['drug'].toString() +
                                                        ' - ' +
                                                        med['dose'].toString(),
                                                  ),
                                                ),
                                                Switch(
                                                  value: med['is_active'],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      saveDataStateAfternoon(
                                                          value, med['id']);
                                                    });
                                                  },
                                                  activeTrackColor: Colors.grey,
                                                  activeColor: Colors.blue,
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.grey,
                                              height: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                              : Center(
                                  child: Text(
                                      'You have no listed evening medication')))
                    ]),
              );
            }),
        FutureBuilder(
            future: getDataEvening(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Container(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator()));
              } else
                return Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: ExpansionTile(
                      leading: Icon(CustomIcons.moon),
                      title: Text("Evening"),
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(top: 0),
                            height: displayHeight(context) * 0.3,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 0),
                            child: (eveningList.length > 0)
                                ? ListView.builder(
                                    itemCount: eveningList.length,
                                    itemBuilder: (context, index) {
                                      final med = eveningList[index];
                                      return Dismissible(
                                        key: Key(med['drug']),
                                        onDismissed: (direction) async {
                                          await deleteDataEvening(med['id']);
                                          Toast.show(
                                              med['drug'] + ' deleted', context,
                                              duration: Toast.LENGTH_LONG,
                                              gravity: Toast.TOP);
                                          // Alert(
                                          //     context: context,
                                          //     title: 'Are you sure to delete ' +
                                          //         med['drug'] +
                                          //         '?',
                                          //     style: alertStyle,
                                          //     content: Container(),
                                          //     buttons: [
                                          //       DialogButton(
                                          //         onPressed: () async {
                                          //           Navigator.pop(context);

                                          //           setState(() {
                                          //             med.remove(index);
                                          //           });
                                          //         },
                                          //         color: Colors.white,
                                          //         border: Border.all(
                                          //             color: Colors.blueAccent),
                                          //         child: Text(
                                          //           "Yes",
                                          //           style: TextStyle(
                                          //               color: Colors.blue,
                                          //               fontSize: 16),
                                          //         ),
                                          //       ),
                                          //       DialogButton(
                                          //         onPressed: () async {
                                          //           Navigator.pop(context);
                                          //           setState(() {});
                                          //         },
                                          //         color: Colors.blue,
                                          //         child: Text(
                                          //           "No",
                                          //           style: TextStyle(
                                          //               color: Colors.white,
                                          //               fontSize: 16),
                                          //         ),
                                          //       ),
                                          //     ]).show();
                                        },
                                        background: Container(
                                          color: Colors.red,
                                          child: Icon(Icons.delete,
                                              color: Colors.white, size: 35),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  med['time']
                                                          .toString()
                                                          .substring(0, 5) +
                                                      ' PM',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      med['drug'].toString() +
                                                          ' - ' +
                                                          med['dose']
                                                              .toString(),
                                                    ),
                                                  ),
                                                  Switch(
                                                    value: med['is_active'],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        saveDataStateEvening(
                                                            value, med['id']);
                                                      });
                                                    },
                                                    activeTrackColor:
                                                        Colors.grey,
                                                    activeColor: Colors.blue,
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : Center(
                                    child: Text(
                                        'You have no listed evening medication')))
                      ]),
                );
            })
      ]),
    );
  }
}

var alertStyle = AlertStyle(
    animationType: AnimationType.fromRight,
    isCloseButton: true,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(
      fontSize: 16.0,
      fontFamily: 'Open-Sans-Regular',
      color: Colors.black,
    ),
    titleTextAlign: TextAlign.start,
    descTextAlign: TextAlign.start,
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      fontSize: 16.0,
      fontFamily: 'Open-Sans-Regular',
      color: Colors.black,
    ),
    alertAlignment: Alignment.center);
