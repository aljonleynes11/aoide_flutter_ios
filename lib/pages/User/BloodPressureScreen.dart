import 'dart:convert';

import 'package:Aiode/commons/TopNavBar.dart';
import 'package:Aiode/model/WeightHistory.dart';
import 'package:flutter/material.dart';
import 'package:Aiode/helpers/size.dart';
import 'package:Aiode/commons/MySpacer.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:Aiode/commons/CustomIcons.dart';
import 'package:Aiode/commons/BottomNavBar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'dart:math';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:Aiode/commons/CustomCard.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:Aiode/services/LogServices.dart';

class BloodPressureScreen extends StatefulWidget {
  final String url;
  BloodPressureScreen({Key key, @required this.url}) : super(key: key);

  @override
  _BloodPressureScreenState createState() => _BloodPressureScreenState();
}

var firstDate;
var lastDate;
var nextPage;
var prevPage;
var currentPage;
var systolicController = TextEditingController();
var diastolicController = TextEditingController();

var slideText = [
  "Don't measure your Blood Pressure right after you wake up!",
  "Want to make sure? Wait 1 min and retake your BP.",
  "Make sure your arm is positioned properly.",
  "Measure your Blood Pressure twice daily.",
];

LineChart lineChart = LineChart.fromDateTimeMaps(
    [up, down], [Colors.red, Colors.blue], ['mm/Hg', 'mm/Hg'],
    tapTextFontWeight: FontWeight.bold);
Map<DateTime, double> up = {};
Map<DateTime, double> down = {};
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

class BloodPressureSeries {
  DateTime date;
  double valueSystolic;
  double valueDiastolic;
  String bloodPressure;
  int id;
  BloodPressureSeries(this.date, this.valueSystolic, this.valueDiastolic,
      this.bloodPressure, this.id);
}

var series = [
  new charts.Series<BloodPressureSeries, DateTime>(
    id: 'BloodPressureSystolic',
    colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
    domainFn: (BloodPressureSeries data, _) => data.date,
    measureFn: (BloodPressureSeries data, _) => data.valueSystolic,
    data: data,
  ),
  new charts.Series<BloodPressureSeries, DateTime>(
    id: 'BloodPressureDiastolic',
    colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
    domainFn: (BloodPressureSeries data, _) => data.date,
    measureFn: (BloodPressureSeries data, _) => data.valueDiastolic,
    data: data,
  ),
];

var chart = new charts.TimeSeriesChart(series,
    animate: true,
    animationDuration: Duration(seconds: 2),
    defaultRenderer: new charts.LineRendererConfig(
        includePoints: true, includeArea: true, stacked: true),
    dateTimeFactory: const charts.LocalDateTimeFactory(),
    domainAxis: charts.DateTimeAxisSpec(
      tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
        day: charts.TimeFormatterSpec(
          format: 'dd',
          transitionFormat: 'dd MMM',
        ),
      ),
    ),
    behaviors: [
      new charts.ChartTitle('Blood Pressure',
          behaviorPosition: charts.BehaviorPosition.start,
          titleOutsideJustification:
              charts.OutsideJustification.middleDrawArea),
    ]);

var chartWidget = new Container(
  child: new SizedBox(
    child: chart,
  ),
);

