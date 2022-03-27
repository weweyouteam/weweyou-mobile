import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:weweyou/model/event_model.dart';
import 'package:weweyou/model/favourite/event_favourite_model.dart';
import 'package:weweyou/model/favourite/itinerary_favourite_model.dart' as intinerary_favourite;
import 'package:weweyou/model/group_model.dart';
import 'package:weweyou/model/itinerary_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/group_screen.dart';
import 'package:weweyou/screens/intenrary_detail.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/widgets/event_card.dart';
import 'package:weweyou/widgets/itinenary_card.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primary,
      body: Column(
        children: [
          SizedBox(height: 40,),
          Row(
            children: [
              SizedBox(width: 10,),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios_rounded,color: Colors.white,),
              ),
              SizedBox(width: 10,),
              Text("Favourites",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),)
            ],
          ),
          SizedBox(height: 20,),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: lightBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)
                  )
              ),
              child: Column(
                children: [
                  Expanded(
                    child: DefaultTabController(
                        length: 3,
                        child:Column(
                          children: [
                            TabBar(
                              labelColor:primary,
                              unselectedLabelColor: Colors.white,
                              indicatorWeight: 0.5,

                              labelStyle: TextStyle(fontSize: 10),

                              tabs: [
                                Tab(text: 'EVENTS',),
                                Tab(text: 'ITINERARY'),
                                Tab(text: 'GROUPS'),
                              ],
                            ),

                            Container(
                              height: MediaQuery.of(context).size.height*0.8,

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
                                            return Center(
                                              child: Text("Something went wrong : ${snapshot.error.toString()}",style: TextStyle(color: Colors.white),),
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
                                                return EventCard(snapshot.data![index],"user_view");
                                              },
                                            );
                                          }
                                        }
                                      }
                                  ),
                                ),
                                Container(
                                  child:  FutureBuilder<List<intinerary_favourite.Data>>(
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
                                                return  InkWell(
                                                    onTap: ()async{
                                                      final ProgressDialog pr = ProgressDialog(context: context);
                                                      pr.show(max: 100, msg: "Please wait");
                                                      List<Itinerary> itineraryList=[];
                                                      var response= await Dio().get('$apiUrl/api/get/allitineraryevets',
                                                        options: Options(
                                                            headers: {
                                                              "apitoken": provider.userData!.apitoken
                                                            }
                                                        ),);
                                                      if(response.statusCode==200 && response.data['code']=="200"){
                                                        ItineraryModel model=ItineraryModel.fromJson(response.data);
                                                        model.data.forEach((element) {
                                                          if(element.id==snapshot.data![index].itineraryId)
                                                            itineraryList.add(element);
                                                        });
                                                      }
                                                      pr.close();
                                                      Navigator.push(context, new MaterialPageRoute(
                                                          builder: (context) => ItenraryDetail(itineraryList[0],provider.userData!.id,provider.userData!.apitoken)));

                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        width: width*0.9,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey.shade600.withOpacity(0.4),
                                                        ),

                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: snapshot.data![index].event.length==0?Container():Text("${snapshot.data![index].event[0].startDate}-${snapshot.data![index].event[snapshot.data![index].event.length-1].startDate}",style: TextStyle(color: Colors.white,fontSize:15,fontWeight: FontWeight.w500),),
                                                            ),

                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                Container(
                                                                  height : height*0.25,
                                                                  width : width*0.4,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                              padding: EdgeInsets.all(6),
                                                                              width: width*0.15,
                                                                              color: primary,
                                                                              child : Center(child : Text("${snapshot.data![index].event[0].startDate}",style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: 10
                                                                              ),))
                                                                          ),
                                                                          Container(
                                                                            width: width*0.25,
                                                                            padding: const EdgeInsets.all(6.0),
                                                                            child: Text(snapshot.data![index].event[0].address,maxLines: 1,style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 10
                                                                            ),),
                                                                          )
                                                                        ],
                                                                      ),


                                                                      Container(
                                                                        height : 120,
                                                                        width: double.infinity,
                                                                        child: Image.network(snapshot.data![index].event[0].images!,fit: BoxFit.cover,),
                                                                      ),
                                                                      Container(
                                                                          width: double.infinity,
                                                                          padding: EdgeInsets.all(5),
                                                                          alignment: Alignment.center,
                                                                          color : Colors.white.withOpacity(0.1),
                                                                          child: Text(
                                                                            snapshot.data![index].event[0].title,
                                                                            maxLines: 1,
                                                                            style: TextStyle(
                                                                                fontSize  : 11,
                                                                                color: Colors.white
                                                                            ),
                                                                          )
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height : height*0.25,
                                                                  width : width*0.4,
                                                                  child: snapshot.data![index].event.length>=2?Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                              padding: EdgeInsets.all(6),
                                                                              width: width*0.15,
                                                                              color: primary,
                                                                              child : Center(child : Text("${snapshot.data![index].event[1].startDate}",style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: 10
                                                                              ),))
                                                                          ),
                                                                          Container(
                                                                            width: width*0.25,
                                                                            padding: const EdgeInsets.all(6.0),
                                                                            child: Text(snapshot.data![index].event[1].address,maxLines: 1,style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 10
                                                                            ),),
                                                                          )
                                                                        ],
                                                                      ),


                                                                      Container(
                                                                        height : 120,
                                                                        width: double.infinity,
                                                                        child: Image.network(snapshot.data![index].event[1].images!,fit: BoxFit.cover,),
                                                                      ),
                                                                      Container(
                                                                          width: double.infinity,
                                                                          padding: EdgeInsets.all(5),
                                                                          alignment: Alignment.center,
                                                                          color : Colors.white.withOpacity(0.1),
                                                                          child: Text(
                                                                            snapshot.data![index].event[1].title,
                                                                            maxLines: 1,
                                                                            style: TextStyle(
                                                                                fontSize  : 11,
                                                                                color: Colors.white
                                                                            ),
                                                                          )
                                                                      ),
                                                                    ],
                                                                  ):Container(),
                                                                ),
                                                              ],
                                                            ),



                                                            Padding(
                                                              padding: const EdgeInsets.all(9.0),
                                                              child: Container(
                                                                height: height*0.045,
                                                                width: width*0.3,
                                                                color: primary,
                                                                child: InkWell(
                                                                  onTap :(){},
                                                                  child: Center(
                                                                    child: Text("${snapshot.data![index].event.length} Events" ,style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w300
                                                                    ), ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )




                                                          ],
                                                        ),
                                                      ),
                                                    )
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
                                            print("itinerary error ${snapshot.error.toString()}");
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
                                              shrinkWrap: true,
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (BuildContext context, int index){
                                                return  ListTile(
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GroupScreen(snapshot.data![index],provider.userData!.id,provider.userData!.apitoken)));
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
            ),
          )

        ],
      ),
    );
  }
  Future<List<Event>> getEvents(userId,apiToken) async {
    var response= await Dio().get('$apiUrl/api/get/favorite/events',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),);
    print("repsonse ${response.statusCode} ${response.data}");
    List<Event> events=[];
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        EventFavoriteModel eventModel=EventFavoriteModel.fromJson(response.data);
        eventModel.data.forEach((element) {
          if(element.event.is_active==1 && element.event.userId!=userId)
            events.add(element.event);
        });
      }
    }
    return events;

  }
  Future<List<Group>> getGroups(userId,apiToken) async {
    var response= await Dio().get('$apiUrl/api/get/favorite/groups',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),);
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
  


  Future<List<intinerary_favourite.Data>> getItineraries(userId,apiToken) async {

    List<intinerary_favourite.Data> itineraryList=[];
    var response= await Dio().get('$apiUrl/api/get/favorite/itinerary',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),);
    print("repsonse ${response.statusCode} ${response.data}");
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        intinerary_favourite.ItineraryFavouriteModel model=intinerary_favourite.ItineraryFavouriteModel.fromJson(response.data);
        model.data.forEach((element) {
          itineraryList.add(element);
        });
      }
    }
    return itineraryList;

  }
}
