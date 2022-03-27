
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:weweyou/model/event_model.dart';
import 'package:weweyou/model/group_model.dart';
import 'package:weweyou/model/itinerary_model.dart';
import 'package:weweyou/model/my_ticket_model.dart';
import 'package:weweyou/model/ticket_model.dart';
import 'package:weweyou/model/user_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/my_group.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/widgets/event_card.dart';
import 'package:weweyou/widgets/itinenary_card.dart';
import 'group_screen.dart';
import 'notifications.dart';

class MyProfile extends StatefulWidget {
  int index;


  MyProfile(this.index);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> with SingleTickerProviderStateMixin {
  late TabController _tabController;


  @override
  Widget build(BuildContext context) {
    var height  = MediaQuery.of(context).size.height;
    var width  = MediaQuery.of(context).size.width;
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.4,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*0.25,
                    decoration: BoxDecoration(
                      color: primary,

                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10,30,10,30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(onTap: (){
                            Navigator.pop(context);
                          },child: Icon(Icons.arrow_back,color: Colors.white,)),
                          InkWell(onTap: (){
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => NotificationList()));
                          },child: Icon(Icons.notifications,color: Colors.white,)),

                          //Icon(Icons.settings,color: Colors.white,),

                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, MediaQuery.of(context).size.height*0.1, 10, 10),
                    child: Stack(
                      children: [
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          height: MediaQuery.of(context).size.height*0.6,
                          margin: EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              SizedBox(height: 50,),
                              Text(provider.userData!.apitoken,style: TextStyle(color:Colors.white,fontWeight: FontWeight.w300,fontSize: 16),),
                              SizedBox(height: 5,),
                              Text(provider.userData!.email,style: TextStyle(color:Colors.white,fontWeight: FontWeight.w300,fontSize: 13),),
                              Divider(color: Colors.white,),
                              FutureBuilder<List<int>>(
                                  future: getUserDetail(provider.userData!.id,provider.userData!.apitoken),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {

                                      return Center(child: CupertinoActivityIndicator(),);
                                    }
                                    else {
                                      if (snapshot.hasError) {
                                        // Return error
                                        print("event error ${snapshot.error.toString()}");
                                        return Container();
                                      }

                                      else {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              height :  height *0.06,
                                              width :  width *0.25,
                                              color : Colors.black54,

                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("Events",style: TextStyle(
                                                    color : Colors.orange,
                                                    fontSize: 10,
                                                  ),),Center(
                                                    child: Text(snapshot.data![0].toString(),style: TextStyle(
                                                      color : Colors.orange,
                                                      fontSize: 16,
                                                    ),),
                                                  ),

                                                ],
                                              ),

                                            ),Container(
                                              height :  height *0.06,
                                              width :  width *0.25,
                                              color : Colors.black54,

                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("Groups",style: TextStyle(
                                                    color : Colors.orange.shade800,
                                                    fontSize: 10,
                                                  ),),Center(
                                                    child: Text(snapshot.data![1].toString(),style: TextStyle(
                                                      color : Colors.orange.shade800,
                                                      fontSize: 16,
                                                    ),),
                                                  ),

                                                ],
                                              ),

                                            ),Container(
                                              height :  height *0.06,
                                              width :  width *0.25,
                                              color : Colors.black54,

                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("Followers",style: TextStyle(
                                                    color : Colors.red.shade900,
                                                    fontSize: 10,
                                                  ),),Center(
                                                    child: Text(snapshot.data![2].toString(),style: TextStyle(
                                                      color : Colors.red.shade900,
                                                      fontSize: 16,
                                                    ),),
                                                  ),

                                                ],
                                              ),

                                            ),
                                          ],
                                        );
                                      }
                                    }
                                  }
                              ),