List<BloodPressureSeries> data = [];

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  @override
  void initState() {
    super.initState();
    data.clear();
  }

  @override
  void dispose() {
    super.dispose();
    data.clear();
  }

  @override
  Widget build(BuildContext context) {
    data.clear();
    return FutureBuilder(
        future: getData(widget.url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                body: Center(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/misc/logo.png',
                  height: displayHeight(context) * 0.1,
                ),
                Image.asset(
                  'assets/images/misc/profile-loading.gif',
                  height: displayHeight(context) * 0.2,
                ),
              ],
            )));
          } else {
            if (snapshot.hasError)
              return Scaffold(
                  body: Center(
                      child: Text(
                          'Please make sure you have internet connection')));
            else if (snapshot.hasData)
              return TopNavBar(
                iconButton: new IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/home');
                    }),
                screenBody: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/backgrounds/background-violet-cutted.png"),
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
                                      CustomIcons.stethoscope,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                              Text(
                                "Blood Pressure",
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
                        MySpacer(height: 0.01),
                        Center(
                          child: Container(
                            width: displayWidth(context) * 0.9,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 12, 10, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Message",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: 'Open-Sans-Regular',
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Container(
                                        width: displayWidth(context) * 0.8,
                                        height: displayHeight(context) * 0.05,
                                        child: new Swiper(
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return new Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: AutoSizeText(
                                                  slideText[index],
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Open-Sans-Regular',
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount: slideText.length,
                                            autoplay: true,
                                            viewportFraction: 1,
                                            scale: 0.5,
                                            autoplayDelay: 6000),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Divider(
                                            color: Colors.grey,
                                            height: 1,
                                          )),
                                      MySpacer(height: 0.01),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              width:
                                                  displayWidth(context) * 0.35,
                                              child: Card(
                                                color: Colors.blueAccent,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 15,
                                                            backgroundColor:
                                                                Colors.white24,
                                                            child: IconButton(
                                                              icon: Icon(
                                                                const IconData(
                                                                    58840,
                                                                    fontFamily:
                                                                        'MaterialIcons'),
                                                                color: Colors
                                                                    .white,
                                                                size: 12,
                                                              ),
                                                              onPressed: () {},
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 5,
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8),
                                                                    child: Text(
                                                                      highest,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontFamily:
                                                                            'Open-Sans-Regular',
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                    child: Text(
                                                                      "Highest",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            10.0,
                                                                        fontFamily:
                                                                            'Open-Sans-Regular',
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                print('Lowest');
                                              },
                                              child: Container(
                                                width: displayWidth(context) *
                                                    0.35,
                                                child: Card(
                                                  color: Colors.red[300],
                                                  child: Column(children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 15,
                                                            backgroundColor:
                                                                Colors.white24,
                                                            child: IconButton(
                                                              icon: Icon(
                                                                const IconData(
                                                                    58843,
                                                                    fontFamily:
                                                                        'MaterialIcons'),
                                                                color: Colors
                                                                    .white,
                                                                size: 12,
                                                              ),
                                                              onPressed: () {},
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 5,
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                    child: Text(
                                                                      lowest,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontFamily:
                                                                            'Open-Sans-Regular',
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                    child: Text(
                                                                      "Lowest",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            10.0,
                                                                        fontFamily:
                                                                            'Open-Sans-Regular',
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      MySpacer(height: 0.002),
                                      (data.length > 1)
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                (tempList.length > 1)
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            left: 15),
                                                        width: displayWidth(
                                                                context) *
                                                            0.1,
                                                        child: MaterialButton(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6.0),
                                                          ),
                                                          color: Colors.green,
                                                          textColor:
                                                              Colors.white,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 1,
                                                                  vertical: 1),
                                                          onPressed: () async {
                                                            showModalTableSheet();
                                                          },
                                                          child:
                                                              Icon(Icons.tab),
                                                        ),
                                                      )
                                                    : Container(),
                                                Center(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 30),
                                                    width:
                                                        displayWidth(context) *
                                                            0.585,
                                                    child: MaterialButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.0),
                                                      ),
                                                      color: Colors
                                                          .deepPurpleAccent,
                                                      textColor: Colors.white,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 70,
                                                              vertical: 6),
                                                      onPressed: () async {
                                                        print('add data');
                                                        showModalInputSheet();
                                                      },
                                                      child: Text(
                                                        'Add Data',
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily:
                                                              'Open-Sans-Regular',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Center(
                                              child: Container(
                                                width: displayWidth(context) *
                                                    0.78,
                                                child: MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                  ),
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                  textColor: Colors.white,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 70,
                                                      vertical: 6),
                                                  onPressed: () async {
                                                    print('add data');
                                                    showModalInputSheet();
                                                  },
                                                  child: Text(
                                                    'Add Data',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily:
                                                          'Open-Sans-Regular',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      MySpacer(height: 0.002),
                                      //put chart here
                                      Container(
                                          height: displayHeight(context) * 0.3,
                                          child: (data.length > 0)
                                              ? chartWidget
                                              : Column(
                                                  children: [
                                                    MySpacer(height: 0.02),
                                                    Container(child: table()),
                                                  ],
                                                )),
                                      (data.length > 1)
                                          ? Center(
                                              child: Text(
                                                  '$lastDate - $firstDate'))
                                          : Container(width: 0.0, height: 0.0),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        MySpacer(height: 0.02),
                        Container(
                            width: displayWidth(context) * 0.94,
                            height: displayHeight(context) * 0.035,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                (prevPage != null)
                                    ? MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        color: Colors.deepPurpleAccent,
                                        textColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1, vertical: 1),
                                        onPressed: () async {
                                          pagination(prevPage.toString());
                                        },
                                        child: Text(
                                          'Prev',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: 'Open-Sans-Regular',
                                          ),
                                        ),
                                      )
                                    : Container(width: 0.0, height: 0.0),
                                (nextPage != null)
                                    ? Container(
                                        margin: const EdgeInsets.only(left: 15),
                                        child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          color: Colors.deepPurpleAccent,
                                          textColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1, vertical: 1),
                                          onPressed: () async {
                                            pagination(nextPage.toString());
                                          },
                                          child: Text(
                                            'Next',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: 'Open-Sans-Regular',
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(width: 0.0, height: 0.0),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              );
          }
        });
  }

  void pagination(String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BloodPressureScreen(
            url: url.toString(),
          ),
        ));
  }

  void showModalInputSheet() {
    Alert(
        context: context,
        title: 'Add Blood Pressure',
        style: alertStyle,
        content: Column(
          children: <Widget>[
            Container(
              width: displayWidth(context) * 0.49,
              child: TextFormField(
                maxLength: 5,
                controller: systolicController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open-Sans-Regular',
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.arrow_upward,
                    size: 30,
                  ),
                  labelText: 'Upper Number ( Systolic )',
                ),
              ),
            ),
            Container(
              width: displayWidth(context) * 0.49,
              child: TextField(
                controller: diastolicController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open-Sans-Regular',
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.arrow_downward,
                    size: 30,
                  ),
                  labelText: 'Lower Number ( Diastolic )',
                ),
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              Navigator.pop(context);
              data.clear();
              await saveData();
              setState(() {
                var a = 'asdf';
              });
            },
            child: Text(
              "Add Data",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ]).show();
  }

  Widget table() {
    if (data.length > 0) {
      return Table(
          border: TableBorder.all(
              color: Colors.black26, width: 1, style: BorderStyle.solid),
          children: [
            TableRow(children: [
              TableCell(
                  child: Text(
                'Blood Pressure',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open-Sans-Regular',
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              )),
              TableCell(
                  child: Text(
                'Date',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open-Sans-Regular',
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              )),
              TableCell(
                  child: Text(
                'Actions',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open-Sans-Regular',
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              )),
            ]),
            for (var i in data)
              TableRow(children: [
                TableCell(
                    child: Container(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          i.bloodPressure.toString(),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Open-Sans-Regular',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ))),
                TableCell(
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                        child: Text(
                          DateFormat('MMM dd yyyy')
                              .format(DateTime.parse(i.date.toString())),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Open-Sans-Regular',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ))),
                TableCell(
                    child: Container(
                        padding: EdgeInsets.all(2),
                        child: IconButton(
                          icon: Icon(Icons.delete_outline),
                          color: Colors.red[900],
                          onPressed: () async {
                            Alert(
                                context: context,
                                title: 'Are you sure to delete?',
                                style: alertStyle,
                                content: Container(width: 0.0, height: 0.0),
                                buttons: [
                                  DialogButton(
                                    onPressed: () async {
                                      await deleteData(i.id.toString());
                                    },
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.blueAccent),
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 16),
                                    ),
                                  ),
                                  DialogButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    color: Colors.blue,
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ]).show();
                          },
                        ))),
              ])
          ]);
    } else {
      return Container();
    }
  }

  void showModalTableSheet() {
    Alert(
      context: context,
      title: 'Weight',
      style: alertStyle,
      content: Container(
        width: displayWidth(context) * 1,
        child: Column(
          children: [
            Icon(
              CustomIcons.stethoscope,
              size: 50,
              color: Colors.blueAccent,
            ),
            MySpacer(height: 0.02),
            table(),
          ],
        ),
      ),
      // buttons: [
      //   DialogButton(
      //     onPressed: () async {
      //       await saveData();
      //       Navigator.pop(context);
      //     },
      //     child: Text(
      //       "Add Data",
      //       style: TextStyle(color: Colors.white, fontSize: 16),
      //     ),
      //   )
      // ]
    ).show();
  }

  void _showModalSheet() {
    var cardList = [
      CustomCard(
        myIcon: Icon(CustomIcons.weight, size: 50, color: Colors.white),
        bgColor: Colors.deepOrangeAccent,
        placeholder: 'Weight',
        record: ' ',
        onPressed: () {
          Navigator.pushNamed(context, '/userWeight');
          print('weight');
        },
      ),
      CustomCard(
        myIcon: Icon(
          CustomIcons.droplet,
          size: 50,
          color: Colors.white,
        ),
        bgColor: Colors.deepPurpleAccent,
        placeholder: 'Blood Sugar',
        record: ' ',
        onPressed: () {
          print('BloodPressure');
          Navigator.pushNamed(context, '/userBloodPressure');
        },
      ),
      CustomCard(
        myIcon: Icon(
          CustomIcons.heartbeat,
          size: 50,
          color: Colors.white,
        ),
        bgColor: Colors.redAccent,
        placeholder: 'Heart Rate',
        record: ' ',
        onPressed: () {
          print('heartrate');
          Navigator.pushNamed(context, '/userHeartRate');
        },
      ),
      CustomCard(
        myIcon: Icon(
          CustomIcons.stethoscope,
          size: 50,
          color: Colors.white,
        ),
        bgColor: Colors.blueAccent,
        placeholder: 'Blood Pressure',
        record: ' ',
        onPressed: () {
          print('bloodpressure');
          Navigator.pushNamed(context, '/userBloodPressure');
        },
      ),
    ];
  }

  Map<DateTime, double> chartFinalSystolic = {};
  Map<DateTime, double> chartFinalDiastolic = {};
  var list = [];
  var tempList;

  Future<String> getData(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    try {
      final response = await get(url);

      if (response.statusCode == 200) {
        var myJson = json.decode(response.body);
        print(myJson);
        tempList = myJson['data'];
        nextPage = myJson['links']['next'];
        prevPage = myJson['links']['prev'];
        currentPage = myJson['meta']['current_page'];
        await new Future.delayed(const Duration(milliseconds: 3), () {
          tempList.forEach((var x) => data.add(new BloodPressureSeries(
              DateTime.parse(x['created_at']),
              double.parse(x['upper_number'].toString()),
              double.parse(x['lower_number'].toString()),
              x['blood_pressure'].toString(),
              x['id'])));

          firstDate = tempList.first['created_at'];
          firstDate =
              DateFormat('MMM dd yyyy').format(DateTime.parse(firstDate));

          lastDate = tempList.last['created_at'];
          lastDate = DateFormat('MMM dd yyyy').format(DateTime.parse(lastDate));
          //   print(chartFinalSystolic);

          down = chartFinalDiastolic;

          // weights = new List<WeightHistory>.from(
          //     myJson.map((x) => WeightHistory.fromJson(x)));
        });
        await getDetails();
        up = chartFinalSystolic;
      }
      return 'data fetch';
    } catch (e) {
      print(e);
    }
    return 'data fetch';
  }

  var highest = 'Data';
  var lowest = 'Data';
  getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    try {
      final response = await get(
          'https://www.aoide.tk/api/users/blood-pressure-history/$id');

      if (response.statusCode == 200) {
        var myJson = json.decode(response.body);
        highest =
            myJson['data']['highest_upper_number']['blood_pressure'].toString();
        lowest =
            myJson['data']['lowest_upper_number']['blood_pressure'].toString();
        if (highest == null || lowest == null) {
          highest = 'No Data';
          lowest = 'No Data';
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    print(id.toString());

    try {
      final response = await post(
        'https://aoide.tk/api/users/blood-pressure-history/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'upper_number': systolicController.text,
          'lower_number': diastolicController.text,
          // 'created_at': get,
          // 'date': get,
        }),
      );
      final res = json.decode(response.body);
      if (response.statusCode == 200) {
        var bloodPressure =
            systolicController.text + '/' + diastolicController.text;

        await createLog('added', 'Added $bloodPressure blood sugar');
        setState(() {
          systolicController.clear();
          diastolicController.clear();
        });
        print(res);
      } else {
        print(res);
      }
    } catch (Exception) {
      print(Exception);
    }
  }

  deleteData(String deleteId) async {
    try {
      final response = await delete(
          'https://aoide.tk/api/users/blood-pressure-history/$deleteId',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      final res = json.decode(response.body);
      if (response.statusCode == 200) {
        print(res);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var getId = prefs.getInt('id');
        await createLog('deleted', 'Deleted blood pressure');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BloodPressureScreen(
                url:
                    'https://aoide.tk/api/users/list/blood-pressure-history/$getId?page=$currentPage',
              ),
            ));
        await new Future.delayed(const Duration(seconds: 2), () {
          showModalTableSheet();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(
        fontSize: 16.0,
        fontFamily: 'Open-Sans-Regular',
        color: Colors.black,
      ),
      titleTextAlign: TextAlign.start,
      descTextAlign: TextAlign.start,
      animationDuration: Duration(milliseconds: 200),
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
}
