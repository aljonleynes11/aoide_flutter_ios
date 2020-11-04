import 'dart:convert';

import 'package:Aiode/commons/BottomNavBar.dart';
import 'package:Aiode/commons/CustomIcons.dart';
import 'package:Aiode/commons/TopNavBar.dart';
import 'package:Aiode/model/WeightHistory.dart';
import 'package:Aiode/commons/BottomNavBar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Aiode/helpers/size.dart';
import 'package:Aiode/commons/MySpacer.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Aiode/services/LogServices.dart';

class LogsScreen extends StatefulWidget {
  @override
  _LogsScreenState createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TopNavBar(
      activeIndex: 4,
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
                              CustomIcons.paste,
                              size: 25,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Text(
                        "Logs",
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
                // Container(
                //   height: displayHeight(context) * 0.5,
                //   width: displayWidth(context) * 0.7,
                //   child: listBuilder2(),
                // )
                future(),
                // addButton(),
                // appointments(),
              ]))),
    ));
  }

  Widget future() {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: Center(
                  child: Container(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator())),
            );
          }
          return listBuilder2();
        });
  }

  Widget listBuilder() {
    return ListView.builder(
      itemCount: (tempList.length > 10) ? 10 : tempList.length,
      itemBuilder: (context, i) {
        return tempList[i]
            ? ListTile(
                title: Text(tempList[i]['data'].toString()),
              )
            : Container(
                height: 0,
                width: 0,
              );
      },
    );
  }

  Widget listBuilder2() {
    return Container(
        width: displayWidth(context) * 1,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i in tempList)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: displayHeight(context) * 0.1,
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(i['data']),
                    AutoSizeText(
                      i['date'],
                      style: TextStyle(color: Colors.grey, fontSize: 8),
                    ),
                  ],
                ),
                // (i['data'].contains('weight'))
                //     ? Icon(CustomIcons.weight)
                //     : Container(),
                // (i['data'].contains('blood pressure'))
                //     ? Icon(CustomIcons.stethoscope)
                //     : Container()
                // ],
                // )
              )
          ],
        ));
  }

  String textHeader = 'Here you can see your activity log in aoide';
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
              // showModalInputSheet('', '', '', '', '', 'Add Appointment');
            },
            child: Text(
              'Add Log',
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Open-Sans-Regular',
              ),
            ),
          ),
        )));
  }

  var tempList;
  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    final response = await get('https://aoide.tk/api/logs/users/$id');
    if (response.statusCode == 200) {
      var myJson = json.decode(response.body);
      // print(myJson);
      tempList = myJson['data']['logs'];
      tempList = tempList.reversed.toList();
      DateTime toDate;
      String datetoShow;
      tempList.forEach((x) => {
            toDate = new DateFormat('yyyy-MM-dd HH:mm').parse(x['date']),
            datetoShow = DateFormat("MMM dd, yyyy - hh:mm a").format(toDate),
            x['date'] = datetoShow
          });
    }
    return 'Data Fetched';
  }
}
