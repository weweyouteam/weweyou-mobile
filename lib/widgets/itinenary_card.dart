
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:weweyou/model/event_model.dart';
import 'package:weweyou/model/itinerary_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/event_detail.dart';
import 'package:weweyou/screens/intenrary_detail.dart';
import 'package:weweyou/utils/constants.dart';

class ItineraryCard extends StatefulWidget {
  Itinerary itineraryModel;
  String route;

  ItineraryCard(this.itineraryModel,this.route);

  @override
  _ItineraryCardState createState() => _ItineraryCardState();
}

class _ItineraryCardState extends State<ItineraryCard> {
  






  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    return InkWell(
        onTap: (){
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => ItenraryDetail(widget.itineraryModel,provider.userData!.id,provider.userData!.apitoken)));

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
                  child: widget.itineraryModel.evants.length==0?Container():Text("${widget.itineraryModel.evants[0].startDate}-${widget.itineraryModel.evants[widget.itineraryModel.evants.length-1].startDate}",style: TextStyle(color: Colors.white,fontSize:15,fontWeight: FontWeight.w500),),
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
                                  child : Center(child : Text("${widget.itineraryModel.evants[0].startDate}",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),))
                              ),
                              Container(
                                width: width*0.25,
                                padding: const EdgeInsets.all(6.0),
                                child: Text(widget.itineraryModel.evants[0].address,maxLines: 1,style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10
                                ),),
                              )
                            ],
                          ),


                          Container(
                            height : 120,
                            width: double.infinity,
                            child: Image.network(widget.itineraryModel.evants[0].images!,fit: BoxFit.cover,),
                          ),
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              color : Colors.white.withOpacity(0.1),
                              child: Text(
                                widget.itineraryModel.evants[0].title,
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
                      child: widget.itineraryModel.evants.length>=2?Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(6),
                                  width: width*0.15,
                                  color: primary,
                                  child : Center(child : Text("${widget.itineraryModel.evants[1].startDate}",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),))
                              ),
                              Container(
                                width: width*0.25,
                                padding: const EdgeInsets.all(6.0),
                                child: Text(widget.itineraryModel.evants[1].address,maxLines: 1,style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10
                                ),),
                              )
                            ],
                          ),


                          Container(
                            height : 120,
                            width: double.infinity,
                            child: Image.network(widget.itineraryModel.evants[1].images!,fit: BoxFit.cover,),
                          ),
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              color : Colors.white.withOpacity(0.1),
                              child: Text(
                                widget.itineraryModel.evants[1].title,
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
                        child: Text("${widget.itineraryModel.evants.length} Events" ,style: TextStyle(
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
  }
}
