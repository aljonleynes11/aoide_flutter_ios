import 'dart:convert';

import 'package:Aiode/commons/TopNavBar.dart';
import 'package:Aiode/helpers/size.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SearchProfile.dart';

class SearchResult extends StatefulWidget {
  final List searchList;

  SearchResult({@required this.searchList});
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  void initState() {
    super.initState();
  }

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
                itemCount: widget.searchList.length,
                itemBuilder: (context, index) {
                  var result = widget.searchList[index];
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
                        await getDashboardDetails(
                            int.parse(result['id'].toString()));
                      },
                      child: Row(children: [
                        Container(
                            width: displayWidth(context) * 0.20,
                            height: displayHeight(context) * 0.30,
                            child:
                                renderImage(result['general_infos']['image'])),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                result['username'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Open-Sans-Regular',
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                result['general_infos']['age'].toString() +
                                    ' years old',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Open-Sans-Regular',
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                result['general_infos']['race'].toString(),
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
  bool checkFollowed = false;
  getDashboardDetails(int dataId) async {
    try {
      final response1 =
          await get('https://aoide.tk/api/dashboard/user/$dataId');
      if (response1.statusCode == 200) {
        var myJson = json.decode(response1.body);
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
}
