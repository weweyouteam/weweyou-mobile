import 'dart:math';
import 'package:dio/dio.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weweyou/Navigator/navigation_drawer.dart';
import 'package:weweyou/model/banner_model.dart';
import 'package:weweyou/model/category_model.dart';
import 'package:weweyou/model/event_model.dart';
import 'package:weweyou/model/itinerary_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/create_event.dart';
import 'package:weweyou/screens/event_detail.dart';
import 'package:weweyou/screens/events.dart';
import 'package:weweyou/screens/filter.dart';
import 'package:weweyou/screens/notifications.dart';
import 'package:weweyou/screens/search.dart';
import 'package:weweyou/screens/select_city.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/widgets/event_card.dart';
import 'package:weweyou/widgets/itinenary_card.dart';
import 'package:weweyou/widgets/simple_appbar.dart';
import 'package:google_fonts/google_fonts.dart ';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<Category>> getEventCategories() async {
    var response= await Dio().get('$apiUrl/api/categories');
    print("repsonse ${response.statusCode} ${response.data}");
    List<Category> categories=[];
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        CategoryModel categoryModel=CategoryModel.fromJson(response.data);
        categoryModel.data.forEach((element) {
          categories.add(element);
        });
      }
    }
    return categories;
  }
  Future<List<Event>> getPopularEvent() async {
    var response= await Dio().get('$apiUrl/api/events');
    print("repsonse ${response.statusCode} ${response.data}");
    List<Event> events=[];
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        EventModelClass eventModel=EventModelClass.fromJson(response.data);
        eventModel.data.forEach((element) {
          events.add(element);
        });
      }
    }
    return events;
  }
  Future<List<Event>> getTrendingEvent() async {
    var response= await Dio().get('$apiUrl/api/events');
    print("repsonse ${response.statusCode} ${response.data}");
    List<Event> events=[];
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        EventModelClass eventModel=EventModelClass.fromJson(response.data);
        eventModel.data.forEach((element) {
          events.add(element);
        });
      }
    }
    return events;
  }

  Future<List<Itinerary>> getItinerary(apiToken) async {

    List<Itinerary> itineraryList=[];
    var response= await Dio().get('$apiUrl/api/get/allitineraryevets',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),);
    if(response.statusCode==200 && response.data['code']=="200"){
      ItineraryModel model=ItineraryModel.fromJson(response.data);
      model.data.forEach((element) {
        if(element.evants.length>0)
          itineraryList.add(element);
      });
    }
    return itineraryList;
  }

  Future<List<Banners>> getBanners(apiToken) async {

    List<Banners> list=[];
    var response= await Dio().get('$apiUrl/api/get/banners',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),);
    print("repsonse ${response.statusCode} ${response.data}");
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        BannerModel banner=BannerModel.fromJson(response.data);
        banner.data.forEach((element) {
          list.add(element);
        });
      }
    }
    return list;
  }



  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _openDrawer() {
    _drawerKey.currentState!.openDrawer();
  }


  bool searched = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var margin = MediaQuery
        .of(context)
        .size
        .width * 0.05;
    return Scaffold(
        key: _drawerKey,
        drawer: MenuDrawer(),
        backgroundColor: lightBackgroundColor,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                color: lightBackgroundColor
              /* gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xfffcc181),
                Colors.white,
              ],
            )*/
            ),
            child: ListView(
              children: [
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/name.png", height: 20,),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            _openDrawer();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            radius: 20,
                            child: Image.asset(
                              "assets/images/menu.png", color: Colors.grey,
                              height: 20,),
                          )
                      ),

                      Row(
                        children: [
                          InkWell(
                              onTap: () {

                                /*Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => NotificationList()));*/
                              },
                              child: AnimatedContainer(
                                duration: const Duration(seconds: 2),
                                curve: Curves.fastOutSlowIn,
                                child: Stack(
                                  children: [

                                    Align(
                                      child: Container(

                                        alignment: Alignment.centerLeft,
                                        width: searched ? MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.61 : 0,
                                        padding: EdgeInsets.only(left: 20),
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                20)
                                        ),

                                        child: Text("Search", style: TextStyle(
                                            color: Colors.black),),
                                      ),
                                    ),
                                    Container(
                                      width: searched ? MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.61 : 40,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .end,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                /*if (searched) {
                                                  setState(() {
                                                    searched = false;
                                                  });
                                                }
                                                else {
                                                  setState(() {
                                                    searched = true;
                                                  });
                                                }*/
                                                Navigator.push(context, new MaterialPageRoute(
                                                    builder: (context) => Search()));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: searched
                                                      ? primary
                                                      : Colors.grey[200],
                                                ),
                                                height: 40,
                                                width: 40,

                                                child: Icon(Icons.search,
                                                  color: searched
                                                      ? Colors.white
                                                      : Colors.grey,),
                                              )
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),
                          SizedBox(width: 10,),
                          InkWell(
                              onTap: () {
                                Navigator.push(context, new MaterialPageRoute(
                                    builder: (context) => NotificationList()));
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                radius: 20,
                                child: Image.asset(
                                  "assets/images/notification.png",
                                  color: Colors.grey, height: 20,),
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /*InkWell(
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => Search()));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(20,0,20,15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20),
                          height: 40,
                          color: Colors.white,
                          child: Text("Search",style: TextStyle(color: Colors.black),),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        color: primary,
                        child: Icon(Icons.search,color: Colors.white,),
                      )
                    ],
                  ),
                ),
              ),*/
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text("THE EVENTS YOU SHOULD NOT MISS",
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 17),),
                      ),
                      InkWell(
                        onTap: () {

                        },
                        child: Container(
                          child: Text("", style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w300),),
                        ),
                      )
                    ],
                  ),
                ),
                FutureBuilder<List<Banners>>(
                    future: getBanners(provider.userData!.apitoken),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {

                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      else {
                        if (snapshot.hasError) {
                          // Return error
                          print("itinerary error ${snapshot.error.toString()}");
                          return Center(
                            child: Text("Something went wrong"),
                          );
                        }
                        else if(snapshot.data!.length==0){
                          return Center(
                            child: Text("No Banners",style: TextStyle(color: Colors.white),),
                          );
                        }
                        else {
                          return CarouselSlider.builder(
                              options: CarouselOptions(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.3,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 1,
                                aspectRatio: 1,
                                initialPage: 0,
                              ),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                                  InkWell(
                                    onTap: () async {
                                      await launch(snapshot.data![itemIndex].link);
                                    },
                                    child: Container(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.3,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.9,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(snapshot.data![itemIndex].imagepath),
                                              fit: BoxFit.cover
                                          ),
                                          borderRadius: BorderRadius.circular(5)
                                      ),

                                    ),
                                  )
                          );
                        }
                      }
                    }
                ),



                // POPULAR EVENTS
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text("POPULAR EVENTS", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => EventList()));
                        },
                        child: Container(
                          child: Text("See All", style: TextStyle(color: Colors
                              .white, fontWeight: FontWeight.w300),),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  child: FutureBuilder<List<Event>>(
                      future: getPopularEvent(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {

                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else {
                          if (snapshot.hasError) {
                            // Return error
                            print("itinerary error ${snapshot.error.toString()}");
                            return Center(
                              child: Text("Something went wrong"),
                            );
                          }
                          else if(snapshot.data!.length==0){
                            return Center(
                              child: Text("No Popular Events",style: TextStyle(color: Colors.white),),
                            );
                          }
                          else {
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index){
                                return  EventCard(snapshot.data![index],"user_view");
                              },
                            );
                          }
                        }
                      }
                  ),
                ),
                SizedBox(height: 10,),


                //ITINERARY OF THE WEEK
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text("ITINERARY OF THE WEEK", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),),
                      ),
                      InkWell(
                        onTap: () {

                        },
                        child: Container(
                          child: Text("See All", style: TextStyle(color: Colors
                              .white, fontWeight: FontWeight.w300),),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: height * 0.4,
                  child: FutureBuilder<List<Itinerary>>(
                      future: getItinerary(provider.userData!.apitoken),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {

                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else {
                          if (snapshot.hasError) {
                            // Return error
                            print("itinerary error ${snapshot.error.toString()}");
                            return Center(
                              child: Text("Something went wrong"),
                            );
                          }
                          else if(snapshot.data!.length==0){
                            return Center(
                              child: Text("No Itineraries",style: TextStyle(color: Colors.white),),
                            );
                          }
                          else {
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index){
                                return  ItineraryCard(snapshot.data![index],"user_view");
                              },
                            );
                          }
                        }
                      }
                  ),
                ),
                /*Container(
                  height: height * 0.4,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('itineraries')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      if (snapshot.data!.size == 0) {
                        return Center(
                          child: Text("No Popular Events", style: TextStyle(
                              color: Colors.white),),
                        );
                      }

                      return ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!.docs.map((
                            DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()! as Map<
                              String,
                              dynamic>;
                          ItineraryModel itineraryModel = ItineraryModel
                              .fromMap(data, document.reference.id);
                          return ItineraryCard(itineraryModel, 'user_view');
                        }).toList(),
                      );
                    },
                  ),
                ),*/
                SizedBox(height: 10,),

                //EVENTS BY CATEGORY
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text("EVENTS CATEGORIES", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),),
                      ),
                      InkWell(
                        onTap: () {

                        },
                        child: Container(
                          child: Text("See All", style: TextStyle(color: Colors
                              .white, fontWeight: FontWeight.w300),),
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  height: height * 0.23,
                  child: FutureBuilder<List<Category>>(
                      future: getEventCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {

                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else {
                          if (snapshot.hasError) {
                            // Return error
                            print("itinerary error ${snapshot.error.toString()}");
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          }
                          else if(snapshot.data!.length==0){
                            return Center(
                              child: Text("No Categories",style: TextStyle(color: Colors.white),),
                            );
                          }
                          else {
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index){
                                return  Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: height * 0.3,
                                    width: width * 0.4,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(snapshot.data![index].image==""?imagePath:snapshot.data![index].image)
                                        )
                                    ),
                                    child: Container(
                                      alignment: Alignment.topCenter,
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        snapshot.data![index].name.toUpperCase(), style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12
                                      ),),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }
                      }
                  ),
                ),


                SizedBox(height: 10,),

                //TRENDING EVENTS
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text("TRENDING EVENTS", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),),
                      ),
                      InkWell(
                        onTap: () {

                        },
                        child: Container(
                          child: Text("See All", style: TextStyle(color: Colors
                              .white, fontWeight: FontWeight.w300),),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: height * 0.25,
                  child: FutureBuilder<List<Event>>(
                      future: getTrendingEvent(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {

                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else {
                          if (snapshot.hasError) {
                            // Return error
                            print("itinerary error ${snapshot.error.toString()}");
                            return Center(
                              child: Text("Something went wrong"),
                            );
                          }
                          else if(snapshot.data!.length==0){
                            return Center(
                              child: Text("No Trending Events",style: TextStyle(color: Colors.white),),
                            );
                          }
                          else {
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index){
                                return  EventCard(snapshot.data![index],"user_view");
                              },
                            );
                          }
                        }
                      }
                  ),
                ),
                /*Container(
                  height: height * 0.25,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('events')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      if (snapshot.data!.size == 0) {
                        return Center(
                          child: Text("No Trending Events", style: TextStyle(
                              color: Colors.white),),
                        );
                      }

                      return ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!.docs.map((
                            DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()! as Map<
                              String,
                              dynamic>;
                          EventModel eventModel = EventModel.fromMap(
                              data);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: height * 0.25,
                              width: width * 0.4,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(6),
                                          width: width * 0.15,
                                          color: primary,
                                          child: Center(child: Text(
                                            "${eventModel.month.substring(0, 3)
                                                .toUpperCase()} ${eventModel
                                                .day}", style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10
                                          ),))
                                      ),
                                      Container(
                                        width: width * 0.2,
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          eventModel.location, style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10
                                        ),),
                                      )
                                    ],
                                  ),


                                  Container(
                                    height: 120,
                                    width: double.infinity,
                                    child: Image.network(
                                      eventModel.image, fit: BoxFit.cover,),
                                  ),
                                  Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(5),
                                      alignment: Alignment.center,
                                      color: Colors.white.withOpacity(0.1),
                                      child: Text(
                                        eventModel.title,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),

                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
*/

                //create your events
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Text("CREATE", style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      )),
                    ),
                    Text("your event", style: GoogleFonts.lobster(
                      fontSize: 30,
                      color: Colors.red.shade900,
                    )
                    ),

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      height: height * 0.2,
                      width: width * 0.8,
                      color: Colors.grey.shade700.withOpacity(0.4),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
                                child: Text("It only takes about",
                                    style: GoogleFonts.cairo(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,

                                    )),
                              ),

                              CircleAvatar(
                                backgroundColor: Colors.black54.withOpacity(
                                    0.5),
                                radius: 30,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        "5", style: GoogleFonts.dancingScript(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold

                                      ),),
                                    ), Center(
                                      child: Text("minutes",
                                        style: GoogleFonts.dancingScript(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),),
                                    ),

                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("to create your event !",
                                    style: GoogleFonts.cairo(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,

                                    )),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(9, 14, 9, 9),
                            child: Container(
                              height: height * 0.045,
                              width: width * 0.3,
                              color: primary,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) =>
                                          CreateEvent("")));
                                },
                                child: Center(
                                  child: Text("+ ADD NEW", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300
                                  ),),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                ),*/

                /*SizedBox(height: 10,),
                // what your clioent saye
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text("WHAT CLIENT SAY", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),),
                      ),
                      InkWell(
                        onTap: () {

                        },
                        child: Container(
                          child: Text("See All", style: TextStyle(color: Colors
                              .white, fontWeight: FontWeight.w300),),
                        ),
                      )
                    ],
                  ),
                ),


                Container(
                  height: height * 0.15,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 12),
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: width * 0.9,
                            color: Colors.grey.shade700.withOpacity(0.5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8, 15, 8, 0),
                                  child: Text(
                                    "Great services, simple, efficient and intuitive! This is the tool I needed to organize events in Lausanne ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300
                                    ),),
                                ),
                                SizedBox(height: 10,),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Charles. M", style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),),
                                  ),
                                )
                              ],
                            ),
                          )

                      );
                    },
                  ),
                ),*/

                SizedBox(
                    height: height * 0.05
                ),


                /*Container(
                    height: height * 0.2,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/changeCountry.png"),
                          fit: BoxFit.cover,
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(9, 14, 9, 9),
                            child: Container(
                              height: height * 0.045,
                              width: width * 0.3,
                              color: primary,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SelectCity()));
                                },
                                child: Center(
                                  child: Text("SELECT CITY", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300
                                  ),),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                ),*/


              ],
            ),
          ),
        )
    );
  }

}