/*
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  alignment: Alignment.center,
                                  child: Text("johndoe@gmail.com",style: TextStyle(color: Colors.grey),),
                                ),
                                SizedBox(height: 3,),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  alignment: Alignment.center,
                                  child: Text("+9290078601",style: TextStyle(color: Colors.grey),),
                                ),
                              ],
                            ),
*/
                              SizedBox(height: 10,),


                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                border: Border.all(color: Colors.white,style: BorderStyle.solid,width: 2),
                                image: DecorationImage(
                                    image: NetworkImage(provider.userData!.avatar=="none"?imagePath:"$apiUrl/${provider.userData!.avatar}"),
                                    fit: BoxFit.cover
                                ),
                                shape: BoxShape.circle
                            ),
                          ),
                        )
                      ],
                    ),
                  ),


                ],
              ),
            ),
            Expanded(
              child: DefaultTabController(
                  length: 4,
                  child:Column(
                    children: [
                      TabBar(
                        //controller: _tabController,
                        labelColor:primary,
                        unselectedLabelColor: Colors.white,
                        indicatorWeight: 0.5,

                        labelStyle: TextStyle(fontSize: 10),

                        tabs: [
                          Tab(text: 'EVENTS',),
                          Tab(text: 'ITINERARY'),
                          Tab(text: 'TICKETS'),
                          Tab(text: 'GROUPS'),
                        ],
                      ),

                      Container(
                        height: MediaQuery.of(context).size.height*0.49,

                        child: TabBarView(children: <Widget>[
                          Container(
                            child:  FutureBuilder<List<Event>>(
                                future: getEvents(provider.userData!.id,provider.userData!.apitoken),
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
                                        child: Text("Something went wrong ${snapshot.error.toString()}"),
                                      );
                                    }
                                    else if(snapshot.data!.length==0){
                                      return Center(
                                        child: Text("No Events",style: TextStyle(color: Colors.white),),
                                      );
                                    }
                                    else {
                                      return ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (BuildContext context, int index){
                                          //print("id idddd ${snapshot.data![index].id}");
                                          return EventCard(snapshot.data![index],"my_view");
                                        },
                                      );
                                    }
                                  }
                                }
                            ),
                          ),
                          Container(
                            child:  FutureBuilder<List<Itinerary>>(
                                future: getItineraries(provider.userData!.id,provider.userData!.apitoken),
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
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (BuildContext context, int index){
                                          return  ItineraryCard(snapshot.data![index],"my_view");
                                        },
                                      );
                                    }
                                  }
                                }
                            ),
                          ),

                          Container(
                            child: FutureBuilder<List<TicketData>>(
                                future: getPurchasedTickets(provider.userData!.apitoken),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {

                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  else {
                                    if (snapshot.hasError) {
                                      // Return error
                                      print("ticket error ${snapshot.error.toString()}");
                                      return Center(
                                        child: Text("Something went wrong"),
                                      );
                                    }
                                    else if(snapshot.data!.length==0){
                                      return Center(
                                        child: Text("No Tickets",style: TextStyle(color: Colors.white),),
                                      );
                                    }
                                    else {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (BuildContext context,int index){
                                          return ListTile(
                                            /*onTap: (){
                                              //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GroupScreen()));

                                            },*/

                                            title: Text(snapshot.data![index].ticket.title,style: TextStyle(color: Colors.white)),
                                            subtitle: Text("\$${snapshot.data![index].quantity.toDouble()*(double.parse(snapshot.data![index].ticket.price))}",style: TextStyle(color: Colors.white),),
                                            trailing: Container(
                                              width: 50,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Image.asset("assets/images/ticket.png",height: 20,color: Colors.white,),
                                                  SizedBox(width: 3,),
                                                  Text(snapshot.data![index].quantity.toString(),style: TextStyle(color: Colors.white)),
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
                          Container(
                            child:  FutureBuilder<List<Group>>(
                                future: getGroups(provider.userData!.id,provider.userData!.apitoken),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {

                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  else {
                                    if (snapshot.hasError) {
                                      // Return error
                                      print("group error ${snapshot.error.toString()}");
                                      return Center(
                                        child: Text("Something went wrong"),
                                      );
                                    }
                                    else if(snapshot.data!.length==0){
                                      return Center(
                                        child: Text("No Groups",style: TextStyle(color: Colors.white),),
                                      );
                                    }
                                    else {
                                      return ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (BuildContext context,int index){
                                          return ListTile(
                                            onTap: (){
                                              //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyGroup(snapshot.data![index])));

                                            },
                                            leading: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(snapshot.data![index].image),
                                                    fit: BoxFit.cover
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              height: 50,
                                              width: 50,
                                            ),
                                            title: Text(snapshot.data![index].name,style: TextStyle(color: Colors.white)),
                                            //subtitle: Text("${snapshot.data![index].membersId.length} members",style: TextStyle(color: Colors.white),),

                                          );
                                        },
                                      );
                                    }
                                  }
                                }
                            ),
                          ),


                        ]),
                      )

                    ],

                  )
              ),
            )
          ],
        ),
      )
    );
  }
  Future<List<Event>> getEvents(int id,apiToken) async {
    print("apitoken $apiToken");
    var response= await Dio().get(
      '$apiUrl/api/userevents',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),
    );
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
  Future<List<TicketData>> getPurchasedTickets(apiToken) async {

    List<TicketData> tickets=[];
    var response= await Dio().get('$apiUrl/api/my/bookedtickets',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),
    );
    print("ticekt repsonse ${response.statusCode} ${response.data}");
    if(response.statusCode==200 && response.data['code']=="200"){
      MyTicketModel ticketModel=MyTicketModel.fromJson(response.data);
      ticketModel.data.forEach((element) {
        tickets.add(element);
      });
    }
    return tickets;

  }
  Future<List<Group>> getGroups(int id, apiToken) async {
    var response= await Dio().get(
        '$apiUrl/api/usergroups',
      options: Options(
        headers: {
          "apitoken": apiToken
        }
      ),
    );
    print("repsonse ${response.statusCode} ${response.data}");
    List<Group> groups=[];
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        GroupModel groupModel=GroupModel.fromJson(response.data);
        groupModel.data.forEach((element) {
          groups.add(element);
        });
      }
    }
    return groups;

  }
  Future<List<int>> getUserDetail(int uid,apiToken) async {
    print("apitoken $apiToken");
    var response= await Dio().get(
      '$apiUrl/api/userprofile',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),
    );
    List<int> values=[0,0,0];
    print("repsonse ${response.statusCode} ${response.data}");
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        UserProfile userProfile=UserProfile.fromJson(response.data);
        values[0]=userProfile.event;
        values[1]=userProfile.group;
        values[2]=userProfile.following;

      }
    }
    return values;

  }
  Future<List<Itinerary>> getItineraries(int id,apiToken) async {

    List<Itinerary> itineraryList=[];
    var response= await Dio().get('$apiUrl/api/get/myitineraryevets',
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



}
