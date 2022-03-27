import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:weweyou/model/category_model.dart';
import 'package:weweyou/model/event_model.dart';
import 'package:weweyou/model/user_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/create_event.dart';
import 'package:weweyou/screens/edit_event.dart';
import 'package:weweyou/screens/event_detail.dart';
import 'package:weweyou/screens/home.dart';
import 'package:weweyou/screens/my_profile.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/utils/custom_dailogs.dart';
import 'package:weweyou/widgets/event_card.dart';

import 'add_to_existing_intinerary.dart';

class MyEventDetail extends StatefulWidget {
  Event event;

  MyEventDetail(this.event);

  @override
  _MyEventDetailState createState() => _MyEventDetailState();
}

class _MyEventDetailState extends State<MyEventDetail> {

  choiceDialog(int uid) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Card(
          margin: EdgeInsets.only(top: MediaQuery
              .of(context)
              .size
              .height * 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
          ),
          elevation: 2,

          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    /*Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => AddToExistingItinerary(widget.event.id)));*/
                    //Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: Text("Choose from existing", style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () async{
                    final ProgressDialog pr = ProgressDialog(context: context);
                    pr.show(max: 100, msg: "Adding");
                    /*var db = await mongo.Db.create(connString);
                    await db.open();
                    var coll = db.collection('itineraries');
                    coll.insert({
                      'id':DateTime.now().millisecondsSinceEpoch.toString(),
                      'eventIds': [widget.event.id],
                      'userId': "uid",
                    }).then((value) {
                      db.close();
                      pr.close();
                      showSuccessDailog("Successfully created itinerary", context);

                    }).onError((error, stackTrace) {
                      db.close();
                      pr.close();
                      showFailuresDailog(error.toString(), context);

                    });*/
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: Text("Create New One", style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 0,),
                height: MediaQuery.of(context).size.height*0.3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.event.images!),
                        fit: BoxFit.cover
                    )
                ),
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back,color: Colors.white,),
                        ),
                        Row(
                          children: [
                            InkWell(onTap: (){
                              Share.share('https://weweyou.com');
                            },child: Icon(Icons.share,color: Colors.white,)),
                            SizedBox(width: 5,),
                          ],
                        )
                      ],
                    ),
                    InkWell(
                      onTap: (){
                        choiceDialog(provider.userData!.id);
                      },
                      child:  Container(
                        height: 40,
                        width: 100,
                        margin: EdgeInsets.fromLTRB(10,0,10,20),
                        decoration: BoxDecoration(
                          color: primary,
                        ),
                        alignment: Alignment.center,
                        child: Text("+ Itinerary",style: TextStyle(fontSize:15,fontWeight: FontWeight.w300,color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category,style: TextStyle(fontSize:10,color: Colors.grey),),
                    SizedBox(height: 5,),
                    Text(widget.event.title,style: TextStyle(fontSize:20,color: Colors.white),),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Icons.access_time,size: 20,color: Colors.white),
                        SizedBox(width: 5,),
                        Text(widget.event.startDate,style: TextStyle(fontSize:15,color: Colors.white),),
                      ],
                    ),
                    SizedBox(height: 10,),

                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.people,size: 20,color: Colors.grey[600]),
                                SizedBox(width: 5,),
                                Text("Participants",style: TextStyle(color: Colors.grey[500]),),
                              ],
                            ),
                            SizedBox(height: 5,),
                            if(isMembersLoaded && memberList.length==0)
                              Text("No Participants",style: TextStyle(color: Colors.white,fontSize: 12),)
                            else
                            isMembersLoaded?Container(
                              child: Row(
                                children: [
                                  if(memberList.length>0)
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white,style: BorderStyle.solid,width: 2),
                                          image: DecorationImage(
                                              image: NetworkImage(memberList[0].avatar=="none"?imagePath:memberList[0].avatar),
                                              fit: BoxFit.cover
                                          ),
                                          shape: BoxShape.circle
                                      ),
                                    ),
                                  if(memberList.length>1)
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white,style: BorderStyle.solid,width: 2),
                                          image: DecorationImage(
                                              image:  NetworkImage(memberList[1].avatar=="none"?imagePath:memberList[1].avatar),
                                              fit: BoxFit.cover
                                          ),
                                          shape: BoxShape.circle
                                      ),
                                    ),
                                  if(memberList.length>2)
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white,style: BorderStyle.solid,width: 2),
                                          image: DecorationImage(
                                              image:  NetworkImage(memberList[2].avatar=="none"?imagePath:memberList[2].avatar),
                                              fit: BoxFit.cover
                                          ),
                                          shape: BoxShape.circle
                                      ),
                                    ),
                                  if(memberList.length>3)
                                    Container(
                                      child: Text("+ ${memberList.length-3} More",style: TextStyle(color: Colors.white),),
                                    ),
                                ],
                              ),
                            ):Center(child: CircularProgressIndicator(),)

                          ],
                        ),
                        Container(
                          color: Colors.white,
                          child: QrImage(
                            data: widget.event.id.toString(),
                            version: QrVersions.auto,
                            size: 80.0,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("DETAILS",style: TextStyle(fontSize:15,color: Colors.white),),
                    SizedBox(height: 5,),
                    Text(widget.event.description!,style: TextStyle(fontSize:12,color: Colors.white,fontWeight: FontWeight.w300),),
                    SizedBox(height: 10,),
                    /*Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [


                    Text("More",style: TextStyle(fontSize:12,color: primary),),
                    SizedBox(width: 5,),
                    Icon(Icons.arrow_forward_ios_outlined,size: 12,color: primary),
                  ],
                ),*/
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text("SUB EVENTS",style: TextStyle(fontSize:15,color: Colors.white),),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => CreateEvent(widget.event.id.toString())));
                          },
                          child: Container(
                            child: Align(
                              alignment: Alignment.center,
                              child:Icon(Icons.add_circle, color: primary, size: 30),
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 10,),

                    Container(
                      height: 200,
                      child: FutureBuilder<List<Event>>(
                          future: getSubEvents(provider.userData!.apitoken),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {

                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            else {
                              if (snapshot.hasError) {
                                // Return error
                                print("event error ${snapshot.error.toString()}");
                                return Center(
                                  child: Text("Something went wrong"),
                                );
                              }
                              else if(snapshot.data!.length==0){
                                return Center(
                                  child: Text("No Sub Events",style: TextStyle(color: Colors.white),),
                                );
                              }
                              else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (BuildContext context, int index){
                                    return  InkWell(
                                      onTap: (){
                                        Navigator.push(context, new MaterialPageRoute(
                                            builder: (context) => EventDetail(snapshot.data![index],provider.userData!.id,provider.userData!.apitoken)));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(10,10,0,10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                height: 200,
                                                width: MediaQuery.of(context).size.width*0.7,
                                                color: Colors.grey.shade700.withOpacity(0.5),
                                                child: Stack(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.all(7),
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Image.network(snapshot.data![index].images!,height: 120,width: MediaQuery.of(context).size.width*0.7,fit: BoxFit.cover,),
                                                            SizedBox(height: 10,),
                                                            Text(snapshot.data![index].title,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 15),),
                                                            SizedBox(height: 5,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(snapshot.data![index].address,style: TextStyle(fontWeight: FontWeight.w300,color: Colors.white,fontSize:10),),
                                                                //Text("${snapshot.data![index].tickets} Tickets",style: TextStyle(fontWeight: FontWeight.w300,color: Colors.white,fontSize:10),),
                                                              ],
                                                            )

                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Container(
                                                        color: primary,
                                                        padding: EdgeInsets.all(10),
                                                        child: Text("${snapshot.data![index].startDate}",style: TextStyle(fontSize: 10,color: Colors.white),),
                                                      ),
                                                    ),

                                                  ],
                                                )
                                            ),

                                          ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("LOCATION",style: TextStyle(fontSize:15,color: Colors.white),),
                        InkWell(
                          onTap: (){
                            MapsLauncher.launchQuery(widget.event.address);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("How to get there?",style: TextStyle(fontSize:12,color: primary),),
                              SizedBox(width: 5,),
                              Icon(Icons.arrow_forward_ios_outlined,size: 12,color: primary),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text(widget.event.address,style: TextStyle(fontSize:12,color: Colors.grey,fontWeight: FontWeight.w300),),
                    SizedBox(height: 10,),
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        zoomControlsEnabled: false,
                        initialCameraPosition: _kGooglePlex!,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),


                    SizedBox(height: 10,),

                    /*Container(
                  height: MediaQuery.of(context).size.height*0.2,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      if (snapshot.data!.size == 0) {
                        return Center(
                          child: Text("No Reviews",style: TextStyle(color: Colors.white),),
                        );
                      }

                      return ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width : MediaQuery.of(context).size.width *0.9,
                                padding: const EdgeInsets.all(8.0),
                                color : Colors.grey.shade700.withOpacity(0.5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,

                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image:AssetImage("assets/images/user.png"),
                                                  fit: BoxFit.cover
                                              ),
                                              shape: BoxShape.circle
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Text("Charles. M",style: TextStyle(
                                          fontSize : 15,
                                          color : Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ), ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(8,15,8,0),
                                      child: Text("Great services, simple, efficient and intuitive! This is the tool I needed to organize events in Lausanne " ,style: TextStyle(
                                          fontSize : 12,
                                          color : Colors.white,
                                          fontWeight: FontWeight.w300
                                      ), ),
                                    ),

                                  ],
                                ),
                              )

                          );
                        }).toList(),
                      );
                    },
                  ),
                ),*/

                    SizedBox(height: 10,),
                    Text("SIMILAR EVENTS",style: TextStyle(fontSize:15,color: Colors.white),),
                    SizedBox(height: 10,),
                    Container(
                      height: 200,
                      child: FutureBuilder<List<Event>>(
                          future: getSimilarEvents(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {

                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            else {
                              if (snapshot.hasError) {
                                // Return error
                                print("event error ${snapshot.error.toString()}");
                                return Center(
                                  child: Text("Something went wrong"),
                                );
                              }
                              else if(snapshot.data!.length==0){
                                return Center(
                                  child: Text("No Similar Events",style: TextStyle(color: Colors.white),),
                                );
                              }
                              else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (BuildContext context, int index){
                                    return EventCard(snapshot.data![index], "user_view");
                                  },
                                );
                              }
                            }
                          }
                      ),
                    ),

                    /*InkWell(
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => GetTickets()));
                  },
                  child:  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10,0,10,20),
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    alignment: Alignment.center,
                    child: Text("GET IT - \$${widget.event.price}",style: TextStyle(fontSize:18,fontWeight: FontWeight.w500,color: Colors.white),),
                  ),
                ),*/
                    SizedBox(height: 70,),

                  ],
                ),
              ),



            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(10,0,10,20),
              decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(10)
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => EditEvent(widget.event)));
                    },
                    child: Icon(Icons.edit,color: Colors.white,),
                  ),
                  InkWell(
                    onTap: (){
                      _showPauseDialog(widget.event.is_active==0?false:true,provider.userData!.apitoken);
                    },
                    child: Icon(widget.event.is_active==0?Icons.play_arrow:Icons.pause,color: Colors.white,),
                  ),
                  InkWell(
                    onTap: (){
                      _showDeleteDialog(provider.userData!.apitoken);
                    },
                    child: Icon(Icons.delete,color: Colors.white,),
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  Future<void> _showDeleteDialog(apiToken) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete this event?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async{

                await Dio().get('$apiUrl/api/delete/event?id=${widget.event.id}',
                  options: Options(
                      headers: {
                        "apitoken": apiToken
                      }
                  ),).then((value){
                  Navigator.pushReplacement(context, new MaterialPageRoute(
                      builder: (context) => MyProfile(0)));
                });

              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showPauseDialog(bool paused,apiToken) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(paused?"Resume Event":'Pause Event'),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text(paused?'Are you sure you want to resume this event?':'Are you sure you want to pause this event?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child:  Text('Yes'),
              onPressed: () async{
                final ProgressDialog pr = ProgressDialog(context: context);
                pr.show(max: 100, msg: "Please wait",barrierDismissible: true);

                Dio dio = new Dio();
                FormData formdata = new FormData();
                formdata = FormData.fromMap({
                  'event_id': widget.event.id,
                 
                });
                var response=await dio.post(
                    '$apiUrl/api/active/pauseevent',
                    data: formdata,
                    options: Options(
                      headers: {
                        "apitoken": apiToken
                      },
                      method: 'POST',
                      responseType: ResponseType.json,

                    )
                );
                print("repsonse ${response.statusCode} ${response.data}");
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyEventDetail(widget.event)));
              },
            ),
          ],
        );
      },
    );
  }
  Future deleteEvent(String eventId)async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Please Wait");
    var response= await Dio().get('$apiUrl/api/delete/event?id=${widget.event.id}');
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        pr.close();
        final snackBar = SnackBar(content: Text("${response.data['message']}"),backgroundColor: Colors.green,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyProfile(0)));
      }
      else{
        pr.close();
        final snackBar = SnackBar(content: Text("Error : ${response.data['message']}"),backgroundColor: Colors.red,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
  Future<List<Event>> getSubEvents(apiToken) async {
    List<Event> subEventList=[];
    var response= await Dio().get('$apiUrl/api/getsubEvent?event_id=${widget.event.id}',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),);
    print("repsonse ${response.statusCode} ${response.data}");
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        EventModelClass eventModel=EventModelClass.fromJson(response.data);
        eventModel.data.forEach((element) {
          if(element.categoryId==widget.event.categoryId)
            subEventList.add(element);
        });
      }
    }
    return subEventList;
  }
  Future<List<Event>> getSimilarEvents() async {
    List<Event> similarEventList=[];
    var response= await Dio().get('$apiUrl/api/events');
    print("repsonse ${response.statusCode} ${response.data}");
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        EventModelClass eventModel=EventModelClass.fromJson(response.data);
        eventModel.data.forEach((element) {
          if(element.categoryId==widget.event.categoryId)
            similarEventList.add(element);
        });
      }
    }
    return similarEventList;

  }
  List<UserModel> memberList=[];
  bool isMembersLoaded=false;
  getMembers(List list) async {
   /* var db = await mongo.Db.create(connString);
    await db.open();
    await db.collection("users").find().forEach((user) {
      EventModel model=EventModel.fromMap(user);
      list.forEach((element) {
        if(element==model.id){
          setState(() {
            //memberList.add(UserModel.fromMap(user));
          });
        }
      });*//*

    });*/
    setState(() {
      isMembersLoaded=true;
    });

  }
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition? _kGooglePlex;
  String category="";
  getCategoryName() async {
    var response= await Dio().get('$apiUrl/api/categories');
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        CategoryModel categoryModel=CategoryModel.fromJson(response.data);
        categoryModel.data.forEach((element) {
          if(element.id==widget.event.categoryId)
            setState(() {
              category=element.name;
            });
        });
      }
    }
  }
  @override
  void initState() {
    super.initState();
    getCategoryName();
    /*setState(() {
      paused=widget.event.paused;
    });
    getMembers(widget.event.participants);*/
    _kGooglePlex = CameraPosition(
      target: LatLng(double.parse(widget.event.latitude!), double.parse(widget.event.longitude!)),
      zoom: 14.4746,
    );
  }
}
