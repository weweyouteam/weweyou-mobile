import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:weweyou/utils/constants.dart';

class NewDetail extends StatefulWidget {
  const NewDetail({Key? key}) : super(key: key);

  @override
  _NewDetailState createState() => _NewDetailState();
}

class _NewDetailState extends State<NewDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height*0.3,
            child: Stack(
              children: [
                Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height*0.3,
                  child: Image.asset("assets/images/concert.png",fit: BoxFit.cover,),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0,30,10,0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);

                            },
                            child: Icon(Icons.arrow_back,color: Colors.white,),
                          ),
                          Icon(Icons.share,color: Colors.white,)
                        ],
                      )
                  ),
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("#Hashtag #Hashtag",style: TextStyle(fontSize:12,color: Colors.grey),),
                SizedBox(height: 5,),
                Text("Highlighted News Title",style: TextStyle(fontSize:20,color: Colors.black),),
                SizedBox(height: 10,),
                Text("10 Oct, 2021",style: TextStyle(color: Colors.grey,fontSize: 12),),
                SizedBox(height: 10,),
                Text(loremIpsum,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 12),),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: 200,
                        alignment: Alignment.topRight,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: AssetImage("assets/images/slide3.png"),
                                fit: BoxFit.cover
                            )
                        ),
                        child: Icon(Icons.favorite_border,color: Colors.white,),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("#Hashtag",style: TextStyle(color: Colors.grey[600]),),
                          Row(
                            children: [
                              RatingBar(
                                initialRating: 5,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: Icon(Icons.star,color: primary),
                                  half: Icon(Icons.star_half,color: primary),
                                  empty:Icon(Icons.star_border,color: primary,),
                                ),
                                ignoreGestures: true,
                                itemSize: 20,
                                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                              SizedBox(width: 5,),
                              Text("1.3K",style: TextStyle(color: Colors.grey[900]),),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text("Quiet Clubbing VIP Heated",style: TextStyle(fontSize: 18),),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Row(
                            children: [
                              Icon(Icons.location_on_sharp,size: 15,),
                              SizedBox(width: 5,),
                              Text("W 48th Street",style: TextStyle(color: Colors.grey[600]),),
                            ],
                          ),
                          Text("10 km",style: TextStyle(color: Colors.grey[600]),),
                        ],
                      ),
                      SizedBox(height: 2,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.people,size: 15,),
                              SizedBox(width: 5,),
                              Text("1K/2K attending",style: TextStyle(color: Colors.grey[600]),),
                            ],
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Text(loremIpsum,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 12),),

              ],
            ),
          )
        ],
      ),
    );
  }
}
