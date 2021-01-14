import 'dart:math';

import 'package:Aiode/commons/TopNavBar.dart';
import 'package:flutter/material.dart';
import 'package:Aiode/helpers/size.dart';
import 'package:Aiode/commons/MySpacer.dart';
import 'package:Aiode/commons/CustomCard.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:Aiode/commons/CustomIcons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:Aiode/services/LogServices.dart';
import 'package:Aiode/model/Dashboard.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/User.dart';
import 'Notification/NotificationScreen.dart';
import 'User/BloodPressureScreen.dart';
import 'User/BloodSugarScreen.dart';
import 'User/HeartRateScreen.dart';
import 'User/WeightScreen.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var id;
  var age;
  var height;
  var heightUnit;
  var gender;
  var username;
  var followers;
  var following;
  var latestBloodPressure;
  var latestWeight;
  var latestBloodSugar;
  var latestRestingHeartRate;
  var latestBloodPressureUnit;
  var latestWeightUnit;
  var latestBloodSugarUnit;
  var latestRestingHeartRateUnit;
  var data;
  //
  // List<UserGeneralInfo> user = List<UserGeneralInfo>();
  // UserGeneralInfo user1 = UserGeneralInfo();

  // Future<UserGeneralInfo> setup1() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   id = prefs.getInt('id');
  //   final response =
  //       await get('https://www.aoide.tk/api/users/general-infos/$id');
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     print(data);
  //     user1 = UserGeneralInfo.fromJson(data);
  //   }
  //   return user1;
  // }

  setPreferences(int id, String heightInches) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    {
      await prefs.setInt('id', id);
      await prefs.setString('heightInches', heightInches);
      await prefs.setString('username', username);
    }
  }

  Dashboard user = Dashboard();
  var profile;
  var user2;
  Future<Dashboard> setup() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      id = prefs.getInt('id');
      final response = await get('https://aoide.tk/api/dashboard/user/$id');
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        User _user = userFromJson(response.body);
        print(data);

        await new Future.delayed(const Duration(milliseconds: 3), () async {
          setState(() {
            age = data['data']['profile']['age'].toString();
            gender = data['data']['profile']['gender'].toString();

            height = data['data']['profile']['height'].toString();
            heightUnit = data['data']['profile']['height_unit'].toString();
            username = data['data']['username'].toString();
            followers = data['data']['followers'].toString();
            following = data['data']['following'].toString();
            if (data['data']['latest_weight'] != null) {
              latestWeight =
                  data['data']['latest_weight']['weight'].toString() ?? '';
              latestWeightUnit =
                  data['data']['latest_weight']['weight_unit'].toString() ?? '';
            }
            if (data['data']['latest_blood_pressure'] != null) {
              latestBloodPressure = data['data']['latest_blood_pressure']
                          ['blood_pressure']
                      .toString() ??
                  '';
            }
            if (data['data']['latest_blood_sugar'] != null) {
              latestBloodSugar = data['data']['latest_blood_sugar']
                          ['blood_sugar']
                      .toString() ??
                  '';
            }
            if (data['data']['latest_resting_heart_rate'] != null) {
              latestRestingHeartRate = data['data']['latest_resting_heart_rate']
                          ['heart_rate']
                      .toString() ??
                  '';
            }
            user = Dashboard.fromJson(data);
            profile = Profile.fromJson(data);
          }); // set state
        });

        switch (gender) {
          case "M":
            gender = 'Male';
            break;
          case "F":
            gender = 'Female';
            break;
          case "m":
            gender = 'Male';
            break;
          case "f":
            gender = 'Female';
            break;
        }
        //print(data);
      }
      return user;
    } catch (e) {
      print(e);
    }
  }

  var today = DateFormat('MMMM dd, yyyy').format(DateTime.now());
  var cardColors = [
    Colors.blue,
    Colors.redAccent,
    Colors.greenAccent,
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  } //slideShow card

  FlutterLocalNotificationsPlugin fltrNotification;
  String _selectedParam;
  String task;
  int val;
  @override
  void initState() {
    super.initState();
    setup();
    user2= setup();
    getCategories();
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
        new InitializationSettings(androidInitilize, iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: null);
      _showNotification();  
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification Clicked $payload"),
      ),
    );
  }

  Future _showNotification() async {
    print('shownotif');
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Aoide", "Aoide Notification",
        importance: Importance.Max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iSODetails);

    // await fltrNotification.show(
    //     0, "Title", "Notification body", generalNotificationDetails, payload: "Notification");
  
  }

  @override
  Widget build(BuildContext context) {
    _toNotification() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationScreen(),
          ));
    }

    var cardList = [
      CustomCard(
        myIcon: Icon(CustomIcons.weight,
            size: displayHeight(context) * 0.07, color: Colors.white),
        bgColor: Colors.green,
        placeholder: 'Weight',
        record: (latestWeight != null)
            ? '$latestWeight $latestWeightUnit'
            : 'No Record',
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var getId = prefs.getInt('id');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WeightScreen(
                  url: 'https://aoide.tk/api/users/list/weight-history/$getId',
                  isKg: true,
                ),
              ));
          print('weight');
        },
      ),
      CustomCard(
        myIcon: Icon(
          CustomIcons.droplet,
          size: displayHeight(context) * 0.07,
          color: Colors.white,
        ),
        bgColor: Colors.deepPurpleAccent,
        placeholder: 'Blood Sugar',
        record: (latestBloodSugar != null)
            ? '$latestBloodSugar mg/dL'
            : 'No Record',
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var getId = prefs.getInt('id');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BloodSugarScreen(
                  url:
                      'https://aoide.tk/api/users/paginate/blood-sugar-history/$getId',
                ),
              ));
          print('bloodsugar');
        },
      ),
      CustomCard(
        myIcon: Icon(
          CustomIcons.heartbeat,
          size: displayHeight(context) * 0.07,
          color: Colors.white,
        ),
        bgColor: Colors.red[900],
        placeholder: 'Heart Rate',
        record: (latestRestingHeartRate != null)
            ? '$latestRestingHeartRate BPM'
            : 'No Record',
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var getId = prefs.getInt('id');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HeartRateScreen(
                  url:
                      'https://www.aoide.tk/api/users/paginate/resting-heart-rate/$getId',
                ),
              ));
          print('heartrate');
        },
      ),
      CustomCard(
        myIcon: Icon(
          CustomIcons.stethoscope,
          size: displayHeight(context) * 0.07,
          color: Colors.white,
        ),
        bgColor: Colors.blueAccent,
        placeholder: 'Blood Pressure',
        record: (latestBloodPressure != null)
            ? '$latestBloodPressure mm / Hg'
            : 'No Record',
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var getId = prefs.getInt('id');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BloodPressureScreen(
                  url:
                      'https://aoide.tk/api/users/list/blood-pressure-history/$getId',
                ),
              ));
          print('bloodpressure');
        },
      ),
    ];
    return FutureBuilder(
        future: user2,
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
                screenBody: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/backgrounds/background-cutted-home.png"),
                        fit: BoxFit.cover),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MySpacer(height: 0.11),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        (username != null)
                                            ? "Hello, $username"
                                            : "Hello,",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: 'Open-Sans-Regular',
                                          letterSpacing: 2.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.notifications,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        onPressed: () => _toNotification(),
                                      )
                                    ],
                                  )),
                              Container(
                                  child: Text(
                                "Have a nice day!",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Open-Sans-Regular',
                                    color: Colors.white,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.bold),
                              )),
                              MySpacer(height: 0.010),
                              Container(
                                  child: Text(
                                "$today",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Open-Sans-Regular',
                                  color: Colors.white,
                                ),
                              )),
                            ],
                          ),
                        ),
                        MySpacer(height: 0.01),
                        Center(
                          child: Container(
                            width: displayWidth(context) * 0.9,
                            height: displayHeight(context) * 0.2,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 10,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Profile",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontFamily: 'Open-Sans-Regular',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Divider(
                                        color: Colors.grey,
                                        height: 1,
                                      )),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 1, right: 1),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          1, 10, 1, 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 1, right: 1),
                                            child: Icon(
                                              Icons.favorite,
                                              size: 30,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Column(
                                              children: [
                                                Container(
                                                    child: Text(
                                                  (age != null) ? age : ' ',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontFamily:
                                                        'Open-Sans-Regular',
                                                    color: Colors.black,
                                                  ),
                                                )),
                                                Text(
                                                  "Age",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 10.0,
                                                    fontFamily:
                                                        'Open-Sans-Regular',
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 1),
                                            child: Icon(
                                              Icons.supervised_user_circle,
                                              size: 30,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Column(
                                              children: [
                                                Container(
                                                    child: Text(
                                                  (gender != null)
                                                      ? gender.toString()
                                                      : ' ',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontFamily:
                                                        'Open-Sans-Regular',
                                                    color: Colors.black,
                                                  ),
                                                )),
                                                Text(
                                                  "Gender",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 10.0,
                                                    fontFamily:
                                                        'Open-Sans-Regular',
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Icon(
                                              Icons.show_chart,
                                              size: 30,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Column(
                                              children: [
                                                Container(
                                                    child: Text(
                                                  (height != null)
                                                      ? '$height $heightUnit'
                                                      : ' ',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontFamily:
                                                        'Open-Sans-Regular',
                                                    color: Colors.black,
                                                  ),
                                                )),
                                                Text(
                                                  "Height",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 10.0,
                                                    fontFamily:
                                                        'Open-Sans-Regular',
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 25, right: 25, top: 5),
                                      child: Divider(
                                        color: Colors.grey,
                                        height: 1,
                                      )),
                                  Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                (followers != null)
                                                    ? followers
                                                    : ' ',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontFamily:
                                                      'Open-Sans-Regular',
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "Followers",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                  fontFamily:
                                                      'Open-Sans-Regular',
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                child: Text(
                                                  (following != null)
                                                      ? following
                                                      : '0',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontFamily:
                                                        'Open-Sans-Regular',
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Following",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                  fontFamily:
                                                      'Open-Sans-Regular',
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        MySpacer(height: 0.007),
                        Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Most Recent Health Data',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Open-Sans-Regular',
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(right: 330),
                                    child: Divider(
                                      color: Colors.blue,
                                      thickness: 3,
                                    )),
                                Text(
                                  'Analyze and record your health below',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Open-Sans-Regular',
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            )),
                        MySpacer(height: 0.01),
                        // Container(
                        //     child: CarouselSlider(
                        //   options: CarouselOptions(
                        //     height: displayHeight(context) * 0.18,
                        //     autoPlay: true,
                        //     initialPage: 3,
                        //     autoPlayInterval: Duration(seconds: 3),
                        //     autoPlayAnimationDuration: Duration(milliseconds: 600),
                        //   ),
                        //   items: cardList.map((card) {
                        //     return Builder(
                        //       builder: (BuildContext context) {
                        //         return Container(
                        //             width: displayWidth(context) * 1, child: card);
                        //       },
                        //     );
                        //   }).toList(),
                        // )),
                        Container(
                          height: displayHeight(context) * 0.18,
                          child: new Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return new Container(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: cardList[index],
                                );
                              },
                              itemCount: cardList.length,
                              autoplay: true,
                              viewportFraction: 0.35,
                              scale: 0.2,
                              autoplayDelay: 2500),
                        ),
                        MySpacer(height: 0.03),
                        Container(
                          width: displayWidth(context) * 1,
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: displayHeight(context) * 0.13,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/FollowingList');
                                  },
                                  child: Card(
                                      elevation: 2,
                                      color: Colors.white,
                                      child: Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.person_pin_circle,
                                                    size: 35,
                                                    color: Colors.blue,
                                                  ),
                                                  Icon(
                                                    Icons.list,
                                                    size: 35,
                                                    color: Colors.blue,
                                                  ),
                                                ],
                                              ),
                                              AutoSizeText(
                                                'View Followers',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily:
                                                      'Open-Sans-Regular',
                                                  fontSize: 9,
                                                ),
                                              ),
                                            ],
                                          ))),
                                ),
                              ),
                              Container(
                                height: displayHeight(context) * 0.13,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/FollowingList');
                                  },
                                  child: Card(
                                      elevation: 2,
                                      color: Colors.white,
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 15, 10, 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Transform(
                                                      alignment:
                                                          Alignment.center,
                                                      transform:
                                                          Matrix4.rotationY(
                                                              math.pi),
                                                      child: Icon(
                                                        Icons.list,
                                                        size: 35,
                                                        color: Colors.redAccent,
                                                      )),
                                                  Icon(
                                                    Icons.person_pin_circle,
                                                    size: 35,
                                                    color: Colors.redAccent,
                                                  ),
                                                ],
                                              ),
                                              AutoSizeText(
                                                'View Following',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily:
                                                      'Open-Sans-Regular',
                                                  fontSize: 9,
                                                ),
                                              ),
                                            ],
                                          ))),
                                ),
                              ),
                              // Container(
                              //   height: displayHeight(context) * 0.13,
                              //   child: InkWell(
                              //     onTap: () {
                              //       Navigator.popAndPushNamed(
                              //           context, '/appointment');
                              //     },
                              //     child: Card(
                              //         elevation: 2,
                              //         color: Colors.white,
                              //         child: Padding(
                              //             padding: const EdgeInsets.fromLTRB(
                              //                 10, 15, 10, 10),
                              //             child: Column(
                              //               children: [
                              //                 Icon(
                              //                   Icons.people,
                              //                   size: 35,
                              //                   color: Colors.deepPurpleAccent,
                              //                 ),
                              //                 Text(
                              //                   'Appointment',
                              //                   textAlign: TextAlign.center,
                              //                   style: TextStyle(
                              //                     color: Colors.grey,
                              //                     fontFamily:
                              //                         'Open-Sans-Regular',
                              //                     fontSize: 9,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ))),
                              //   ),
                              // ),
                              // Container(
                              //   height: displayHeight(context) * 0.13,
                              //   child: InkWell(
                              //     onTap: () async {
                              //       SharedPreferences prefs =
                              //           await SharedPreferences.getInstance();
                              //       var categories =
                              //           prefs.getString('categories');
                              //       print(categories);
                              //       var jsonDecoded = jsonDecode(categories);
                              //       // print(jsonDecoded);
                              //       print(jsonDecoded['Added Data']);
                              //       print(jsonDecoded['Edited Data']);
                              //       print(jsonDecoded['Deleted Data']);
                              //       print(jsonDecoded['Change State']);
                              //       print(jsonDecoded['Poked']);
                              //       print(jsonDecoded['Followed']);
                              //       print(jsonDecoded['Unfollowed']);
                              //       Navigator.popAndPushNamed(context, '/logs');
                              //       print('logs');
                              //     },
                              //     child: Card(
                              //         elevation: 2,
                              //         color: Colors.white,
                              //         child: Padding(
                              //             padding: const EdgeInsets.all(15),
                              //             child: Column(
                              //               children: [
                              //                 Icon(
                              //                   CustomIcons.paste,
                              //                   size: 35,
                              //                   color: Colors.redAccent,
                              //                 ),
                              //                 Text(
                              //                   'Logs',
                              //                   textAlign: TextAlign.center,
                              //                   style: TextStyle(
                              //                     color: Colors.grey,
                              //                     fontFamily:
                              //                         'Open-Sans-Regular',
                              //                     fontSize: 9,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ))),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                      //checklist, medications, appointments, logs
                    ),
                  ),
                ),

                // appBar: (AppBar(
                //   backgroundColor: Colors.transparent,
                //   elevation: 0,
                // )),
              );
          }
        });
  }
}
