
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:weweyou/model/event_model.dart';
import 'package:weweyou/model/favourite_model.dart';
import 'package:weweyou/model/group_comment_model.dart';
import 'package:weweyou/model/group_model.dart';
import 'package:weweyou/model/user_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/utils/custom_dailogs.dart';
import 'package:weweyou/widgets/event_card.dart';

class GroupScreen extends StatefulWidget {
  Group groupModel;int userId;String apiToken;

  GroupScreen(this.groupModel,this.userId,this.apiToken);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {

  final _formKey = GlobalKey<FormState>();
  var commentController=TextEditingController();

  //favourites
  bool addingToFavourite=false;
  bool isFavourite=false;
  Future addToFavourite(String userId)async{
    String favId="fav${widget.groupModel.id}$userId";
    setState(() {
      addingToFavourite=true;
    });
    /*var db = await mongo.Db.create(connString);
    await db.open();
    var coll = db.collection('favourites');
    coll.insertOne({
      'id':favId,
      'type':"group",
      'userId': userId,
      'typeId': widget.groupModel.id,
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
    });*/
  }
  Future removeFavourite(String userId)async{
    String favId="fav${widget.groupModel.id}$userId";
    setState(() {
      addingToFavourite=true;
    });
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
  Future<bool> checkForFavourite(String userId)async{
    setState(() {
      addingToFavourite=true;
    });
    /*String favId="fav${widget.groupModel.id}$userId";
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
    }*/
    return isFavourite;
  }




  @override
  void initState() {
    super.initState();
    getMembers(widget.apiToken);
    /*checkForFavourite(widget.userId);

    getComments(widget.groupModel.comments);
    getEvents(widget.groupModel.eventIds);
    getOrganizerDetail(widget.groupModel.organizerId);*/
  }
  bool isEventLoaded=false;
  bool isMembersLoaded=false;
  bool isOrganizerLoaded=false;
  bool isCommentsLoaded=false;

  List<Event> eventList=[];
  List<GroupComment> activeComments=[];

  getEvents(List list) async {

    setState(() {
      isEventLoaded=true;
    });

  }
  UserModel? organizer;
  Future<UserInformation> getOrganizerDetail(int organizorId) async {
    var response= await Dio().get('$apiUrl/api/getUser?user_id=${widget.userId}');
    print("repsonse ${response.statusCode} ${response.data}");
    return UserInformationModel.fromJson(response.data).data;
  }
  List memberList=[];

  getMembers(apiToken) async {

    var response= await Dio().get('$apiUrl/api/group/members?id=${widget.groupModel.id}',
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
  List<GroupComment> comments=[];
  getComments(apiToken) async {
    var response= await Dio().get('$apiUrl/api/group/comments?group_id=${widget.groupModel.id}',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),);
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        comments.add(response.data['data']);
      }
    }
    setState(() {
      isCommentsLoaded=true;
      /*comments.sort((a, b) => a.dateInMilli.compareTo(b.dateInMilli));
      comments=comments.reversed.toList();*/
    });

  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 30, 10, 0,),
            height: MediaQuery.of(context).size.height*0.25,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.groupModel.image),
                    fit: BoxFit.cover
                )
            ),
            alignment: Alignment.topCenter,
            child: Row(
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.groupModel.name,style: TextStyle(fontSize:20,color: Colors.white),),
                SizedBox(height: 5,),
                Text(widget.groupModel.description,style: TextStyle(fontSize:12,color: Colors.white,fontWeight: FontWeight.w300),),
                SizedBox(height: 10,),
                Text("Organizer",style: TextStyle(fontSize:15,color: Colors.white,fontWeight: FontWeight.w400),),
                SizedBox(height: 10,),
                FutureBuilder<UserInformation>(
                    future: getOrganizerDetail(widget.groupModel.userId),
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
                                  Icon(Icons.email_outlined,color: Colors.grey),
                                  /*SizedBox(width: 10,),
                                  Icon(Icons.message_outlined,color: Colors.grey),
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
                Row(
                  children: [
                    Icon(Icons.people,size: 20,color: Colors.white),
                    SizedBox(width: 5,),
                    Text("Members",style: TextStyle(color: Colors.white),),
                  ],
                ),
                SizedBox(height: 10,),
                if(isMembersLoaded && memberList.length==0)
                  Text("No Members",style: TextStyle(color: Colors.white,fontSize: 12),)
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
                /*isMembersLoaded?Container(
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
                ):Center(child: CircularProgressIndicator(),)*/


              ],
            ),
          ),
          Expanded(
            child: DefaultTabController(
                length: 2,
                child:Column(
                  children: [
                    TabBar(
                      labelColor:primary,
                      unselectedLabelColor: Colors.white,
                      indicatorWeight: 1,

                      labelStyle: TextStyle(fontSize: 14),

                      tabs: [
                        Tab(text: 'EVENTS',),
                        Tab(text: 'COMMENTS'),
                      ],
                    ),

                    Container(
                      height: MediaQuery.of(context).size.height*0.42,

                      child: TabBarView(children: <Widget>[
                        isEventLoaded?ListView.builder(
                          itemCount: eventList.length,
                          itemBuilder: (BuildContext context, int index){
                            //print("id idddd ${snapshot.data![index].id}");
                            return EventCard(eventList[index],"user_view");
                          },
                        ):Center(child: CircularProgressIndicator(),),
                        isCommentsLoaded?Form(
                          key: _formKey,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TextFormField(
                                      controller: commentController,
                                      style: TextStyle(color: Colors.black),
                                      minLines: 3,
                                      maxLines: 3,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7.0),

                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7.0),
                                          borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 0.5
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7.0),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 0.5,
                                          ),
                                        ),
                                        hintText: "Enter Comment",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        filled: true,
                                        fillColor: Colors.white,
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          9, 14, 9, 9),
                                      child: Container(
                                        height: 35,
                                        width: width * 0.3,
                                        color: primary,
                                        child: InkWell(
                                          onTap: ()async{
                                            /*if (_formKey.currentState!.validate()){
                                              final provider = Provider.of<UserDataProvider>(context, listen: false);
                                              String cId="gc${DateTime.now().millisecondsSinceEpoch}";
                                              final ProgressDialog pr = ProgressDialog(context: context);
                                              pr.show(max: 100, msg: "Commenting");

                                              coll.insertOne({
                                                'id':cId,
                                                'commenterName': "name",
                                                'comment': commentController.text,
                                                'image': provider.userData!.avatar,
                                                'commenterId': provider.userData!.id,
                                                'dateTimeMilli': DateTime.now().millisecondsSinceEpoch,
                                              }).then((value) {
                                                var coll = db.collection('groups');
                                                List list=widget.groupModel.comments;
                                                list.add(cId);

                                                coll.replaceOne(
                                                    {
                                                      'id':widget.groupModel.id,
                                                    },
                                                    {
                                                      'id':widget.groupModel.id,
                                                      'title': widget.groupModel.title,
                                                      'description': widget.groupModel.description,
                                                      'image': widget.groupModel.image,
                                                      'organizerId': widget.groupModel.organizerId,
                                                      'eventIds': widget.groupModel.eventIds,
                                                      'membersId': widget.groupModel.membersId,
                                                      'comments': list,
                                                      'dateTimeMilli': widget.groupModel.dateInMilli,
                                                    }
                                                );
                                                db.close();
                                                pr.close();
                                                setState(() {
                                                  setState(() {
                                                    Comments comments=new Comments(
                                                        cId,
                                                        "provider.userData!.firstName",

                                                      provider.userData!.avatar,
                                                        commentController.text,
                                                      "provider.userData!.id",
                                                        DateTime.now().millisecondsSinceEpoch
                                                    );
                                                    activeComments.add(comments);
                                                    activeComments.sort((a, b) => a.dateInMilli.compareTo(b.dateInMilli));
                                                    activeComments=activeComments.reversed.toList();
                                                    //activeComments.reversed;
                                                  });
                                                });
                                              }).onError((error, stackTrace) {
                                                db.close();
                                                pr.close();
                                                showFailuresDailog(error.toString(), context);
                                              });
                                            }*/
                                          },
                                          child: Center(
                                            child: Text("SUBMIT", style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300
                                            ),),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                itemCount: activeComments.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context,int index){
                                  return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width : width *0.9,
                                        padding: const EdgeInsets.all(8.0),
                                        color : Colors.grey.shade700.withOpacity(0.5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            /*Row(
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: 30,

                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image:NetworkImage(activeComments[index].image=="none"?imagePath:activeComments[index].image),
                                                          fit: BoxFit.cover
                                                      ),
                                                      shape: BoxShape.circle
                                                  ),
                                                ),
                                                SizedBox(width: 10,),
                                                Text(activeComments[index].commenterName,style: TextStyle(
                                                  fontSize : 15,
                                                  color : Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                ), ),
                                              ],
                                            ),*/
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(8,15,8,0),
                                              child: Text(activeComments[index].comment ,style: TextStyle(
                                                  fontSize : 12,
                                                  color : Colors.white,
                                                  fontWeight: FontWeight.w300
                                              ), ),
                                            ),

                                          ],
                                        ),
                                      )

                                  );
                                },
                              ),

                              ListView.builder(
                                itemCount: comments.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index){
                                  //print("id idddd ${snapshot.data![index].id}");
                                  return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width : width *0.9,
                                        padding: const EdgeInsets.all(8.0),
                                        color : Colors.grey.shade700.withOpacity(0.5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            /*Row(
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: 30,

                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image:NetworkImage(comments[index].image=="none"?imagePath:comments[index].image),
                                                          fit: BoxFit.cover
                                                      ),
                                                      shape: BoxShape.circle
                                                  ),
                                                ),
                                                SizedBox(width: 10,),
                                                Text(comments[index].commenterName,style: TextStyle(
                                                  fontSize : 15,
                                                  color : Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                ), ),
                                              ],
                                            ),*/
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(8,15,8,0),
                                              child: Text(comments[index].comment ,style: TextStyle(
                                                  fontSize : 12,
                                                  color : Colors.white,
                                                  fontWeight: FontWeight.w300
                                              ), ),
                                            ),

                                          ],
                                        ),
                                      )

                                  );
                                },
                              )

                            ],
                          ),
                        ):Center(child: CircularProgressIndicator(),),

                      ]),
                    )

                  ],

                )
            ),
          )

        ],
      ),
    );
  }
}
