
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:weweyou/model/event_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/create_event.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/widgets/event_card.dart';

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    var db;
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    double statusBarHeight = MediaQuery.of(context).padding.top;
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    var margin=MediaQuery.of(context).size.width*0.05;
    return Scaffold(

      /*floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => CreateEvent("")));
        },
        backgroundColor: primary,
        child: Icon(Icons.add,color: Colors.white,),
      ),*/
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
              Text("Events",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),)
            ],
          ),
          SizedBox(height: 20,),

          Expanded(
            child:  Container(
              decoration: BoxDecoration(
                  color: lightBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)
                  )
              ),
              child: FutureBuilder<List<Event>>(
                  future: getDocuments(provider.userData!.id),
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
                          child: Text("Something went wrong"),
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
          ),

        ],
      ),
    );
  }

  Future<List<Event>> getDocuments(int userId) async {
    var response= await Dio().get('$apiUrl/api/events');
    print("repsonse ${response.statusCode} ${response.data}");
    List<Event> events=[];
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        EventModelClass eventModel=EventModelClass.fromJson(response.data);
        eventModel.data.forEach((element) {
          if(element.is_active==1 && element.userId!=userId)
            events.add(element);
        });
      }
    }
    return events;

  }
  @override
  void initState() {
    super.initState();
  }
}
