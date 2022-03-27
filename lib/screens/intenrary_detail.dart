
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:timelines/timelines.dart';
import 'package:weweyou/model/event_model.dart';
import 'package:weweyou/model/favourite/itinerary_favourite_model.dart';
import 'package:weweyou/model/favourite_model.dart';
import 'package:weweyou/model/itinerary_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/home.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/widgets/event_card.dart';

import 'event_detail.dart';
import 'get_tickets.dart';
import 'my_profile.dart';

class ItenraryDetail extends StatefulWidget {
  Itinerary itineraryModel;int userId;String apiToken;

  ItenraryDetail(this.itineraryModel,this.userId,this.apiToken);

  @override
  _ItenraryDetailState createState() => _ItenraryDetailState();
}

class _ItenraryDetailState extends State<ItenraryDetail> {
  var dateFormat = DateFormat("dd/MM/yyyy");
  bool addingToFavourite=false;
  bool isFavourite=false;
  Future changeFavourite(apiToken)async{
    setState(() {
      addingToFavourite=true;
    });
    Dio dio = new Dio();
    FormData formdata = new FormData();

    formdata = FormData.fromMap({
      'itinerary_id':widget.itineraryModel.id,
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

  }

  @override
  void initState() {
    super.initState();
    checkFavourite(widget.userId, widget.apiToken);
  }

  Future checkFavourite(userId,apiToken) async {
    setState(() {
      addingToFavourite=true;
    });
    var response= await Dio().get('$apiUrl/api/get/favorite/itinerary',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),);
    print("repsonse ${response.statusCode} ${response.data}");
    List<int> count=[];
    if(response.statusCode==200 && response.data['code']=="200") {
      ItineraryFavouriteModel model=ItineraryFavouriteModel.fromJson(response.data);
      model.data.forEach((element) {
        if(element.itineraryId==widget.itineraryModel.id)
          count.add(element.itineraryId);
      });
    }
    if(count.length>0){
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
  /*Future addToFavourite(String userId)async{
    String favId="fav${widget.itineraryModel.id}$userId";
    setState(() {
      addingToFavourite=true;
    });
    var db = await mongo.Db.create(connString);
    await db.open();
    var coll = db.collection('favourites');
    coll.insertOne({
      'id':favId,
      'type':"itinerary",
      'userId': userId,
      'typeId': widget.itineraryModel.id,
    }).then((value) {
      db.close();
      setState(() {
        addingToFavourite=false;
      });
    }).onError((error, stackTrace) {
      db.close();
      setState(() {
        addingToFavourite=false;
      });
    });
  }
  Future removeFavourite(String userId)async{
    String favId="fav${widget.itineraryModel.id}$userId";
    setState(() {
      addingToFavourite=true;
    });
    var db = await mongo.Db.create(connString);
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
    });
  }
  Future<bool> checkForFavourite(String userId)async{
    setState(() {
      addingToFavourite=true;
    });
    String favId="fav${widget.itineraryModel.id}$userId";
    var db = await mongo.Db.create(connString);
    await db.open();
    List<FavouriteModel> favList=[];
    await db.collection("favourites").find({'id': favId}).forEach((user) {
      favList.add(FavouriteModel.fromMap(user));

    });
    db.close();
    setState(() {
      addingToFavourite=false;
    });
    if(favList.length>0){
      setState(() {
        isFavourite=true;
      });
    }
    else{
      setState(() {
        isFavourite=false;
      });
    }
    return isFavourite;
  }*/
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: primary,
      body:Stack(
        children: [
          Column(
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
                  Text("Itinerary Detail",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),)
                ],
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: lightBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
              ),
              Expanded(
                child:  Container(
                  decoration: BoxDecoration(
                      color: lightBackgroundColor,

                  ),
                  child: Timeline.tileBuilder(
                    theme: TimelineThemeData(
                      color: primary,
                    ),
                    builder: TimelineTileBuilder.fromStyle(

                      contentsAlign: ContentsAlign.alternating,
                      oppositeContentsBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${widget.itineraryModel.evants[index].startDate}',style: TextStyle(color: Colors.white),),
                              SizedBox(height: 5,),
                              Text('${widget.itineraryModel.evants[index].startTime}',style: TextStyle(color: Colors.white),),
                            ],
                          )
                      ),

                      contentsBuilder: (context, index) => Container(
                        margin: EdgeInsets.fromLTRB(16,10,0,10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                height: 190,
                                width: MediaQuery.of(context).size.width*0.4,
                                color: Colors.grey.shade700.withOpacity(0.5),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(7),
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Image.network('${widget.itineraryModel.evants[index].images!}',height: 120,width: MediaQuery.of(context).size.width*0.7,fit: BoxFit.cover,),
                                            SizedBox(height: 10,),
                                            Text("${widget.itineraryModel.evants[index].title}",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 15),),
                                            SizedBox(height: 5,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(width: MediaQuery.of(context).size.width*0.2,child: Text("${widget.itineraryModel.evants[index].address}",maxLines:1,style: TextStyle(fontWeight: FontWeight.w300,color: Colors.white,fontSize:10),)),
                                                //Text("${widget.itineraryModel.evants[index].tickets} Tickets",style: TextStyle(fontWeight: FontWeight.w300,color: Colors.white,fontSize:10),),
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
                                        child: Text("3 SUBS",style: TextStyle(fontSize: 10,color: Colors.white),),
                                      ),
                                    ),

                                  ],
                                )
                            ),


                          ],
                        ),
                      ),
                      itemCount: widget.itineraryModel.evants.length,
                    ),
                  ),

                ),
              ),
            ],
          ),
          if(widget.itineraryModel.userId==provider.userData!.id)
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
                      _showPauseDialog(widget.itineraryModel.isActive==0?false:true,provider.userData!.apitoken);
                    },
                    child: Icon(widget.itineraryModel.isActive==0?Icons.play_arrow:Icons.pause,color: Colors.white,),
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
      ),
    );
  }
  Future<void> _showDeleteDialog(apiToken) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Itinerary'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete this itinerary?'),
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

                await Dio().get('$apiUrl/api/delete/iterary?iterary_id=${widget.itineraryModel.id}',
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
          title:  Text(paused?"Resume Itinerary":'Pause Itinerary'),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text(paused?'Are you sure you want to resume this itinerary?':'Are you sure you want to pause this itinerary?'),
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
                  'itinerary_id': widget.itineraryModel.id,

                });
                var response=await dio.post(
                    '$apiUrl/api/active/pauseitinerary',
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ItenraryDetail(widget.itineraryModel,widget.userId,widget.apiToken)));
              },
            ),
          ],
        );
      },
    );
  }

}
