import 'package:flutter/material.dart';
import 'package:Aiode/helpers/size.dart';
import 'package:Aiode/commons/RoundedButton.dart';
import 'package:Aiode/commons/MySpacer.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

var slideText = [
  'Have access to your clinical records and Get Updated on your health status',
  'Easy tracking for a healthier lifestyle and synchronize collected data from your devices in one place',
  'Link your family health accounts and share data between users, doctors, service providers or family and friends'
];

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/backgrounds/background.jpg"),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Image.asset(
                    'assets/images/misc/logo-mix.png',
                    height: displayHeight(context) * 0.1,
                  ),
                ),
                MySpacer(
                  height: 0.02,
                ),
                Container(
                    child: Text(
                  "Let's get started",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Open-Sans-Regular',
                    color: Colors.white,
                  ),
                )),
                MySpacer(
                  height: 0.02,
                ),
                Container(
                  width: displayWidth(context) * 0.9,
                  height: displayHeight(context) * 0.07,
                  child: new Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: AutoSizeText(
                          slideText[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Open-Sans-Regular',
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    itemCount: slideText.length,
                    autoplay: true,
                    viewportFraction: 1,
                    scale: 0.5,
                    autoplayDelay: 5800,
                    // pagination: new SwiperPagination(
                    //   builder: SwiperPagination.dots,
                    //   margin: const EdgeInsets.all(20.0),
                    // ),
                  ),
                ),
                MySpacer(
                  height: 0.002,
                ),
                Container(
                    width: displayWidth(context) * 0.8,
                    child: RoundedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      bgColor: Colors.redAccent,
                      color: Colors.white,
                      buttonTitle: 'Create Account',
                    )),
                MySpacer(
                  height: 0.005,
                ),
                Container(
                    width: displayWidth(context) * 0.8,
                    child: RoundedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      bgColor: Colors.grey,
                      color: Colors.white,
                      buttonTitle: 'Sign in',
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
