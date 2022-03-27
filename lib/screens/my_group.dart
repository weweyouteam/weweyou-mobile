import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:weweyou/model/event_model.dart';
import 'package:weweyou/model/group_model.dart';
import 'package:weweyou/model/user_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/edit_group.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/utils/custom_dailogs.dart';
import 'package:weweyou/widgets/event_card.dart';


import 'my_profile.dart';
class MyGroup extends StatefulWidget {
  GroupModel groupModel;

  MyGroup(this.groupModel);

  @override
  _MyGroupState createState() => _MyGroupState();
}

class _MyGroupState extends State<MyGroup> {
  /*List<Comments> comments=[];
  getComments(List list) async {
    var db = await mongo.Db.create(connString);
    await db.open();
    await db.collection("comments").find().forEach((user) {
      Comments model=Comments.fromMap(user);
      list.forEach((element) {
        if(element==model.id){
          setState(() {
            comments.add(Comments.fromMap(user));
          });
        }
      });

    });
    setState(() {
      isCommentsLoaded=true;
      comments.sort((a, b) => a.dateInMilli.compareTo(b.dateInMilli));
      comments=comments.reversed.toList();
    });
    db.close();

  }
  List<UserModel> memberList=[];
  getMembers(List list) async {
    var db = await mongo.Db.create(connString);
    await db.open();
    await db.collection("users").find().forEach((user) {
      EventModel model=EventModel.fromMap(user);
      list.forEach((element) {
        if(element==model.id){
          setState(() {
            //memberList.add(UserModel.fromMap(user));
          });
        }
      });

    });
    setState(() {
      isMembersLoaded=true;
    });
    db.close();

  }
  List<Comments> activeComments=[];
  bool isEventLoaded=false;
  bool isMembersLoaded=false;
  bool isOrganizerLoaded=false;
  bool isCommentsLoaded=false;

  List<Event> eventList=[];
  final _formKey = GlobalKey<FormState>();
  var commentController=TextEditingController();
  @override
  void initState() {
    super.initState();

    getMembers(widget.groupModel.membersId);
    getComments(widget.groupModel.comments);
    getEvents(widget.groupModel.eventIds);
  }
  getEvents(List list) async {
    var db = await mongo.Db.create(connString);
    await db.open();
    await db.collection("events").find().forEach((user) {
     *//* EventModel model=Event.fromMap(user);
      list.forEach((element) {
        if(element==model.id){
          setState(() {
            eventList.add(Event.fromMap(user));
          });
        }
      });*//*

    });
    setState(() {
      isEventLoaded=true;
    });
    db.close();

  }*/
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return /*Scaffold(
      backgroundColor: lightBackgroundColor,
      body: Stack(
        children: [
          Column(
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
                        Icon(Icons.share,color: Colors.white,),

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
                    Text(widget.groupModel.title,style: TextStyle(fontSize:20,color: Colors.white),),
                    SizedBox(height: 5,),
                    Text(widget.groupModel.description,style: TextStyle(fontSize:12,color: Colors.white,fontWeight: FontWeight.w300),),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Icons.people,size: 20,color: Colors.white),
                        SizedBox(width: 5,),
                        Text("Members",style: TextStyle(color: Colors.white),),
                      ],
                    ),
                    SizedBox(height: 10,),
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
                                                if (_formKey.currentState!.validate()){
                                                  final provider = Provider.of<UserDataProvider>(context, listen: false);
                                                  String cId="gc${DateTime.now().millisecondsSinceEpoch}";
                                                  final ProgressDialog pr = ProgressDialog(context: context);
                                                  pr.show(max: 100, msg: "Commenting");
                                                  var db = await mongo.Db.create(connString);
                                                  await db.open();
                                                  var coll = db.collection('comments');

                                                  coll.insertOne({
                                                    'id':cId,
                                                    'commenterName': "provider.userData!.name",
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
                                                            "0",//provider.userData!.id,
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
                                                }
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
                                                Row(
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
                                                ),
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
                                                Row(
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
                                                ),
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
                          builder: (context) => EditGroup(widget.groupModel)));
                    },
                    child: Icon(Icons.edit,color: Colors.white,),
                  ),
                  InkWell(
                    onTap: (){

                    },
                    child: Icon(Icons.calendar_today_rounded,color: Colors.white,),
                  ),
                  InkWell(
                    onTap: (){
                      _showDeleteDialog();
                    },
                    child: Icon(Icons.delete,color: Colors.white,),
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );*/Container();
  }
  /*Future<void> _showDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Group'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete this group?'),
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
              onPressed: () {

                deleteEvent(widget.groupModel.id).then((value){
                  Navigator.pushReplacement(context, new MaterialPageRoute(
                      builder: (context) => MyProfile()));
                });

              },
            ),
          ],
        );
      },
    );
  }
  Future deleteEvent(String groupId)async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Please Wait");
    var db = await mongo.Db.create(connString);
    await db.open();
    await db.collection("groups").deleteOne({"id": groupId});
    db.close();
    pr.close();
  }*/
}
