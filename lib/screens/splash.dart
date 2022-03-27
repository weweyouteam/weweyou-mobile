import 'dart:async';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:weweyou/model/user_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/home.dart';
import 'package:weweyou/screens/onboarding.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/utils/sharedPref.dart';
class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with TickerProviderStateMixin{
  AnimationController? animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    )
      ..forward()
      ..repeat(reverse: true);
    _loadWidget();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }
  final splashDelay = 5;


  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage()async{

    String userId= await getPrefUserId();
    List<UserModel> userList=[];
    //find in mysql for user
    if(userList.length==0)
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => OnBoarding()));
    else{
      final provider = Provider.of<UserDataProvider>(context, listen: false);
      provider.setUserData(userList[0]);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child:  Padding(
              padding: EdgeInsets.all(20),
              child: AnimatedBuilder(
                animation: animationController!,
                builder: (context, child) {
                  return Container(
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: CircleBorder(),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0 * animationController!.value),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(50),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: CircleBorder(),
                  ),
                  child: Image.asset("assets/images/icon.png",width: 250,height: 250,),
                ),
              ),
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:  Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Image.asset("assets/images/name.png",width: 300,height: 30,),
            )
          )


        ],
      )
    );
  }
}

