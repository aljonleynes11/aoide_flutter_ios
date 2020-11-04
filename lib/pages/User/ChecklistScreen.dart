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
import 'package:Aiode/services/LogServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChecklistScreen extends StatefulWidget {
  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

List<Checklist> list1 = [];
List<Checklist> list2 = [];
List<Checklist> list3 = [];
List<Checklist> list4 = [];
List<Checklist> list5 = [];

class Checklist {
  String feature;
  int id;
  bool isActive;
  bool isChecked;
  Checklist(this.feature, this.id, this.isActive, this.isChecked);
}

String textHeader =
    'These recommendations are meant to be discussed with your health provider. Talk to your health provider about other age-appropriate screening and preventive interventions based on your risk factors and medical conditions.';
double percentage = 0.1;

@override
class _ChecklistScreenState extends State<ChecklistScreen> {
  @override
  Widget build(BuildContext context) {
    list1.clear();
    list2.clear();
    list3.clear();
    list4.clear();
    list5.clear();
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Scaffold(
          //       body: Center(
          //           child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Image.asset(
          //         'assets/images/misc/logo.png',
          //         height: displayHeight(context) * 0.1,
          //       ),
          //       Image.asset(
          //         'assets/images/misc/profile-loading.gif',
          //         height: displayHeight(context) * 0.2,
          //       ),
          //     ],
          //   )));
          // } else {
          //   if (snapshot.hasError)
          //     return Scaffold(
          //         body: Center(
          //             child: Text(
          //                 'Please make sure you have internet connection')));
          //   else if (snapshot.hasData)
          return TopNavBar(
            activeIndex: 0,
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
                                    CustomIcons.checklist,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            Text(
                              "Health Checklist",
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
                      collapsible(),
                    ]))),
          );
          // }
        });
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

  var tempList;

  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    final response =
        await get('https://aoide.tk/api/health-checklist/users/$id');
    if (response.statusCode == 200) {
      var myJson = json.decode(response.body);
      // print(myJson);
      tempList = myJson['data']['checklist'];
      tempList.forEach((x) {
        bool isActive = false;
        bool isChecked = false;
        if (x['is_active'] == 1) {
          isActive = true;
          // print(x['feature'] + ' = $isActive is active');
        }
        if (x['is_checked'] == 1) {
          isChecked = true;
          // print(x['feature'] + ' = $isChecked is check');
        }

        if (x['checklist_category_id'] == 1) {
          list1.add(new Checklist(x['feature'], x['id'], isActive, isChecked));
        }
        if (x['checklist_category_id'] == 2) {
          list2.add(new Checklist(x['feature'], x['id'], isActive, isChecked));
        }
        if (x['checklist_category_id'] == 3) {
          list3.add(new Checklist(x['feature'], x['id'], isActive, isChecked));
        }
        if (x['checklist_category_id'] == 4) {
          list4.add(new Checklist(x['feature'], x['id'], isActive, isChecked));
        }
        if (x['checklist_category_id'] == 5) {
          list5.add(new Checklist(x['feature'], x['id'], isActive, isChecked));
        }
      });
    }
    return 'Data Fetched';
    //    String feature;
    // int id;
    // bool isActive;
    // bool isChecked;
  }

  saveData(bool value, int dataId, String checklistName) async {
    String url;
    (value == false)
        ? url = 'https://aoide.tk/api/health-checklist/uncheck/$dataId'
        : url = 'https://aoide.tk/api/health-checklist/check/$dataId';

    try {
      final response = await put(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      final res = json.decode(response.body);
      if (response.statusCode == 200) {
        await createLog('change', 'Changed state of a checklist');
      }
      // print(res);
    } catch (e) {
      print(e);
    }
  }

  Widget collapsible() {
    return Column(children: [
      Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: ExpansionTile(
          initiallyExpanded: true, leading: Icon(Icons.computer),
          title: Text("Lab Screening"),
          // backgroundColor: Colors.blueGrey[800],
          // subtitle: Text("  Sub Title's"),
          children: <Widget>[
            if (list1.length > 0)
              for (var i in list1)
                CheckboxListTile(
                  title: Text(i.feature.toString()),
                  value: i.isChecked,
                  onChanged: (newValue) async {
                    setState(() {
                      saveData(newValue, i.id, i.feature.toString());
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.trailing, //  <-- leading Checkbox
                )
            else
              Center(child: Text('Congratulations you are not at risk.'))
          ],
        ),
      ),
      Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: Icon(CustomIcons.virus_slash),
          title: Text("Cancer Screening"),

          // subtitle: Text("  Sub Title's"),
          children: <Widget>[
            if (list2.length > 0)
              for (var i in list2)
                CheckboxListTile(
                  title: Text(i.feature.toString()),
                  value: i.isChecked,
                  onChanged: (newValue) async {
                    setState(() {
                      saveData(newValue, i.id, i.feature.toString());
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.trailing, //  <-- leading Checkbox
                )
            else
              Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                      child: Text('Congratulations you are not at risk.')))
          ],
        ),
      ),
      Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: ExpansionTile(
          initiallyExpanded: true, leading: Icon(CustomIcons.glass_heart),
          title: Text("Cardiovascular Health"),

          // subtitle: Text("  Sub Title's"),
          children: <Widget>[
            if (list3.length > 0)
              for (var i in list3)
                CheckboxListTile(
                  title: Text(i.feature.toString()),
                  value: i.isChecked,
                  onChanged: (newValue) async {
                    setState(() {
                      saveData(newValue, i.id, i.feature.toString());
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.trailing, //  <-- leading Checkbox
                )
            else
              Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                      child: Text('Congratulations you are not at risk.')))
          ],
        ),
      ),
      Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: ExpansionTile(
          initiallyExpanded: true, leading: Icon(CustomIcons.health),
          title: Text("Immunization"),

          // subtitle: Text("  Sub Title's"),
          children: <Widget>[
            if (list4.length > 0)
              for (var i in list4)
                CheckboxListTile(
                  title: Text(i.feature.toString()),
                  value: i.isChecked,
                  onChanged: (newValue) async {
                    setState(() {
                      saveData(newValue, i.id, i.feature.toString());
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.trailing, //  <-- leading Checkbox
                )
            else
              Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                      child: Text('Congratulations you are not at risk.')))
          ],
        ),
      ),
      Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: ExpansionTile(
          initiallyExpanded: true, leading: Icon(Icons.help),
          title: Text("Other Recommendations"),

          // subtitle: Text("  Sub Title's"),
          children: <Widget>[
            if (list5.length > 0)
              for (var i in list5)
                CheckboxListTile(
                  title: Text(i.feature.toString()),
                  value: i.isChecked,
                  onChanged: (newValue) async {
                    setState(() {
                      saveData(newValue, i.id, i.feature.toString());
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.trailing, //  <-- leading Checkbox
                )
            else
              Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                      child: Text('Congratulations you are not at risk.')))
          ],
        ),
      )
    ]);
  }
}
