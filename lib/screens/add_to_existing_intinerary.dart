
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:weweyou/model/event_model.dart';
import 'package:weweyou/model/itinerary_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/create_itinerary.dart';
import 'package:weweyou/screens/my_profile.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/utils/custom_dailogs.dart';
import 'package:weweyou/widgets/event_card.dart';
import 'package:weweyou/widgets/itinenary_card.dart';

import 'intenrary_detail.dart';

class AddToExistingItinerary extends StatefulWidget {
  int eventId;

  AddToExistingItinerary(this.eventId);

  @override
  _AddToExistingItineraryState createState() => _AddToExistingItineraryState();
}

class _AddToExistingItineraryState extends State<AddToExistingItinerary> {
  Future<List<Itinerary>> getDocuments(apiToken) async {
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
  Future<List<EventModel>> getEvents(List list) async {
    List<EventModel> eventList=[];
    return eventList;

  }
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    final provider = Provider.of<UserDataProvider>(context, listen: false);

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
              Text("Itinerary",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),)
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
              child: FutureBuilder<List<Itinerary>>(
                  future: getDocuments(provider.userData!.apitoken),
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
                                pr.show(max: 100, msg: "Adding to itinerary",barrierDismissible: true);

                                Dio dio = new Dio();
                                FormData formdata = new FormData();
                                formdata = FormData.fromMap({
                                  'itinerary_id': snapshot.data![index].id,
                                  'event_id': widget.eventId,

                                });
                                var response= await dio.post(
                                    '$apiUrl/api/Add/EventExistingItinerary',
                                    data: formdata, options: Options(
                                    headers: {
                                      "apitoken": provider.userData!.apitoken
                                    },
                                    method: 'POST',
                                    responseType: ResponseType.json // or ResponseType.JSON
                                )
                                );
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
                                        child: Text("${snapshot.data![index].evants[0].startDate}-${snapshot.data![index].evants[snapshot.data![index].evants.length-1].startDate}",style: TextStyle(color: Colors.white,fontSize:15,fontWeight: FontWeight.w500),),
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
                                                        child : Center(child : Text("${snapshot.data![index].evants[0].startDate}",style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10
                                                        ),))
                                                    ),
                                                    Container(
                                                      width: width*0.25,
                                                      padding: const EdgeInsets.all(6.0),
                                                      child: Text(snapshot.data![index].evants[0].address,maxLines: 1,style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10
                                                      ),),
                                                    )
                                                  ],
                                                ),


                                                Container(
                                                  height : 120,
                                                  width: double.infinity,
                                                  child: Image.network(snapshot.data![index].evants[0].images!,fit: BoxFit.cover,),
                                                ),
                                                Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(5),
                                                    alignment: Alignment.center,
                                                    color : Colors.white.withOpacity(0.1),
                                                    child: Text(
                                                      snapshot.data![index].evants[0].title,
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
                                            child: snapshot.data![index].evants.length>=2?
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.all(6),
                                                        width: width*0.15,
                                                        color: primary,
                                                        child : Center(child : Text("${snapshot.data![index].evants[1].startDate}",style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10
                                                        ),))
                                                    ),
                                                    Container(
                                                      width: width*0.25,
                                                      padding: const EdgeInsets.all(6.0),
                                                      child: Text(snapshot.data![index].evants[1].address,maxLines: 1,style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10
                                                      ),),
                                                    )
                                                  ],
                                                ),


                                                Container(
                                                  height : 120,
                                                  width: double.infinity,
                                                  child: Image.network(snapshot.data![index].evants[1].images!,fit: BoxFit.cover,),
                                                ),
                                                Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(5),
                                                    alignment: Alignment.center,
                                                    color : Colors.white.withOpacity(0.1),
                                                    child: Text(
                                                      snapshot.data![index].evants[1].title,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize  : 11,
                                                          color: Colors.white
                                                      ),
                                                    )
                                                ),
                                              ],
                                            )
                                                :Container(),
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
                                            onTap :(){
                                              Navigator.push(context, new MaterialPageRoute(
                                                  builder: (context) => ItenraryDetail(snapshot.data![index],provider.userData!.id,provider.userData!.apitoken)));
                                            },
                                            child: Center(
                                              child: Text("${snapshot.data![index].evants.length} Events" ,style: TextStyle(
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
                              ),
                            );
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
}
