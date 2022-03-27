import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:weweyou/model/event_model.dart';
import 'package:weweyou/model/ticket_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/event_detail.dart';
import 'package:weweyou/screens/my_event_detail.dart';
import 'package:weweyou/utils/constants.dart';

class EventCard extends StatefulWidget {
  Event event;
  String path;

  EventCard(this.event,this.path);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  Future<int> getSubEvents(apiToken) async {
    List<Event> subEventList=[];
    var response= await Dio().get(
        '$apiUrl/api/getsubEvent?event_id=${widget.event.id}',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),
    );
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
    return subEventList.length;

  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    return InkWell(
      onTap: ()async{
        print("here ${widget.event.id}");
        List<Tickets> ticketsList=[];
        List<Event> subEventList=[];
        /*var response= await Dio().get('$apiUrl/api/getsubEvent?event_id=${widget.event.id}',
          options: Options(
              headers: {
                "apitoken": provider.userData!.apitoken
              }
          ),);
        if(response.statusCode==200){
          if(response.data['code']=="200"){
            EventModelClass eventModel=EventModelClass.fromJson(response.data);
            eventModel.data.forEach((element) {
              subEventList.add(element);
            });
          }
        }*/
        //////////////////////////////
        /*for(int i=58;i<77;i++){
          var response= await Dio().get('$apiUrl/api/delete/event?id=$i',
            options: Options(
                headers: {
                  "apitoken": provider.userData!.apitoken
                }
            ),
          );
          if(response.statusCode==200){
            print("${response.data['message']} ${response.data['code']}");
          }
        }*/
        print("apitoken ${provider.userData!.apitoken}");
        if(widget.path=="my_view"){
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => MyEventDetail(widget.event)));
        }
        else{

          Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (context) => EventDetail(widget.event,provider.userData!.id,provider.userData!.apitoken)));
        }

      },
      child:  Container(
        margin: EdgeInsets.fromLTRB(16,10,10,10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
                height: 200,
                width: MediaQuery.of(context).size.width*0.83,
                color: Colors.grey.shade700.withOpacity(0.5),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(7),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(widget.event.images==""?imagePath:widget.event.images!,height: 120,width: MediaQuery.of(context).size.width*0.8,fit: BoxFit.cover,),
                            SizedBox(height: 10,),
                            Text(widget.event.title,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 15),),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.event.address,style: TextStyle(fontWeight: FontWeight.w300,color: Colors.white,fontSize:10),),
                                /*Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                  //Text("Starts from \$${widget.event.price}",style: TextStyle(fontWeight: FontWeight.w300,color: Colors.white,fontSize:10),),
                                  Text("${widget.event.tickets} Tickets",style: TextStyle(fontWeight: FontWeight.w300,color: Colors.white,fontSize:10),),
                                  ],
                                ),*/
                              ],
                            )

                          ],
                        ),
                      ),
                    ),
                    /*Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        color: primary,
                        padding: EdgeInsets.all(10),
                        child: Text("${widget.event.day} ${widget.event.month}",style: TextStyle(fontSize: 10,color: Colors.white),),
                      ),
                    ),*/

                  ],
                )
            ),
            InkWell(
              child: Container(
                  color: primary,
                  padding: EdgeInsets.all(8),
                  child: RotatedBox(
                      quarterTurns: 3,
                      child:FutureBuilder<int>(
                          future: getSubEvents(provider.userData!.apitoken),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {

                              return Text("- SUBS",style: TextStyle(color: Colors.white,fontSize: 12),);
                            }
                            else {
                              if (snapshot.hasError) {
                                // Return error
                                print("sub count error ${snapshot.error.toString()}");
                                return Text("- SUBS",style: TextStyle(color: Colors.white,fontSize: 12),);
                              }
                              else {
                                return Text("${snapshot.data} SUBS",style: TextStyle(color: Colors.white,fontSize: 12),);
                              }
                            }
                          }
                      )
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
