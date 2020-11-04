import 'dart:convert';

import 'package:Aiode/helpers/size.dart';
import 'package:Aiode/pages/Auth/Register/AvatarScreen.dart';
import 'package:Aiode/pages/Search/SearchResult.dart';
import 'package:Aiode/pages/User/BloodPressureScreen.dart';
import 'package:Aiode/pages/User/BloodSugarScreen.dart';
import 'package:Aiode/pages/User/HeartRateScreen.dart';
import 'package:Aiode/pages/User/WeightScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'BottomNavBar.dart';
import 'MySpacer.dart';

class TopNavBar extends StatefulWidget {
  final Widget screenBody;
  final Widget iconButton;
  final int activeIndex;
  TopNavBar({this.screenBody, this.iconButton, this.activeIndex});

  @override
  _TopNavBarState createState() => _TopNavBarState();
}

var searchController = TextEditingController();
var _notifications;

class _TopNavBarState extends State<TopNavBar> {
  @override
  void initState() {
    super.initState();
    _notifications = getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.popAndPushNamed(context, '/home');
        },
        child: FutureBuilder(
            future: _notifications,
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return Scaffold(
              //       body: Center(
              //           child: Text('Please make sure you have internet etc')));
              // }
              if (snapshot.hasError) {
                return Scaffold(
                    body: Center(
                        child: Text(
                            'Please make sure you have internet connection')));
              } else {
                return Scaffold(
                  appBar: (AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: searchField(),
                    actions: [
                      // new Stack(
                      //   children: <Widget>[
                      //     new IconButton(
                      //         icon: Icon(Icons.notifications),
                      //         onPressed: () {
                      //           showModalBottomSheet(
                      //               context: context,
                      //               builder: (builder) {
                      //                 return Container(
                      //                     height: displayHeight(context) * 1,
                      //                     width: displayWidth(context) * 0.8,
                      //                     color: Colors.white,
                      //                     child: Container(
                      //                         child: Center(
                      //                       child: Text(
                      //                           'Notifications to be implemented'),
                      //                     )));
                      //               });
                      //           // setState(() {

                      //           // });
                      //         }),
                      //     notificationList != null
                      //         ? new Positioned(
                      //             right: 11,
                      //             top: 11,
                      //             child: new Container(
                      //               padding: EdgeInsets.all(2),
                      //               decoration: new BoxDecoration(
                      //                 color: Colors.red,
                      //                 borderRadius: BorderRadius.circular(6),
                      //               ),
                      //               constraints: BoxConstraints(
                      //                 minWidth: 14,
                      //                 minHeight: 14,
                      //               ),
                      //               child: Text(
                      //                 ' ',
                      //                 style: TextStyle(
                      //                   color: Colors.white,
                      //                   fontSize: 8,
                      //                 ),
                      //                 textAlign: TextAlign.center,
                      //               ),
                      //             ),
                      //           )
                      //         : new Container()
                      //   ],
                      // ),
                    ],
                    leading:
                        (widget.iconButton != null) ? widget.iconButton : null,
                  )),
                  resizeToAvoidBottomInset: false,
                  extendBodyBehindAppBar: true,
                  bottomNavigationBar: BottomNavBar(
                    activeIndex: widget.activeIndex,
                  ),
                  body: widget.screenBody,
                  drawer: Drawer(
                      // Add a ListView to the drawer. This ensures the user can scroll
                      // through the options in the drawer if there isn't enough vertical
                      // space to fit everything.
                      child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/backgrounds/background.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        // DrawerHeader(
                        //   child: Text('Drawer Header'),
                        //   decoration: BoxDecoration(
                        //       color: Colors.blue,
                        //       // gradient: LinearGradient(
                        //       //     begin: Alignment.topRight,
                        //       //     end: Alignment.bottomLeft,
                        //       //     colors: [Colors.white60, Colors.blue]
                        //       //     ),
                        //       image: DecorationImage(
                        //           image: AssetImage(
                        //               "assets/images/backgrounds/background-cutted.png"),
                        //           fit: BoxFit.cover)),
                        // ),
                        MySpacer(height: 0.09),
                        ListTile(
                          title: Text('Weight',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 16,
                              )),
                          onTap: () async {
                            Navigator.pop(context);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var getId = prefs.getInt('id');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WeightScreen(
                                    url:
                                        'https://aoide.tk/api/users/list/weight-history/$getId',
                                  ),
                                ));
                          },
                        ),
                        ListTile(
                          title: Text('Blood Pressure',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 16,
                              )),
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var getId = prefs.getInt('id');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BloodPressureScreen(
                                    url:
                                        'https://aoide.tk/api/users/list/blood-pressure-history/$getId',
                                  ),
                                ));
                          },
                        ),
                        ListTile(
                          title: Text('Blood Sugar',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 16,
                              )),
                          onTap: () async {
                            Navigator.pop(context);

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var getId = prefs.getInt('id');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BloodSugarScreen(
                                    url:
                                        'https://aoide.tk/api/users/paginate/blood-sugar-history/$getId',
                                  ),
                                ));
                          },
                        ),
                        ListTile(
                          title: Text('Heart Rate',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 16,
                              )),
                          onTap: () async {
                            Navigator.pop(context);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var getId = prefs.getInt('id');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HeartRateScreen(
                                    url:
                                        'https://www.aoide.tk/api/users/paginate/resting-heart-rate/$getId',
                                  ),
                                ));
                          },
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 15, right: 15, top: 15, bottom: 15),
                            child: Divider(
                              color: Colors.white,
                              height: 1,
                            )),
                        ListTile(
                          title: Text('Checklist',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 16,
                              )),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(context, '/checklist');
                          },
                        ),
                        ListTile(
                          title: Text('Medications',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 16,
                              )),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(context, '/medication');
                          },
                        ),
                        ListTile(
                          title: Text('Appointments',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 16,
                              )),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(context, '/appointment');
                          },
                        ),
                        ListTile(
                          title: Text('Logs',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 16,
                              )),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(context, '/logs');
                          },
                        ),
                        MySpacer(height: 0.03),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 15, right: 15, top: 15, bottom: 15),
                            child: Divider(
                              color: Colors.white,
                              height: 1,
                            )),
                        ListTile(
                          title: Text('Change Avatar',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Open-Sans-Regular',
                                fontSize: 16,
                              )),
                          onTap: () async {
                            Navigator.pop(context);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var gender = prefs.getString('gender');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AvatarScreen(
                                    gender: gender,
                                  ),
                                ));
                          },
                        ),
                        ListTile(
                          title: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Open-Sans-Regular',
                              fontSize: 16,
                            ),
                          ),
                          onTap: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.clear();
                            Navigator.popAndPushNamed(
                                context, '/landingScreen');

                            // Update the state of the app
                            // ...
                            // Then close the drawer
                          },
                        ),
                      ],
                    ),
                  )),
                );
              }
            }));
  }

  List notificationList = [];
  Future<List> getNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = prefs.getInt('id');
      final response =
          await get('https://aoide.tk/api/notifications/users/$id');
      if (response.statusCode == 200) {
        var myJson = json.decode(response.body);
        notificationList = myJson['notifications'];

        return notificationList;
      }
    } catch (e) {
      print(e);
    }
    return notificationList;
  }

  search() async {
    List searched;
    try {
      final response = await post(
        'https://aoide.tk/api/users/search',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'search': searchController.text,
        }),
      );
      if (response.statusCode == 200) {
        var myJson = json.decode(response.body);
        searched = myJson['data'];
        print(searched);
        print(searched.length);
        if (searched.length > 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchResult(
                  searchList: searched,
                ),
              ));
          searchController.clear();
        } else {
          Toast.show(searchController.text + ' user not found', context,
              duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
          searchController.clear();
        }
        return searched;
      }
    } catch (e) {
      print(e);
    }
    return searched;
  }

  Widget searchField() {
    return Center(
      child: Container(
        height: 35,
        width: displayWidth(context) * 0.8,
        child: TextFormField(
          controller: searchController,
          style: TextStyle(
            fontSize: 15.0,
            fontFamily: 'Open-Sans-Regular',
            color: Colors.white,
          ),
          textAlign: TextAlign.justify,
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
              const Radius.circular(20.0),
            )),
            fillColor: Colors.white10,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (searchController.text.length <= 1) {
                    Toast.show('Search failed, please insert username', context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                  } else {
                    await search();
                  }
                }),
            enabledBorder: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(20.0),
              ),
              borderSide: BorderSide(color: Colors.transparent, width: 1.0),
            ),
            focusedBorder: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(20.0),
              ),
              borderSide: BorderSide(color: Colors.transparent, width: 1.0),
            ),
            hintText: 'Search',
            hintStyle: TextStyle(
                fontSize: 15,
                color: Colors.white70,
                fontFamily: 'Open-Sans-Regular'),
          ),
          onTap: () {
            setState(() {});
          },
        ),
      ),
    );
  }
}
