import 'dart:convert';
import 'dart:math';
import 'package:Aiode/commons/TopNavBar.dart';
import 'package:Aiode/helpers/size.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart';

import '../Search/SearchProfile.dart';

var json =
    '{"id": 1,"name": "username1","imageurl": "https://aoide.tk/uploads/avatars/avatar1.png"},{"id": 2,"name": "username2","imageurl": "https://aoide.tk/uploads/avatars/avatar2.png"}';

class FollowingListScreen extends StatefulWidget {
  @override
  _FollowingListScreenState createState() => _FollowingListScreenState();
}

class _FollowingListScreenState extends State<FollowingListScreen> {
  @override
  Widget build(BuildContext context) {
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
                    "assets/images/backgrounds/background-cutted.png"),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: ListView.builder(
                itemCount: random(1, 5),
                itemBuilder: (context, index) {
                  var result;
                  return Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: displayHeight(context) * 0.2,
                    // child: new ExpansionTile(
                    //     backgroundColor: Colors.white,
                    //     title: new Text(
                    //       result[index]['username'],
                    //     ))
                    child: GestureDetector(
                      onTap: () async {
                        print(result);
                        await _toSearchProfile(
                            // int.parse(result['id'].toString())
                            167);
                      },
                      child: Row(children: [
                        Container(
                            width: displayWidth(context) * 0.20,
                            height: displayHeight(context) * 0.30,
                            child:
                                // renderImage(result['general_infos']['image'])),
                                Image.network(
                                    'https://aoide.tk/uploads/avatars/no-avatar.png')),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Sample name",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Open-Sans-Regular',
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                '99' + ' years old',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Open-Sans-Regular',
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                // result['general_infos']['race'].toString(),
                                'Asian',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Open-Sans-Regular',
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Row(
                                children: [
                                  Text(''),
                                  Text(''),
                                ],
                              )
                            ],
                          ),
                        ),
                      ]),
                    ),
                  );
                },
              ),
            ),
          )),
    );
  }

  var searched;
  _toSearchProfile(int dataId) async {
    try {
      final response1 = await get('https://aoide.tk/api/dashboard/user/167');
      if (response1.statusCode == 200) {
        var myJson = jsonDecode(response1.body);
        searched = myJson['data'];
        if (searched.length > 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchProfile(
                  searchProfile: searched,
                ),
              ));
          searchController.clear();
        }
        return searched;
      }
    } catch (e) {
      print(e);
    }
    return searched;
  }
}

random(min, max) {
  var rn = new Random();
  return min + rn.nextInt(max - min);
}

var avatarList = [
  'https://aoide.tk/uploads/avatars/avatar1.png',
  'https://aoide.tk/uploads/avatars/avatar2.png',
  'https://aoide.tk/uploads/avatars/avatar3.png',
  'https://aoide.tk/uploads/avatars/avatar4.png',
  'https://aoide.tk/uploads/avatars/avatar5.png',
  'https://aoide.tk/uploads/avatars/avatar6.png',
  'https://aoide.tk/uploads/avatars/avatar7.png',
  'https://aoide.tk/uploads/avatars/avatar8.png',
  'https://aoide.tk/uploads/avatars/avatar9.png',
  'https://aoide.tk/uploads/avatars/avatar10.png',
];

Widget renderImage(String image) {
  bool isHosted = false;

  for (var avatar in avatarList) {
    if (image == avatar) {
      isHosted = true;
    }
  }

  if (isHosted == true) {
    return Image.network(image);
  } else {
    return Image.network('https://aoide.tk/uploads/avatars/no-avatar.png');
  }
}
