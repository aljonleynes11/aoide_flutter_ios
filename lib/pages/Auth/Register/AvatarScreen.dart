import 'dart:convert';

import 'package:Aiode/commons/CustomIcons.dart';
import 'package:Aiode/commons/MySpacer.dart';
import 'package:Aiode/helpers/size.dart';
import 'package:Aiode/services/LogServices.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AvatarScreen extends StatefulWidget {
  final String gender;

  AvatarScreen({this.gender});
  @override
  _AvatarScreenState createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: ConvexButton.fab(
          icon: Icons.check,
          color: Colors.white,
          backgroundColor: Colors.blue,
          onTap: () {
            editImage();
          },
        ),
        body: Container(
            height: displayHeight(context) * 1,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/backgrounds/background.jpg"),
                  fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  MySpacer(height: 0.07),
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
                                Icons.person,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        Text(
                          "Avatar",
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
                  MySpacer(height: 0.05),
                  header(),
                  MySpacer(height: 0.03),
                  avatarPicker(),
                ]))));
  }

  String textHeader = 'Choose your avatar!';
  String imageUrl;
  Widget header() {
    return Center(
      child: Card(
        color: Colors.transparent,
        child: Container(
          width: displayWidth(context) * 1,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: AutoSizeText(
            '$textHeader',
            style:
                TextStyle(fontFamily: 'Open-Sans-Regular', color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  var imageListMale = [
    Container(
        child: Image.network('https://aoide.tk/uploads/avatars/avatar1.png')),
    Container(
        child: Image.network('https://aoide.tk/uploads/avatars/avatar2.png')),
    Container(
        child: Image.network('https://aoide.tk/uploads/avatars/avatar3.png')),
    Container(
        child: Image.network('https://aoide.tk/uploads/avatars/avatar4.png')),
    Container(
        child: Image.network('https://aoide.tk/uploads/avatars/avatar5.png')),
  ];

  var imageListInStringMale = [
    'https://aoide.tk/uploads/avatars/avatar1.png',
    'https://aoide.tk/uploads/avatars/avatar2.png',
    'https://aoide.tk/uploads/avatars/avatar3.png',
    'https://aoide.tk/uploads/avatars/avatar4.png',
    'https://aoide.tk/uploads/avatars/avatar5.png',
  ];

  var imageListFemale = [
    Container(
        child: Image.network('https://aoide.tk/uploads/avatars/avatar6.png')),
    Container(
        child: Image.network('https://aoide.tk/uploads/avatars/avatar7.png')),
    Container(
        child: Image.network('https://aoide.tk/uploads/avatars/avatar8.png')),
    Container(
        child: Image.network('https://aoide.tk/uploads/avatars/avatar9.png')),
    Container(
        child: Image.network('https://aoide.tk/uploads/avatars/avatar10.png')),
  ];

  var imageListInStringFemale = [
    'https://aoide.tk/uploads/avatars/avatar6.png',
    'https://aoide.tk/uploads/avatars/avatar7.png',
    'https://aoide.tk/uploads/avatars/avatar8.png',
    'https://aoide.tk/uploads/avatars/avatar9.png',
    'https://aoide.tk/uploads/avatars/avatar10.png',
  ];

  Widget avatarPicker() {
    return Container(
      height: displayHeight(context) * 0.5,
      child: new Swiper(
          itemBuilder: (BuildContext context, int index) {
            return new Container(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: (widget.gender == 'M' || widget.gender == 'm')
                    ? imageListMale[index]
                    : imageListFemale[index]);
          },
          itemCount: (widget.gender == 'M' || widget.gender == 'm')
              ? imageListMale.length
              : imageListFemale.length,
          autoplay: false,
          viewportFraction: 0.35,
          scale: 0,
          onIndexChanged: (index) {
            if (widget.gender == 'M' || widget.gender == 'm') {
              imageUrl = imageListInStringMale[index];
              print(imageListInStringMale[index]);
            } else {
              imageUrl = imageListInStringFemale[index];
              print(imageListInStringFemale[index]);
            }
          }),
    );
  }

  editImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    final response =
        await put('https://www.aoide.tk/api/users/general-infos/$id',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{'image': imageUrl}));
    final res = json.decode(response.body);
    if (response.statusCode == 200) {
      await createLog('change', 'You changed your avatar');
      Toast.show('You changed your avatar', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      Navigator.pushNamedAndRemoveUntil(
          context, "/home", (Route<dynamic> route) => false);
    }
  }
}
