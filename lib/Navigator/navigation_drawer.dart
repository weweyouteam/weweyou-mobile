
import 'package:flutter/material.dart';

import 'package:weweyou/screens/create_event.dart';
import 'package:weweyou/screens/create_itinerary.dart';
import 'package:weweyou/screens/events.dart';
import 'package:weweyou/screens/favourites.dart';
import 'package:weweyou/screens/groups.dart';
import 'package:weweyou/screens/getstarted.dart';
import 'package:weweyou/screens/home.dart';
import 'package:weweyou/screens/intinerary.dart';
import 'package:weweyou/screens/my_profile.dart';
import 'package:weweyou/screens/select_city.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/utils/sharedPref.dart';
import 'package:weweyou/widgets/stripe_dialog.dart';

class MenuDrawer extends StatefulWidget {


  @override
  MenuDrawerState createState() => new MenuDrawerState();
}


class MenuDrawerState extends State<MenuDrawer> {

  void onDrawerItemClicked(String name){
    Navigator.pop(context);
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.8,
      width: MediaQuery.of(context).size.width*0.8,
      margin: EdgeInsets.all(30),
      child: Drawer(
        child: SingleChildScrollView(
          child:  Container(
              height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: lightBackgroundColor,
            ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20,),

                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Container(
                             decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Colors.white,
                                 border: Border.all(color: primary,width: 2)
                             ),
                             height: 70,
                             width: 70,
                             padding: EdgeInsets.all(20),
                             child: Image.asset("assets/images/icon.png"),
                           ),
                         ),
                         Container(height: 10),
                         Text('WEWEYOU', style: TextStyle(color: primary,fontSize: 20,fontWeight: FontWeight.bold)),
                         Container(height: 20),

                       ],
                     ),

                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           InkWell(
                             onTap: (){
                             },
                             child: Image.asset("assets/images/location.png", color: Colors.white, height: 20),
                           ),
                           SizedBox(width: 10,),
                           InkWell(
                             onTap: (){

                             },
                             child: Image.asset("assets/images/currency.png", color: Colors.white, height: 20),
                           ),
                         ],
                       ),
                     ),
                   ],
                 ),



                  SizedBox(
                    height: 10,
                  ),

                  Divider(
                    height: 4,
                    color: Colors.white,
                    endIndent: 10,
                    indent: 10,
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  InkWell(onTap: (){
                    //showStripeDialog(context);
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => HomePage()));
                  },
                    child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.home_outlined, color: Colors.white, size: 20),
                          Container(width: 20),
                          Expanded(child: Text('Home', style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 10),
                  InkWell(onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => MyProfile(0)));
                  },
                    child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.person_outline, color: Colors.white, size: 20),
                          Container(width: 20),
                          Expanded(child: Text('My Account', style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 10),
                  InkWell(onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => EventList()));
                  },
                    child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Image.asset("assets/images/event.png", color: Colors.white, height: 20),
                          //Icon(Icons.calendar_today_outlined, color: Colors.white, size: 20),
                          Container(width: 20),
                          Expanded(child: Text('Events', style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 10),
                 /* InkWell(onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => CreateEvent("")));
                  },
                    child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add_circle, color: primary, size: 20),
                          Container(width: 20),
                          Expanded(child: Text('Create Events', style: TextStyle(color: primary))),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 10),*/
                  InkWell(onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => ItineraryList()));
                  },
                    child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Image.asset("assets/images/route.png", color: Colors.white, height: 20),
                          Container(width: 20),
                          Expanded(child: Text('Itineraries', style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                  ),
                  /*Container(height: 10),
                  InkWell(onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => CreateItinerary()));
                  },
                    child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add_location, color: Colors.white, size: 20),
                          Container(width: 20),
                          Expanded(child: Text('Create Itineraries', style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                  ),*/
                  Container(height: 10),
                  InkWell(onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => Groups()));
                  },
                    child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.people_outline, color: Colors.white, size: 20),
                          Container(width: 20),
                          Expanded(child: Text('Groups', style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 10),
                  InkWell(onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => Favourites()));
                  },
                    child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.favorite_border, color: Colors.white, size: 20),
                          Container(width: 20),
                          Expanded(child: Text('Favourites', style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                  ),
                  /*Container(height: 10),
                  InkWell(onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => Groups()));
                  },
                    child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.language_outlined, color: Colors.white, size: 20),
                          Container(width: 20),
                          Expanded(child: Text('Change Language', style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                  ),*/
                  Container(height: 10),
                  InkWell(onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => SelectCity()));
                  },
                    child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.location_on_outlined, color: Colors.white, size: 20),
                          Container(width: 20),
                          Expanded(child: Text('Change Location', style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 10),
                  InkWell(onTap: (){
                    setPrefUserId("no user").then((value) {
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => GetStarted()));
                      });
                    },
                    child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.exit_to_app, color: Colors.white, size: 20),
                          Container(width: 20),
                          Expanded(child: Text('Logout', style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                  ),






                ],
              ),
            ),

        ),
      ),
    );
  }




}
