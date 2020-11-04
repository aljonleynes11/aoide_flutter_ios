import 'dart:convert';

import 'package:Aiode/commons/CustomCard.dart';
import 'package:Aiode/commons/CustomIcons.dart';
import 'package:Aiode/commons/MySpacer.dart';
import 'package:Aiode/commons/TopNavBarSearch.dart';
import 'package:Aiode/helpers/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Aiode/services/LogServices.dart';
import 'package:toast/toast.dart';

class SearchProfile extends StatefulWidget {
  final searchProfile;

  SearchProfile({@required this.searchProfile});

  @override
  _SearchProfileState createState() => _SearchProfileState();
}

class _SearchProfileState extends State<SearchProfile> {
  var profile;
  @override
  void initState() {
    super.initState();
    getGender();
    initialize();
    profile = getFollowed();
  }

  Widget textWidget(String holder) {
    return Text(holder,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Open-Sans-Regular',
        ));
  }

  Widget pokeEnabled() {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      child: Icon(CustomIcons.right_hand),
      onPressed: () async {
        // setState(() {
        //   isPoked = true;
        // });

        await poke();
      },
      heroTag: null,
    );
  }

  Widget pokeDisabled() {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurpleAccent,
      child: Icon(CustomIcons.right_hand),
      onPressed: () {
        // setState(() {
        //   isPoked = false;
        // });
      },
      heroTag: null,
    );
  }

  Widget widgetFollow() {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      child: Icon(Icons.person_add),
      onPressed: () async {
        setState(() {
          isFollowed = true;
        });
        await follow();
        await createLog('follow',
            'You followed ' + widget.searchProfile['username'].toString());
        Toast.show(
            'You followed ' + widget.searchProfile['username'].toString(),
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP);
      },
      heroTag: null,
    );
  }

  Widget widgetUnfollow() {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      child: Icon(Icons.person),
      onPressed: () {
        setState(() {
          isFollowed = false;
        });
        unfollow();
      },
      heroTag: null,
    );
  }

  String weight;
  String heartRate;
  String bloodSugar;
  String bloodPressure;
  bool isFollowed;
  bool isPoked = false;

  Widget build(BuildContext context) {
    initialize();
    var cardList = [
      CustomCard(
        myIcon: Icon(CustomIcons.weight, size: 50, color: Colors.white),
        bgColor: Colors.green,
        placeholder: 'Weight',
        record: weight,
      ),
      CustomCard(
        myIcon: Icon(
          CustomIcons.droplet,
          size: 50,
          color: Colors.white,
        ),
        bgColor: Colors.deepPurpleAccent,
        placeholder: 'Blood Sugar',
        record: bloodSugar,
      ),
      CustomCard(
        myIcon: Icon(
          CustomIcons.heartbeat,
          size: 50,
          color: Colors.white,
        ),
        bgColor: Colors.red[900],
        placeholder: 'Heart Rate',
        record: heartRate,
      ),
      CustomCard(
        myIcon: Icon(
          CustomIcons.stethoscope,
          size: 50,
          color: Colors.white,
        ),
        bgColor: Colors.blueAccent,
        placeholder: 'Blood Pressure',
        record: bloodPressure,
      ),
    ];

    var logsList = [
      CustomCard(
        myIcon: Icon(
          CustomIcons.pill,
          size: 50,
          color: Colors.white,
        ),
        bgColor: Colors.blueAccent,
        placeholder: 'Medication',
        record: '',
      ),
    ];

    return FutureBuilder(
        future: profile,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Scaffold(
                body: Center(
                    child:
                        Text('Please make sure you have internet connection')));

          return Scaffold(
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 200),
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  (isFollowed == false) ? widgetFollow() : widgetUnfollow(),
                  SizedBox(
                    height: 20,
                  ),
                  (isPoked == false) ? pokeEnabled() : pokeDisabled(),
                ]),
              ),
              body: TopNavBarSearch(
                screenBody: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/backgrounds/background-cutted.png"),
                        fit: BoxFit.cover),
                  ),
                  child: Container(
                    child: Column(
                      children: [
                        MySpacer(height: 0.10),
                        Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Open-Sans-Regular',
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(right: 250),
                                    child: Divider(
                                      color: Colors.white,
                                      thickness: 3,
                                    )),
                                // Text(
                                //   'Analyze and record your health below',
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontFamily: 'Open-Sans-Regular',
                                //     fontSize: 11,
                                //   ),
                                // ),
                              ],
                            )),
                        MySpacer(height: 0.05),
                        Card(
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 20),
                            width: displayWidth(context) * 0.6,
                            child: Column(
                              children: [
                                Container(
                                  width: displayWidth(context) * 0.20,
                                  height: displayHeight(context) * 0.15,
                                  child: (widget.searchProfile['profile']
                                              ['image'] !=
                                          null)
                                      ? Image.network(widget
                                          .searchProfile['profile']['image'])
                                      : Image.network(
                                          'https://aoide.tk/uploads/avatars/no-avatar.png'),
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      textWidget(widget
                                          .searchProfile['username']
                                          .toUpperCase()),
                                      textWidget(widget.searchProfile['profile']
                                                  ['age']
                                              .toString() +
                                          ' years old'),
                                      textWidget(widget.searchProfile['profile']
                                              ['gender']
                                          .toString()),
                                    ],
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Divider(
                                      color: Colors.grey,
                                      height: 2,
                                    )),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Text(widget.searchProfile['following']
                                              .toString()),
                                          Text('Following'),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(widget.searchProfile['followers']
                                              .toString()),
                                          Text('Followers'),
                                        ],
                                      ),
                                    ]),
                              ],
                            ),
                          ),
                        ),
                        MySpacer(height: 0.05),
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
                                    margin: const EdgeInsets.only(right: 250),
                                    child: Divider(
                                      color: Colors.blueAccent,
                                      thickness: 3,
                                    )),
                                // Text(
                                //   'Analyze and record your health below',
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontFamily: 'Open-Sans-Regular',
                                //     fontSize: 11,
                                //   ),
                                // ),
                              ],
                            )),
                        MySpacer(height: 0.035),
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
                              // autoplay: true,
                              viewportFraction: 0.35,
                              scale: 0.2,
                              autoplayDelay: 2500),
                        ),
                        MySpacer(height: 0.035),
                        MySpacer(height: 0.035),
                        //uncomment if logs is implemented
                        // Padding(
                        //     padding: const EdgeInsets.only(left: 25),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           'Activity Logs',
                        //           style: TextStyle(
                        //             color: Colors.black,
                        //             fontFamily: 'Open-Sans-Regular',
                        //             fontSize: 14,
                        //           ),
                        //         ),
                        //         Container(
                        //             margin: const EdgeInsets.only(right: 250),
                        //             child: Divider(
                        //               color: Colors.blueAccent,
                        //               thickness: 3,
                        //             )),
                        //         // Text(
                        //         //   'Analyze and record your health below',
                        //         //   style: TextStyle(
                        //         //     color: Colors.white,
                        //         //     fontFamily: 'Open-Sans-Regular',
                        //         //     fontSize: 11,
                        //         //   ),
                        //         // ),
                        //       ],
                        //     )),
                        // MySpacer(height: 0.015),
                        // Container(
                        //   height: displayHeight(context) * 0.18,
                        //   child: new Swiper(
                        //     itemBuilder: (BuildContext context, int index) {
                        //       return new Container(
                        //         padding: const EdgeInsets.only(left: 5, right: 5),
                        //         child: logsList[index],
                        //       );
                        //     },
                        //     itemCount: logsList.length,
                        //     viewportFraction: 0.35,
                        //     scale: 0.2,
                        //   ),
                        // ),
                        // MySpacer(height: 0.035),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  void getGender() {
    if (widget.searchProfile['profile']['gender'] == 'm') {
      widget.searchProfile['profile']['gender'] = 'Male';
    } else if (widget.searchProfile['profile']['gender'] == 'M') {
      widget.searchProfile['profile']['gender'] = 'Male';
    } else if (widget.searchProfile['profile']['gender'] == 'f') {
      widget.searchProfile['profile']['gender'] = 'Female';
    } else if (widget.searchProfile['profile']['gender'] == 'F') {
      widget.searchProfile['profile']['gender'] = 'Female';
    }
  }

  initialize() {
    if (widget.searchProfile["latest_weight"] != null) {
      weight = widget.searchProfile["latest_weight"]['weight'].toString() +
          ' ' +
          widget.searchProfile["latest_weight"]['weight_unit'].toString();
    } else {
      weight = 'No record';
    }

    if (widget.searchProfile["latest_blood_sugar"] != null) {
      bloodSugar =
          widget.searchProfile["latest_blood_sugar"]['blood_sugar'].toString() +
              ' mm/dL';
    } else {
      bloodSugar = 'No record';
    }

    if (widget.searchProfile["latest_resting_heart_rate"] != null) {
      heartRate = widget.searchProfile["latest_resting_heart_rate"]
                  ['heart_rate']
              .toString() +
          ' BPM';
    } else {
      heartRate = 'No Record';
    }

    if (widget.searchProfile["latest_blood_pressure"] != null) {
      bloodPressure = widget.searchProfile["latest_blood_pressure"]
                  ['upper_number']
              .toString() +
          '/' +
          widget.searchProfile["latest_blood_pressure"]['lower_number']
              .toString() +
          ' mm/Hg';
    } else {
      bloodPressure = 'No Record';
    }
  }

  Future<String> getFollowed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    try {
      final response2 = await post(
        'https://aoide.tk/api/follow/check/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'following_user_id': widget.searchProfile['id'].toString(),
        }),
      );
      final res = json.decode(response2.body);
      if (response2.statusCode == 200) {
        print(res);
        var tempBool = res['data'];
        if (tempBool != false) {
          isFollowed = true;
        } else {
          isFollowed = false;
        }
      }
    } catch (e) {
      print(e);
    }
    return 'data fetched';
  }

  follow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    try {
      final response2 = await post(
        'https://aoide.tk/api/follow/follow/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'following_user_id': widget.searchProfile['id'].toString(),
        }),
      );
      final res = json.decode(response2.body);
      print(res);
      if (response2.statusCode == 200) {}
    } catch (e) {
      print(e);
    }
  }

  unfollow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    try {
      final response2 = await post(
        'https://aoide.tk/api/follow/unfollow/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'following_user_id': widget.searchProfile['id'].toString(),
        }),
      );
      final res = json.decode(response2.body);
      if (response2.statusCode == 200) {
        print('successfully unfollowed');
        await createLog(
          'unfollow',
          'You unfollowed ' + widget.searchProfile['username'].toString(),
        );
        Toast.show(
            'You unfollowed ' + widget.searchProfile['username'].toString(),
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP);
      }
    } catch (e) {
      print(e);
    }
  }

  poke() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    var username = prefs.getString('username');
    var time = DateFormat('yyyy-MM-dd HH:mm a').format(DateTime.now());
    try {
      final response2 = await post(
        'https://aoide.tk/api/users/poke/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": widget.searchProfile['id'].toString(),
          "category": "VIEW PROFILE",
          "task": "$username poked you.",
          // "date": time.toString(),
        }),
      );
      final res = json.decode(response2.body);
      if (response2.statusCode == 200) {
        print(res);
        await createLog(
          'poke',
          'You poked ' + widget.searchProfile['username'].toString(),
        );
        Toast.show(
            'You poked ' + widget.searchProfile['username'].toString(), context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      } else {
        print(res);
      }
      setState(() {
        isPoked = !isPoked;
      });
    } catch (e) {
      print(e);
    }
  }
}
