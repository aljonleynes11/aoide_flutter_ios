import 'dart:convert';

import 'package:Aiode/commons/BottomNavBar.dart';
import 'package:Aiode/commons/TopNavBar.dart';
import 'package:Aiode/model/WeightHistory.dart';
import 'package:Aiode/pages/User/BloodPressureScreen.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:Aiode/helpers/size.dart';
import 'package:Aiode/commons/MySpacer.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:Aiode/commons/CustomIcons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Aiode/commons/CustomCard.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:Aiode/services/LogServices.dart';

class WeightScreen extends StatefulWidget {
  final String url;
  final bool isKg;
  WeightScreen({Key key, @required this.url, this.isKg}) : super(key: key);
  @override
  _WeightScreenState createState() => _WeightScreenState();
}

final List<charts.Series> seriesList = [];
var weightController = TextEditingController();
var firstDate;
var lastDate;
var tempList;
var bmiFinal;
String bmiCategoryFinal;

var slideText = [
  "Weigh yourself before you have anything to drink or eat",
  "Weigh yourself ONLY before munching on the first meal of the day, however small it may be.",
  "Remember to not drink any fluids before you hop on the scale. ",
  "The empty stomach number on the scale is what your true weight is.",
];

LineChart lineChart = LineChart.fromDateTimeMaps([up], [Colors.green], ['Kg'],
    tapTextFontWeight: FontWeight.bold);

Map<DateTime, double> up = {};
bool openTable = false;
var heightUnit = 'cm';
var weightUnit = 'lb';
void getUnit(unit, String bodyMeasurement) {
  if (bodyMeasurement == "weight") {
    if (unit == 0) {
      weightUnit = 'lb';
    } else {
      weightUnit = 'kg';
    }
  } else if (bodyMeasurement == 'height') {
    if (unit == 0) {
      heightUnit = 'cm';
    } else {
      heightUnit = 'in';
    }
  }
}

class WeightSeries {
  DateTime date;
  double value;
  String unit;
  int id;
  WeightSeries(this.date, this.value, this.unit, this.id);
}

List<WeightSeries> data = [];
var series = [
  new charts.Series<WeightSeries, DateTime>(
    id: 'Weight',
    colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
    domainFn: (WeightSeries data, _) => data.date,
    measureFn: (WeightSeries data, _) => data.value,
    data: data,
  )
];

var chart = new charts.TimeSeriesChart(series,
    animate: true,
    animationDuration: Duration(seconds: 1),
    defaultRenderer:
        new charts.LineRendererConfig(includePoints: true, includeArea: true),
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
      new charts.ChartTitle('Weight',
          behaviorPosition: charts.BehaviorPosition.start,
          titleOutsideJustification:
              charts.OutsideJustification.middleDrawArea),
    ]);

var chartWidget = Container(
  child: chart,
);

class _WeightScreenState extends State<WeightScreen> {
  @override
  void initState() {
    super.initState();
    data.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    data.clear();
    weightController.clear();
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
                            "assets/images/backgrounds/background-bluegreen-cutted.png"),
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
                                    icon: Icon(CustomIcons.weight,
                                        size: 25, color: Colors.white),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                              Text(
                                "Weight",
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
                                      Container(),
                                      MySpacer(height: 0.002),
                                      Row(children: [
                                        Container(
                                            margin: EdgeInsets.only(left: 17),
                                            width: displayWidth(context) * 0.1,
                                            child: (data.length > 0)
                                                ? tableButton()
                                                : Container()),
                                        Container(
                                          width: displayWidth(context) * 0.41,
                                          color: Colors.black,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          width: displayWidth(context) * 0.2,
                                          child: (data.length > 0)
                                              ? Container(
                                                  child: (widget.isKg == true)
                                                      ? toPoundsButton()
                                                      : toKgButton(),
                                                )
                                              : Container(),
                                        )
                                      ]),
                                      Center(
                                        child: Container(
                                          width: displayWidth(context) * 0.78,
                                          child: MaterialButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                              color: Colors.deepPurpleAccent,
                                              textColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 70, vertical: 6),
                                              onPressed: () async {
                                                print('add data');
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                var categories = prefs
                                                    .getString('categories');
                                                print(categories);
                                                var jsonDecoded =
                                                    jsonDecode(categories);
                                                // print(jsonDecoded);
                                                print(
                                                    jsonDecoded['Added Data']);
                                                showModalInputSheet();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.add),
                                                  Text(
                                                    'Add Data',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily:
                                                          'Open-Sans-Regular',
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
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
                                          : Container(),
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
                                          pagination(
                                              prevPage.toString(), false);
                                        },
                                        child: Text(
                                          'Prev',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: 'Open-Sans-Regular',
                                          ),
                                        ),
                                      )
                                    : Container(),
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
                                            pagination(
                                                nextPage.toString(), false);
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
                                    : Container(),
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

