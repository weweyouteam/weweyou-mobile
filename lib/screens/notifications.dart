import 'package:flutter/material.dart';

import 'package:weweyou/screens/create_event.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/widgets/event_card.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    var margin=MediaQuery.of(context).size.width*0.05;
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
              Text("Notifications",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),)
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
              child: Center(child: Text("No Notifications",style: TextStyle(color: Colors.white),),)/*ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context,int index){
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: primary,
                      child: Icon(Icons.notifications,color: Colors.white,),

                    ),
                    title: Text("Notification Title",style: TextStyle(color: Colors.white),),
                    subtitle: Text("Here is the notification body",style: TextStyle(color: Colors.white),),
                  );
                },
              ),*/
            ),
          )
        ],
      ),
    );
  }
}
