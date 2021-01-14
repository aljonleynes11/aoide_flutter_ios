import 'dart:math';
import 'package:flutter/material.dart';
import '../../commons/TopNavBar.dart';
import '../../helpers/size.dart';

class NotificationScreen extends StatelessWidget {
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
                itemCount: 10,
                itemBuilder: (context, index) {
                  var result;
                  return Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: displayHeight(context) * 0.1,
                    // child: new ExpansionTile(
                    //     backgroundColor: Colors.white,
                    //     title: new Text(
                    //       result[index]['username'],
                    //     ))
                    child: GestureDetector(
                      onTap: () async {
                        print(result);
                      },
                      child: Row(children: [
                      
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Sample notification message",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Open-Sans-Regular',
                                ),
                                textAlign: TextAlign.start,
                              ),
                           
                            
                             
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
}

random(min, max) {
  var rn = new Random();
  return min + rn.nextInt(max - min);
}
