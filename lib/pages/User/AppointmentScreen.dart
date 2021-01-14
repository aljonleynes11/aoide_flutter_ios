import 'dart:convert';

import 'package:Aiode/commons/BottomNavBar.dart';
import 'package:Aiode/commons/CustomIcons.dart';
import 'package:Aiode/commons/TopNavBar.dart';
import 'package:Aiode/helpers/size.dart';
import 'package:Aiode/commons/MySpacer.dart';
import 'package:Aiode/commons/BottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:Aiode/helpers/size.dart';
import 'package:Aiode/commons/MySpacer.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'dart:math';
import 'package:Aiode/services/LogServices.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

String textHeader =
    'We organize your health appointments. Make a list of your appointments in the categories below';
double percentage = 0.1;
var providerController = TextEditingController();
var categoryController = TextEditingController();
var detailsController = TextEditingController();
var timeTextFieldController = TextEditingController();
String tempDate;

class Appointment {
  int id;
  String provider;
  String details;
  String date;
  bool isChecked;
  int appointmentCategoryId;
  Appointment(this.id, this.provider, this.details, this.date, this.isChecked,
      this.appointmentCategoryId);
}

class Category {
  int id;
  String category;

  Category(this.id, this.category);
}

@override
class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  void initState() {
    super.initState();
    appointmentList1.clear();
    appointmentList2.clear();
    appointmentList3.clear();
    appointmentList4.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    appointmentList1.clear();
    appointmentList2.clear();
    appointmentList3.clear();
    appointmentList4.clear();
  }

  @override
  Widget build(BuildContext context) {
    appointmentList1.clear();
    appointmentList2.clear();
    appointmentList3.clear();
    appointmentList4.clear();
    return TopNavBar(
      activeIndex: 3,
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
                             Icons.people,
                              size: 25,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Text(
                        "Appointments",
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
                appointments(),
              ]))),
    );
  }

  void showModalInputSheet(
    String id,
    String categoryId,
    String providerTF,
    String details,
    String time,
    String buttonText,
  ) {
    if (time != '') {
      DateTime toDate = new DateFormat('MMM dd yyyy - hh:mm a').parse(time);
      String datetoShow = DateFormat("MMMM dd, yyyy - hh:mm a").format(toDate);
      timeTextFieldController.text = datetoShow;
      categoryController.text = categoryId;
      providerController.text = providerTF;
      detailsController.text = details;
    }

    var provider = 'Choose a provider';
    Alert(
        context: context,
        title: buttonText,
        style: alertStyle,
        content: Column(
          children: <Widget>[
            Container(
              child: TextFormField(
                  controller: categoryController,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Open-Sans-Regular',
                  ),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.people,
                      size: 50,
                    ),
                    labelText: 'Category',
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    categoryPicker();
                  }),
            ),
            Container(
              child: TextFormField(
                maxLength: 15,
                controller: providerController,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open-Sans-Regular',
                ),
                decoration: InputDecoration(
                  icon: Icon(
                   Icons.people,
                    size: 0,
                  ),
                  labelText: 'Provider',
                ),
              ),
            ),
            Container(
              width: displayWidth(context) * 0.7,
              child: TextFormField(
                maxLength: 100,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                controller: detailsController,
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
                  labelText: 'Details',
                ),
              ),
            ),
            Container(
              width: displayWidth(context) * 0.7,
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

                    showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 800)),
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
                        timeTextFieldController.text =
                            DateFormat('MMMM dd, yyyy').format(selectedDate);
                        timePicker();
                      }
                    });
                  }),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              Navigator.pop(context);
              appointmentList1.clear();
              appointmentList2.clear();
              appointmentList3.clear();
              appointmentList4.clear();
              if (buttonText == 'Add Appointment') {
                await saveData();
              } else if (buttonText == 'Edit Appointment') {
                await editData(int.parse(id));
              }

              setState(() {});
            },
            child: Text(
              buttonText,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ]).show();
  }

  Widget collapsible(
      List<Appointment> appointment, String expandableName, Icon icon) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: ExpansionTile(leading: icon, title: Text(expandableName),
            // initiallyExpanded: true,
            // backgroundColor: Colors.blueGrey[800],
            // subtitle: Text("  Sub Title's"),
            children: <Widget>[
              (appointment.length > 0)
                  ? Container(
                      margin: EdgeInsets.only(top: 0),
                      height: displayHeight(context) * 0.3,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      child: (appointment.length > 0)
                          ? ListView.builder(
                              itemCount: appointment.length,
                              itemBuilder: (context, index) {
                                final thisAppointment = appointment[index];
                                return Dismissible(
                                  key: Key(thisAppointment.details),
                                  onDismissed: (direction) {
                                    //edit
                                    showModalInputSheet(
                                        thisAppointment.id.toString(),
                                        thisAppointment.appointmentCategoryId
                                            .toString(),
                                        thisAppointment.provider,
                                        thisAppointment.details,
                                        thisAppointment.date,
                                        'Edit Appointment');

                                    setState(() {});
                                  },

                                  background: Container(
                                    color: Colors.green,
                                    child: Icon(Icons.edit,
                                        color: Colors.white, size: 35),
                                  ),

                                  child: GestureDetector(
                                    onTap: () {
                                      showModalInputSheet(
                                          thisAppointment.id.toString(),
                                          thisAppointment.appointmentCategoryId
                                              .toString(),
                                          thisAppointment.provider,
                                          thisAppointment.details,
                                          thisAppointment.date,
                                          'View');
                                    },
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
                                              thisAppointment.date,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Text(
                                                    thisAppointment.provider),
                                              ),
                                              Switch(
                                                value:
                                                    thisAppointment.isChecked,
                                                onChanged: (value) async {
                                                  await saveDataState(value,
                                                      thisAppointment.id);
                                                  setState(() {});
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
                                  ),
                                  // child:
                                  //     ListTile(title: Text(med['drug'].toString())),
                                );
                              })
                          : Center(
                              child: Text(
                                  'You have no listed morning medication')))
                  : Container(),
            ]));
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
              showModalInputSheet('', '', '', '', '', 'Add Appointment');
            },
            child: Text(
              'Add Appointment',
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
  var tempList;

  Future<List> getCategory() async {
    try {
      final response =
          await get('https://aoide.tk/api/appointments/categories');
      if (response.statusCode == 200) {
        var myJson = json.decode(response.body);
        tempList = myJson['data'];

        return tempList;
      }
    } catch (e) {
      print(e);
    }
    return tempList;
  }

  List<Category> categoryList = [];
  List<Appointment> appointmentList1 = [];
  List<Appointment> appointmentList2 = [];
  List<Appointment> appointmentList3 = [];
  List<Appointment> appointmentList4 = [];
  List<Appointment> appointmentList5 = [];
  List<Appointment> appointmentList6 = [];

  var tempList2;
  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    final response = await get('https://aoide.tk/api/appointments/users/$id');
    if (response.statusCode == 200) {
      var myJson = json.decode(response.body);
      tempList2 = myJson['data']['appointments'];
      // print(tempList2);
      tempList2.forEach((appointment) {
        bool isActive = false;
        bool isChecked = false;
        if (appointment['is_checked'] == 1) {
          isChecked = true;
          appointment['is_checked'] = true;
        } else {
          appointment['is_checked'] = false;
        }
        DateTime toDate =
            new DateFormat("yyyy-MM-dd hh:mm").parse(appointment['date']);
        String toString = DateFormat('MMM dd yyyy - hh:mm a').format(toDate);
        appointment['date'] = toString;

        if (appointment['appointment_category_id'] == 1) {
          appointmentList1.add(new Appointment(
              appointment['id'],
              appointment['provider'],
              appointment['details'],
              appointment['date'],
              appointment['is_checked'],
              appointment['appointment_category_id']));
        }
        if (appointment['appointment_category_id'] == 2) {
          appointmentList2.add(new Appointment(
              appointment['id'],
              appointment['provider'],
              appointment['details'],
              appointment['date'],
              appointment['is_checked'],
              appointment['appointment_category_id']));
        }
        if (appointment['appointment_category_id'] == 3) {
          appointmentList3.add(new Appointment(
              appointment['id'],
              appointment['provider'],
              appointment['details'],
              appointment['date'],
              appointment['is_checked'],
              appointment['appointment_category_id']));
        }
        if (appointment['appointment_category_id'] == 4) {
          appointmentList4.add(new Appointment(
              appointment['id'],
              appointment['provider'],
              appointment['details'],
              appointment['date'],
              appointment['is_checked'],
              appointment['appointment_category_id']));
        }
        if (appointment['appointment_category_id'] == 5) {
          appointmentList5.add(new Appointment(
              appointment['id'],
              appointment['provider'],
              appointment['details'],
              appointment['date'],
              appointment['is_checked'],
              appointment['appointment_category_id']));
        }
        if (appointment['appointment_category_id'] == 6) {
          appointmentList6.add(new Appointment(
              appointment['id'],
              appointment['provider'],
              appointment['details'],
              appointment['date'],
              appointment['is_checked'],
              appointment['appointment_category_id']));
        }
      });
      // morningList.forEach((medication) {
      //   bool isActive = false;
      //   if (medication['is_active'] == 1) {
      //     medication['is_active'] = true;
      //   } else {
      //     medication['is_active'] = false;
      //   }
      //   DateTime tempDate =
      //       new DateFormat("hh:mm:ss").parse(medication['time'].toString());
      //   medication['time'] = DateFormat("hh:mm a").format(tempDate);
      // });
      return 'Data Fetched';
    }
    return 'Data Fetched';
  }

  //    String feature;
  // int id;
  // bool isActive;
  // bool isChecked;

  saveData() async {
    var categoryId = categoryController.text.substring(0, 1);
    String date = timeTextFieldController.text;

    DateTime toDate = new DateFormat("MMMM dd, yyyy - hh:mm a").parse(date);
    String datetoSave = DateFormat('yyyy-MM-dd HH:mm').format(toDate);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    try {
      final response = await post('https://aoide.tk/api/appointments/users/$id',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'appointment_category_id': categoryId,
            'provider': providerController.text,
            'details': detailsController.text,
            'date': datetoSave,
          }));
      final res = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          categoryController.clear();
          providerController.clear();
          detailsController.clear();
          timeTextFieldController.clear();
          providerController.clear();
        });
        await createLog('added', 'Added appointment');
      }
      print(res);
    } catch (e) {
      print(e);
    }
  }

  saveDataState(bool value, int dataId) async {
    String url;
    (value == false)
        ? url = 'https://aoide.tk/api/appointments/uncheck/$dataId'
        : url = 'https://aoide.tk/api/appointments/check/$dataId';

    try {
      final response = await put(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      final res = json.decode(response.body);
      if (response.statusCode == 200) {
        await createLog('change', 'Change state of an appointment');
      }
      print(res);
    } catch (e) {
      print(e);
    }
  }

  editData(int dataId) async {
    var categoryId = categoryController.text.substring(0, 1);
    String date = timeTextFieldController.text;

    DateTime toDate = new DateFormat("MMMM dd, yyyy - hh:mm a").parse(date);
    String datetoSave = DateFormat('yyyy-MM-dd HH:mm').format(toDate);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response =
          await put('https://aoide.tk/api/appointments/update/$dataId',
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'appointment_category_id': categoryId,
                'provider': providerController.text,
                'details': detailsController.text,
                'date': datetoSave,
              }));
      final res = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          providerController.clear();
          detailsController.clear();
          timeTextFieldController.clear();
          providerController.clear();
        });
        await createLog('edited', 'Edited appointment');
      }
      print(res);
    } catch (e) {
      print(e);
    }
  }

  void categoryPicker() {
    var provider = 'Choose a provider';
    Alert(
        context: context,
        title: 'Choose a time',
        style: alertStyle,
        content: Container(
          width: displayWidth(context) * 0.6,
          child: DropdownButton(
            hint: provider == null
                ? Text(
                    '  provider',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Open-Sans-Regular',
                    ),
                  )
                : Text(
                    '  $provider',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Open-Sans-Regular',
                        color: Colors.black),
                  ),
            isExpanded: true,
            iconSize: 30.0,
            items: [
              for (var i in tempList)
                i['id'].toString() + ' - ' + i['category'].toString(),
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
                  provider = val;
                  categoryController.text = provider;
                  Navigator.pop(context);
                },
              );
              print(provider);
            },
          ),
        )).show();
  }

  void timePicker() {
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
              tempDate = DateFormat('hh:mm a').format(time);
              String getTime = DateFormat('hh:mm a').format(time);
            });
          },
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              setState(() {
                timeTextFieldController.text =
                    timeTextFieldController.text + ' - ' + tempDate.toString();
              });
              Navigator.pop(context);
            },
            child: Text(
              "Set time",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ]).show();
  }

  Widget collapsibleListContainer(
    String category1,
    String category2,
    String category3,
    String category4,
  ) {
    return Column(children: [
      collapsible(appointmentList1, category1, Icon(Icons.people)),
      collapsible(appointmentList2, category2, Icon(Icons.computer)),
      collapsible(appointmentList3, category3, Icon(Icons.image)),
      collapsible(appointmentList4, category4, Icon(Icons.help)),
      // Container(
      //     child: (appointmentList5.length > 0 && category5 != null)
      //         ? collapsible(appointmentList5, category5)
      //         : Container()),
      // Container(
      //     child: (appointmentList6.length > 0 && category6 != null)
      //         ? collapsible(appointmentList6, category6)
      //         : Container()),
    ]);
  }

  Widget appointments() {
    return Container(
      color: Colors.white,
      child: FutureBuilder(
          future: getCategory(),
          builder: (context, rawCategory) {
            if (rawCategory.hasError) {
              return Center(
                  child: Container(
                      padding: EdgeInsets.all(40),
                      child:
                          Text("Too much request, please wait and try again")));
            }
            var fetchedCategory = rawCategory.data;
            // print(fetchedCategory);
            if (rawCategory.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Container(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator()));
            }
            return Container(
              child: Column(children: [
                FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Container(
                                padding: EdgeInsets.all(40),
                                child: CircularProgressIndicator()));
                      }

                      return Column(children: [
                        collapsibleListContainer(
                          fetchedCategory[0]['category'],
                          fetchedCategory[1]['category'],
                          fetchedCategory[2]['category'],
                          fetchedCategory[3]['category'],
                        )
                      ]);
                    }),
              ]),
            );
          }),
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
