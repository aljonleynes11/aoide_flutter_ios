import 'package:Aiode/pages/User/BloodPressureScreen.dart';
import 'package:Aiode/pages/User/BloodSugarScreen.dart';
import 'package:Aiode/pages/User/HeartRateScreen.dart';
import 'package:Aiode/pages/User/WeightScreen.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:Aiode/commons/CustomIcons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:Aiode/commons/CustomCard.dart';
import 'package:Aiode/helpers/size.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBar extends StatefulWidget {
  final int activeIndex;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
  BottomNavBar({Key key, this.activeIndex}) : super(key: key);
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    void _showModalSheet() {
      var cardList = [
        CustomCard(
          myIcon: Icon(
            Icons.home,
            size: 60,
            color: Colors.white,
          ),
          bgColor: Colors.blueGrey,
          placeholder: 'Home',
          record: '',
          onPressed: () async {
            Navigator.popAndPushNamed(context, '/home');
            print('home');
          },
        ),
        CustomCard(
          myIcon: Icon(
            CustomIcons.stethoscope,
            size: 60,
            color: Colors.white,
          ),
          bgColor: Colors.blueAccent,
          placeholder: 'Blood Pressure',
          record: '',
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
        CustomCard(
          myIcon: Icon(CustomIcons.weight, size: 50, color: Colors.white),
          bgColor: Colors.green,
          placeholder: 'Weight',
          record: '',
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var getId = prefs.getInt('id');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeightScreen(
                    url:
                        'https://aoide.tk/api/users/list/weight-history/$getId',
                  ),
                ));
            print('weight');
          },
        ),
        CustomCard(
          myIcon: Icon(
            CustomIcons.droplet,
            size: 60,
            color: Colors.white,
          ),
          bgColor: Colors.deepPurpleAccent,
          placeholder: 'Blood Sugar',
          record: '',
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
            size: 60,
            color: Colors.white,
          ),
          bgColor: Colors.red[900],
          placeholder: 'Heart Rate',
          record: '',
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
        // InkWell(
        //   onTap: () {
        //     Navigator.popAndPushNamed(context, '/medication');
        //   },
        //   child: Card(
        //       elevation: 5,
        //       color: Colors.blueGrey[400],
        //       child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Column(
        //             children: [
        //               Icon(
        //                 CustomIcons.checklist,
        //                 size: 60,
        //                 color: Colors.white,
        //               ),
        //               Text(
        //                 'Checklist',
        //                 textAlign: TextAlign.center,
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontFamily: 'Open-Sans-Regular',
        //                   fontSize: 14,
        //                 ),
        //               ),
        //             ],
        //           ))),
        // ),
        // InkWell(
        //   onTap: () {
        //     Navigator.popAndPushNamed(context, '/medication');
        //   },
        //   child: Card(
        //       elevation: 5,
        //       color: Colors.deepOrangeAccent,
        //       child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Column(
        //             children: [
        //               Icon(
        //                 CustomIcons.pill,
        //                 size: 60,
        //                 color: Colors.white,
        //               ),
        //               Text(
        //                 'Medication',
        //                 textAlign: TextAlign.center,
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontFamily: 'Open-Sans-Regular',
        //                   fontSize: 14,
        //                 ),
        //               ),
        //             ],
        //           ))),
        // ),
        // InkWell(
        //   onTap: () {
        //     Navigator.popAndPushNamed(context, '/logs');
        //   },
        //   child: Card(
        //       elevation: 5,
        //       color: Colors.redAccent,
        //       child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Column(
        //             children: [
        //               Icon(
        //                 CustomIcons.paste,
        //                 size: 60,
        //                 color: Colors.white,
        //               ),
        //               Text(
        //                 'Logs',
        //                 textAlign: TextAlign.center,
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontFamily: 'Open-Sans-Regular',
        //                   fontSize: 14,
        //                 ),
        //               ),
        //             ],
        //           ))),
        // ),
      ];

      showModalBottomSheet(
          context: context,
          builder: (builder) {
            return Container(
              height: displayHeight(context) * 0.18,
              color: Colors.black,
              child: new Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                      child: cardList[index],
                    );
                  },
                  itemCount: cardList.length,
                  autoplay: true,
                  viewportFraction: 0.32,
                  scale: 0.01,
                  autoplayDelay: 3500),
            );
          });
    }

    return ConvexAppBar(
        backgroundColor: Colors.blue[700],
        items: [
          TabItem(icon: CustomIcons.checklist, title: ''),
          TabItem(icon: CustomIcons.pill, title: ''),
          TabItem(icon: Icons.home, title: ''),
          TabItem(icon: Icons.people, title: ''),
          TabItem(icon: CustomIcons.paste, title: ''),
        ],
        initialActiveIndex: widget.activeIndex ?? 2, //optional, default as 0
        onTap: (int i) {
          print('click index=$i');
          switch (i) {
            case 0:
              Navigator.popAndPushNamed(context, '/checklist');
              break;
            case 1:
              Navigator.popAndPushNamed(context, '/medication');
              break;
            //default
            case 2:
              Navigator.popAndPushNamed(context, '/home');
              // _showModalSheet();
              break;
            //
            case 3:
              Navigator.popAndPushNamed(context, '/appointment');
              break;
            case 4:
              Navigator.popAndPushNamed(context, '/logs');
              break;
            default:
          }
        });
  }
}
