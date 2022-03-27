import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:weweyou/screens/getstarted.dart';
import 'package:weweyou/screens/select_city.dart';
import 'package:weweyou/utils/constants.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController controller = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height*0.7,
              child: PageView(
                onPageChanged: (int index) {
                  _currentPageNotifier.value = index;
                },
                scrollDirection: Axis.horizontal,
                controller: controller,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:Border.all(color: Colors.white,width: 10,style: BorderStyle.solid),
                        image: DecorationImage(
                            image: AssetImage("assets/images/slide3.png"),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:Border.all(color: Colors.white,width: 10,style: BorderStyle.solid),
                        image: DecorationImage(
                            image: AssetImage("assets/images/slide2.png"),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:Border.all(color: Colors.white,width: 10,style: BorderStyle.solid),
                        image: DecorationImage(
                            image: AssetImage("assets/images/slide1.png"),
                            fit: BoxFit.cover
                        )
                    ),
                  ),

                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height*0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Text("WEWEYOU",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Colors.white),),
                  SizedBox(height: 10,),
                  Text("Discover the events around you",textAlign: TextAlign.center,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.white)),
                  SizedBox(height: 30,),
                  CirclePageIndicator(
                    dotColor: Colors.white,
                    selectedDotColor: primary,
                    itemCount: 3,
                    currentPageNotifier: _currentPageNotifier,
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GetStarted()));

                    },
                    child: Container(
                        height: 50,
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width*0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primary
                        ),
                        alignment: Alignment.center,
                        child: Text("Get Started!",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)

                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
