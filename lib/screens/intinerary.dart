
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weweyou/model/itinerary_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/create_itinerary.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/widgets/event_card.dart';
import 'package:weweyou/widgets/itinenary_card.dart';

class ItineraryList extends StatefulWidget {
  const ItineraryList({Key? key}) : super(key: key);

  @override
  _ItineraryListState createState() => _ItineraryListState();
}

class _ItineraryListState extends State<ItineraryList> {

  Future<List<Itinerary>> getDocuments(apiToken) async {

    List<Itinerary> itineraryList=[];
    var response= await Dio().get('$apiUrl/api/get/allitineraryevets',
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
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);

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
                            return  ItineraryCard(snapshot.data![index],"user_view");
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
