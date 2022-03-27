import 'dart:async';


import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:weweyou/model/favourite/event_favourite_model.dart';
import 'package:weweyou/model/favourite_model.dart';
import 'package:weweyou/model/ticket_model.dart';
import 'package:weweyou/model/user_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/add_to_existing_intinerary.dart';
import 'package:weweyou/screens/create_event.dart';
import 'package:weweyou/screens/payment_screen.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/utils/custom_dailogs.dart';
import 'package:weweyou/widgets/event_card.dart';

import 'get_tickets.dart';

class EventDetail extends StatefulWidget {
  Event event;int userId;String apiToken;


  EventDetail(this.event,this.userId,this.apiToken);

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  List<Event> subEventList=[];
  List<Event> similarEventList=[];
  bool isDataLoaded=false;
  getSubEvents(apiToken) async {
    var response= await Dio().get('$apiUrl/api/getsubEvent?event_id=${widget.event.id}',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),);
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        EventModelClass eventModel=EventModelClass.fromJson(response.data);
        eventModel.data.forEach((element) {
            subEventList.add(element);
        });
      }
    }
    /*var response2= await Dio().get('$apiUrl/api/events');
    if(response2.statusCode==200){
      if(response2.data['code']=="200"){
        EventModelClass eventModel=EventModelClass.fromJson(response2.data);
        eventModel.data.forEach((element) {
          if(element.categoryId==widget.event.categoryId)
            similarEventList.add(element);
        });
      }
    }*/
    setState(() {
      isDataLoaded=true;
    });
  }
  /*Future<List<Event>> getSubEvents(apiToken) async {
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
  }*/
  String category="";
  getCategoryName() async {
    /*var response= await Dio().get('$apiUrl/api/categories');
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
    }*/
  }
  Future<UserInformation> getOrganizerDetail(int organizorId) async {
    var response= await Dio().get('$apiUrl/api/getUser?user_id=${widget.userId}');
    print("repsonse ${response.statusCode} ${response.data}");
    return UserInformationModel.fromJson(response.data).data;
  }
  bool addingToFavourite=false;
  bool isFavourite=false;
  Future changeFavourite(apiToken)async{
    setState(() {
      addingToFavourite=true;
    });
    Dio dio = new Dio();
    FormData formdata = new FormData();

    formdata = FormData.fromMap({
      'event_id':widget.event.id,
    });
    var response= await dio.post(
        '$apiUrl/api/add/remove/favourites',
        data: formdata, options: Options(
        headers: {
          "apitoken": apiToken
        },
        method: 'POST',
        responseType: ResponseType.json // or ResponseType.JSON
    )
    );
    //print("repsonse ${response.statusCode} ${response.data}");

    if(response.statusCode==200){
      setState(() {
        addingToFavourite=false;
      });
      if(response.data['code']=="200"){
        setState(() {
          isFavourite=true;
        });
      }
      else if(response.data['code']=="201"){
        setState(() {
          isFavourite=false;
        });
      }
      else{
        final snackBar = SnackBar(content: Text("Error : ${response.data['message']}"),backgroundColor: Colors.red,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

    }
    else{
      setState(() {
        addingToFavourite=false;
      });
      final snackBar = SnackBar(content: Text("Error : Unable to change"),backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    /*var db = await mongo.Db.create(connString);
    await db.open();
    var coll = db.collection('favourites');
    await coll.deleteOne({"id": favId}).then((value) {
      db.close();
      setState(() {
        addingToFavourite=false;
      });
    }).onError((error, stackTrace) {
      db.close();
      setState(() {
        addingToFavourite=false;
      });
    });*/
  }

  Future checkFavourite(userId,apiToken) async {
    setState(() {
      addingToFavourite=true;
    });
    var response= await Dio().get('$apiUrl/api/get/favorite/events',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),);
    print("repsonse ${response.statusCode} ${response.data}");
    List<Event> events=[];
    if(response.statusCode==200 && response.data['code']=="200") {
      EventFavoriteModel eventModel=EventFavoriteModel.fromJson(response.data);
      eventModel.data.forEach((element) {
        if(element.event.id==widget.event.id)
          events.add(element.event);
      });
    }
    if(events.length>0){
      setState(() {
        isFavourite=true;
      });
    }
    else{
      setState(() {
        isFavourite=false;
      });
    }
    setState(() {
      addingToFavourite=false;
    });

  }

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
                    Navigator.pop(context);
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => AddToExistingItinerary(widget.event.id)));

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
                    Dio dio = new Dio();
                    FormData formdata = new FormData();
                    formdata = FormData.fromMap({
                      'event_id': widget.event.id,
                    });
                    var response=await dio.post(
                        '$apiUrl/api/Create/NewItineraryEvent',
                        data: formdata,
                        options: Options(
                          headers: {
                            "apitoken": widget.apiToken
                          },
                          method: 'POST',
                          responseType: ResponseType.json,

                        )
                    );
                    if(response.statusCode==200 && response.data['code']=="200"){
                      pr.close();
                      showSuccessDailog("Successfully created itinerary", context);

                    }
                    else{
                      pr.close();
                      showFailuresDailog("Unable to create itinerary", context);
                    }
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
  Completer<GoogleMapController> _controller = Completer();
  double total=0;int ticket=0;
  CameraPosition? _kGooglePlex;

  bool ticketsLoad=true;
  List memberList=[];
  bool isMembersLoaded=false;

  getMembers(apiToken) async {

    var response= await Dio().get('$apiUrl/api/all/bookedtickets/member?event_id=${widget.event.id}',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),);
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        memberList.add(response.data['data']);
      }
    }
    setState(() {
      isMembersLoaded=true;
    });

  }
  List<Tickets> ticketsList=[];
  Future getTickets(apiToken)async{

    print("here ${widget.event.id}");
    var response= await Dio().get('$apiUrl/api/event/ticket?event_id=${widget.event.id}',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),
    );
    print("ticekt repsonse ${response.statusCode} ${response.data}");
    if(response.statusCode==200 && response.data['code']=="200"){
      EventTicketModel ticketModel=EventTicketModel.fromJson(response.data);
      ticketModel.data.forEach((element) {
        ticketsList.add(element);
        print("tickete added ${element.title}");
      });
    }
    setState(() {
      ticketsLoad=true;
    });


  }
  int currentIndex=0;

  @override
  void initState() {
    super.initState();
    checkFavourite(widget.userId, widget.apiToken);
    _kGooglePlex = CameraPosition(
      target: LatLng(double.parse(widget.event.latitude!), double.parse(widget.event.longitude!)),
      zoom: 14.4746,
    );
    //changeFavourite(widget.apiToken);
    getSubEvents(widget.apiToken);
    getTickets(widget.apiToken);
    getMembers(widget.apiToken);

  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 30, 10, 0,),
            height: MediaQuery.of(context).size.height*0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.event.images==""?imagePath:widget.event.images!),
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
                        addingToFavourite?CupertinoActivityIndicator():InkWell(
                          onTap: (){
                            changeFavourite(provider.userData!.apitoken);
                            /*if(isFavourite){
                              removeFavourite(widget.userId).then((value){
                                checkForFavourite(widget.userId);
                              });
                            }
                            else{
                              addToFavourite(widget.userId).then((value){
                                checkForFavourite(widget.userId);
                              });
                            }*/
                          },
                          child: Icon(isFavourite?Icons.favorite:Icons.favorite_border,color: isFavourite?Colors.red:Colors.white,),
                        )
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
                Text("Select Tickets",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),),
                SizedBox(height: 10,),
                /*FutureBuilder<List<Tickets>>(
                    future: getTickets(provider.userData!.apitoken),
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
                            child: Text(snapshot.error.toString()),
                          );
                        }
                        else if(snapshot.data!.length==0){
                          return Center(
                            child: Text("No Sub Events",style: TextStyle(color: Colors.white),),
                          );
                        }
                        else {
                          return Container(
                            child: Card(
                              elevation: 10,
                              child: Row(
                                children: [

                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 100,
                                      color: primary,
                                      alignment: Alignment.center,
                                      child: Text(ticket.toString(),style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.w900),),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: (){
                                              setState(() {
                                                if(currentIndex==0){
                                                  currentIndex=snapshot.data!.length-1;
                                                  total=0*ticket;
                                                }
                                                else{
                                                  currentIndex--;
                                                  total=0*ticket;
                                                }
                                              });
                                            },
                                            icon: Icon(Icons.arrow_back_ios_rounded,color: primary),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(snapshot.data![currentIndex].title,style: TextStyle(color: primary,fontSize: 15,fontWeight: FontWeight.w500),),
                                              Text("\$${0} X $ticket = $total",style: TextStyle(color: primary,fontSize: 15,fontWeight: FontWeight.w300),)
                                            ],
                                          ),
                                          IconButton(
                                            onPressed: (){
                                              setState(() {
                                                if(currentIndex==snapshot.data!.length-1){
                                                  currentIndex=0;
                                                  total=0*ticket;
                                                }
                                                else{
                                                  currentIndex++;
                                                  total=0*ticket;
                                                }
                                              });
                                            },
                                            icon: Icon(Icons.arrow_forward_ios_rounded,color: primary,),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                if(ticket<snapshot.data![currentIndex].quantity){
                                                  ticket++;
                                                  total=0*ticket;
                                                }

                                              });
                                            },
                                            child: Icon(Icons.add,color: primary,size: 30,),
                                          ),
                                          SizedBox(height: 10,),
                                          InkWell(
                                            onTap: (){
                                              if(ticket>0)
                                                setState(() {
                                                  ticket--;
                                                  total=0*ticket;
                                                });
                                            },
                                            child: Icon(Icons.remove,color: primary,size: 30,),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          );
                        }
                      }
                    }
                ),*/
                if(ticketsList.length>0 && ticketsLoad)
                  Container(
                    child: Card(
                      elevation: 10,
                      child: Row(
                        children: [

                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 100,
                              color: primary,
                              alignment: Alignment.center,
                              child: Text(ticket.toString(),style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.w900),),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: (){
                                      setState(() {
                                        ticket=0;
                                        total=0;
                                        if(currentIndex==0){
                                          currentIndex=ticketsList.length-1;
                                          total=double.parse(ticketsList[currentIndex].price.toString())*ticket;
                                        }
                                        else{
                                          currentIndex--;
                                          total=double.parse(ticketsList[currentIndex].price.toString())*ticket;
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.arrow_back_ios_rounded,color: primary),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(ticketsList[currentIndex].title,style: TextStyle(color: primary,fontSize: 15,fontWeight: FontWeight.w500),),
                                      Text("\$${ticketsList[currentIndex].price} X $ticket = ${total.toInt()}",style: TextStyle(color: primary,fontSize: 15,fontWeight: FontWeight.w300),)
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: (){

                                      setState(() {
                                        ticket=0;
                                        total=0;
                                        if(currentIndex==ticketsList.length-1){
                                          currentIndex=0;
                                          total=double.parse(ticketsList[currentIndex].price.toString())*ticket;
                                        }
                                        else{
                                          currentIndex++;
                                          total=double.parse(ticketsList[currentIndex].price.toString())*ticket;
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.arrow_forward_ios_rounded,color: primary,),
                                  ),
                                ],
                              ),
                            ),

                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        if(ticket<ticketsList[currentIndex].quantity){
                                          ticket++;
                                          total=double.parse(ticketsList[currentIndex].price.toString())*ticket;
                                        }

                                      });
                                    },
                                    child: Icon(Icons.add,color: primary,size: 30,),
                                  ),
                                  SizedBox(height: 10,),
                                  InkWell(
                                    onTap: (){
                                      if(ticket>0)
                                        setState(() {
                                          ticket--;
                                          total=double.parse(ticketsList[currentIndex].price.toString())*ticket;
                                        });
                                    },
                                    child: Icon(Icons.remove,color: primary,size: 30,),
                                  )
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  )
                else if(ticketsList.length==0 && ticketsLoad)
                  Text("No Tickets",style: TextStyle(color: Colors.white,fontSize: 12),)
                else
                  Center(
                    child: CircularProgressIndicator(),
                  ),
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
                              Container(
                                child: Text("${memberList.length} People",style: TextStyle(color: Colors.white),),
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

                /*Container(
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
                              child: Text(snapshot.error.toString()),
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
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index){
                                return  InkWell(
                                  onTap: (){
                                    Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) => EventDetail(snapshot.data![index],widget.userId,widget.apiToken)));
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
                ),*/
                if(subEventList.length>0 && isDataLoaded)
                  Container(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: subEventList.length,
                      itemBuilder: (BuildContext context, int index){
                        return  InkWell(
                          onTap: (){
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => EventDetail(subEventList[index],widget.userId,widget.apiToken)));
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
                                                Image.network(subEventList[index].images!,height: 120,width: MediaQuery.of(context).size.width*0.7,fit: BoxFit.cover,),
                                                SizedBox(height: 10,),
                                                Text(subEventList[index].title,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 15),),
                                                SizedBox(height: 5,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(subEventList[index].address,style: TextStyle(fontWeight: FontWeight.w300,color: Colors.white,fontSize:10),),
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
                                            child: Text("${subEventList[index].startDate}",style: TextStyle(fontSize: 10,color: Colors.white),),
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
                    ),
                  )
                else if(subEventList.length==0 && isDataLoaded)
                  Text("No Sub Events",style: TextStyle(color: Colors.white,fontSize: 12),)
                else
                  Center(
                    child: CircularProgressIndicator(),
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


                Text("CONTACT",style: TextStyle(fontSize:15,color: Colors.white),),
                SizedBox(height: 10,),
                FutureBuilder<UserInformation>(
                    future: getOrganizerDetail(widget.event.userId),
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

                        else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  /*Container(
                                    height: 30,
                                    width: 30,

                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image:NetworkImage(snapshot.data!.avatar==""?imagePath:snapshot.data!.avatar),
                                            fit: BoxFit.cover
                                        ),
                                        shape: BoxShape.circle
                                    ),
                                  ),*/
                                  SizedBox(width: 10,),
                                  Text(snapshot.data!.name,style: TextStyle(
                                    fontSize : 15,
                                    color : Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ), ),
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(child: Icon(Icons.email_outlined,color: Colors.grey)),
                                  SizedBox(width: 10,),
                                  /*Icon(Icons.message_outlined,color: Colors.grey),
                                  SizedBox(width: 10,),
                                  Icon(Icons.phone_outlined,color: Colors.grey),*/
                                ],
                              )
                            ],
                          );
                        }
                      }
                    }
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
                /*Text("SIMILAR EVENTS",style: TextStyle(fontSize:15,color: Colors.white),),
                SizedBox(height: 10,),
                 Container(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: similarEventList.length,
                    itemBuilder: (BuildContext context, int index){
                      return EventCard(similarEventList[index], "user_view");
                    },
                  ),
                ),*/
               /* Container(
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
                ),*/
                SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    if(ticket==0){
                      showFailuresDailog("Please select some tickets",context);
                    }
                    else{
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => PaymentScreen(widget.event,ticketsList[currentIndex],ticket,total)));
                      //showSuccessDailog("Your tickets has been booked", context);
                    }


                  },
                  child:  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10,0,10,20),
                    decoration: BoxDecoration(
                        color: primary,
                    ),
                    alignment: Alignment.center,
                    child: Text("BOOK TICKETS",style: TextStyle(fontSize:18,fontWeight: FontWeight.w300,color: Colors.white),),
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


              ],
            ),
          ),



        ],
      ),
    );
  }
}