  Widget tableButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      color: Colors.green,
      textColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      onPressed: () async {
        // print('going table');
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // var id = prefs.getInt('id');
        // pagination(
        //     'https://aoide.tk/api/users/list/weight-history/$id?page=$currentPage',
        //     true);
        showModalTableSheet();
      },
      //
      child: Icon(Icons.tab),
    );
  }

  Widget toPoundsButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      color: Colors.deepOrangeAccent,

      textColor: Colors.white,
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var getId = prefs.getInt('id');
        chartWidget = Container(child: chart);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WeightScreen(
                url:
                    'https://aoide.tk/api/users/list/weight-history/$getId?page=$currentPage',
                isKg: false,
              ),
            ));
      },

      //
      child: Row(children: [
        Icon(Icons.refresh),
        Container(
          child: Text(
            'Lb',
            style: TextStyle(
              fontSize: 12.0,
              fontFamily: 'Open-Sans-Regular',
            ),
          ),
        )
      ]),
    );
  }

  Widget toKgButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      color: Colors.deepOrangeAccent,

      textColor: Colors.white,

      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var getId = prefs.getInt('id');
        chartWidget = Container(child: chart);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WeightScreen(
                url:
                    'https://aoide.tk/api/users/list/weight-history/$getId?page=$currentPage',
                isKg: true,
              ),
            ));
      },

      //
      child: Row(children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Icon(Icons.refresh),
        ),
        Container(
          child: Text(
            'Kg',
            style: TextStyle(
              fontSize: 12.0,
              fontFamily: 'Open-Sans-Regular',
            ),
          ),
        )
      ]),
    );
  }

  Widget chartButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      color: Colors.green,

      textColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      onPressed: () async {
        print('going chart');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var id = prefs.getInt('id');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WeightScreen(
                url:
                    'https://aoide.tk/api/users/list/weight-history/$id?page=$currentPage',
              ),
            ));
      },

      //
      child: Icon(Icons.show_chart),
    );
  }

  void pagination(String url, bool isTable) async {
    chartWidget = Container(child: chart);
    if (widget.isKg == true) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WeightScreen(url: url.toString(), isKg: true),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WeightScreen(
              url: url.toString(),
            ),
          ));
    }
  }

  Widget sort() {
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: displayWidth(context) * 0.35,
          child: Card(
            color: Colors.blueAccent,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white24,
                        child: IconButton(
                          icon: Icon(
                            const IconData(58840, fontFamily: 'MaterialIcons'),
                            color: Colors.white,
                            size: 12,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Data",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Open-Sans-Regular',
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Highest",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontFamily: 'Open-Sans-Regular',
                                    color: Colors.white,
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
            width: displayWidth(context) * 0.35,
            child: Card(
              color: Colors.red[300],
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white24,
                        child: IconButton(
                          icon: Icon(
                            const IconData(58843, fontFamily: 'MaterialIcons'),
                            color: Colors.white,
                            size: 12,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Data",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Open-Sans-Regular',
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Lowest",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontFamily: 'Open-Sans-Regular',
                                    color: Colors.white,
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
    );
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
                'Weight',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open-Sans-Regular',
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              )),
              TableCell(
                child: Text(
                  'Weight Unit',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Open-Sans-Regular',
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
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
                'Action',
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
                          i.value.toString(),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Open-Sans-Regular',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ))),
                TableCell(
                  child: Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        i.unit.toString(),
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Open-Sans-Regular',
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      )),
                ),
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
                                content: Container(),
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
                CustomIcons.weight,
                size: 50,
                color: Colors.green,
              ),
              MySpacer(height: 0.02),
              table(),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            color: Colors.green,
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          )
        ]).show();
  }

  void showModalInputSheet() {
    Alert(
        context: context,
        title: 'Add Weight',
        style: alertStyle,
        content: Column(
          children: <Widget>[
            Container(
              width: displayWidth(context) * 0.49,
              child: TextFormField(
                maxLength: 5,
                controller: weightController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open-Sans-Regular',
                ),
                decoration: InputDecoration(
                  icon: Icon(
                    CustomIcons.weight,
                    size: 50,
                  ),
                  labelText: 'Weight',
                ),
              ),
            ),
            MySpacer(height: 0.02),
            ToggleSwitch(
              minWidth: displayWidth(context) * 0.25,
              minHeight: 30.0,
              cornerRadius: 30,
              activeBgColor: Colors.blue,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              labels: ['lb', 'kg'],
              onToggle: (index2) {
                print('switched to: $index2');
                getUnit(index2, "weight");
              },
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              // await getBMI();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String prefsHeight = prefs.getString('heightInches');
              double finalHeight = double.parse(prefsHeight);
              double finalWeight = double.parse(weightController.text);
              print(finalWeight);
              print(finalHeight.toString());
              if (weightUnit == 'kg') {
                //convert to lb
                finalWeight = finalWeight * 2.2046;
                // now in lb
              }
              bmiFinal = finalWeight / finalHeight / finalHeight * 703;
              bmiFinal = bmiFinal.toStringAsFixed(2);

              bmiFinal = double.parse(bmiFinal);

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
              print(bmiCategoryFinal);
              Navigator.pop(context);

              await saveData();
              setState(() {
                var a = 'asdf';
                data.clear();
              });
            },
            child: Text(
              "Add Data",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ]).show();
  }

  Map<DateTime, double> chartFinal = {};
  var tempData = [];

  var nextPage;
  var prevPage;
  var currentPage;

  WeightHistory weight = WeightHistory();
  Future<WeightHistory> getData(String url) async {
    try {
      final response = await get(url);

      if (response.statusCode == 200) {
        var myJson = json.decode(response.body);
        // print(myJson);
        tempList = myJson['data'];
        nextPage = myJson['links']['next'];
        prevPage = myJson['links']['prev'];
        currentPage = myJson['meta']['current_page'];
        print(myJson);
        //   print(currentPage);
        await new Future.delayed(const Duration(milliseconds: 3), () {
          // tempList.forEach((var x) =>
          //     chartFinal[convertDateFromString(x['created_at'])] =
          //         double.parse(x['weight'].toString()));
          // tempList = tempList.reversed;
          tempList.forEach((x) => (x['weight_unit'] == 'kg')
              ? x['weight'] = x['weight'] * 2.20462
              : print('lb'));

          tempList.forEach((x) => x['weight_unit'] = 'lb');

          tempList.forEach((x) => data.add(new WeightSeries(
              DateTime.parse(x['created_at']),
              double.parse(x['weight'].toStringAsFixed(2)),
              x['weight_unit'],
              x['id'])));

          if (widget.isKg == true) {
            data.clear();
            tempList.forEach((x) => x['weight'] = x['weight'] / 2.20462);
            tempList.forEach((x) => x['weight_unit'] = 'kg');
            tempList.forEach((x) => data.add(new WeightSeries(
                DateTime.parse(x['created_at']),
                double.parse(x['weight'].toStringAsFixed(2)),
                x['weight_unit'],
                x['id'])));
          }
          firstDate = tempList.first['created_at'];
          firstDate =
              DateFormat('MMM dd yyyy').format(DateTime.parse(firstDate));

          lastDate = tempList.last['created_at'];
          lastDate = DateFormat('MMM dd yyyy').format(DateTime.parse(lastDate));

          print(firstDate);
          print(lastDate);
          weight = WeightHistory.fromJson(myJson);

          up = chartFinal;
        });
      }
      return weight;
    } catch (e) {
      print(e);
    }
    return weight;
  }

  Future saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    print(id.toString());
    var getDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    print(getDate);

    try {
      final response = await post(
        'https://aoide.tk/api/users/weight-history/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'weight': weightController.text,
          'weight_unit': weightUnit.toString(),
          // 'bmi': bmiFinal.toString(),
          // 'bmi_category': bmiCategoryFinal.toString(),
          // 'created_at': get,
          // 'date': get,
          'bmi': bmiFinal.toString(),
          'bmi_category': bmiCategoryFinal.toString(),
        }),
      );
      final res = json.decode(response.body);
      if (response.statusCode == 200) {
        print(res);
        var weight = weightController.text;

        await createLog('added', 'Added $weight$weightUnit weight');

        setState(() {
          weightController.clear();
        });
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
          'https://aoide.tk/api/users/weight-history/$deleteId',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      final res = json.decode(response.body);
      if (response.statusCode == 200) {
        print(res);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var getId = prefs.getInt('id');
        await createLog('deleted', 'Deleted weight');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WeightScreen(
                  url:
                      'https://aoide.tk/api/users/list/weight-history/$getId?page=$currentPage',
                  isKg: widget.isKg),
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
