import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:weweyou/utils/constants.dart';

class Filter extends StatefulWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  double distance=30;
  var selectRange=RangeValues(10,250);
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: statusBarHeight,right: 10),
            decoration: BoxDecoration(
                gradient: colorGradient
            ),
            height:  AppBar().preferredSize.height+statusBarHeight,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close,color: Colors.white,),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child:  Text("Clear",style: TextStyle(color: Colors.white),),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("Filter",style: TextStyle(color: Colors.white),),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("When",style: TextStyle(color: Colors.grey[700],fontSize: 16),),
                      Icon(Icons.keyboard_arrow_down_rounded)
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        height: 40,
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[300]
                        ),
                        alignment: Alignment.center,
                        child: Text("All Dates",style: TextStyle(color: Colors.grey),),
                      ),
                      Container(
                        height: 40,
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[300]
                        ),
                        alignment: Alignment.center,
                        child: Text("Today",style: TextStyle(color: Colors.grey),),
                      ),
                      Container(
                        height: 40,
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[300]
                        ),
                        alignment: Alignment.center,
                        child: Text("Tomorrow",style: TextStyle(color: Colors.grey),),
                      ),
                      Container(
                        height: 40,
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[300]
                        ),
                        alignment: Alignment.center,
                        child: Text("This Week",style: TextStyle(color: Colors.grey),),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Hashtag",style: TextStyle(color: Colors.grey[700],fontSize: 16),),
                      Icon(Icons.keyboard_arrow_down_rounded)
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        height: 40,
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[300]
                        ),
                        alignment: Alignment.center,
                        child: Text("All Hashtags",style: TextStyle(color: Colors.grey),),
                      ),
                      Container(
                        height: 40,
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[300]
                        ),
                        alignment: Alignment.center,
                        child: Text("#hashtag",style: TextStyle(color: Colors.grey),),
                      ),
                      Container(
                        height: 40,
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[300]
                        ),
                        alignment: Alignment.center,
                        child: Text("#hashtag",style: TextStyle(color: Colors.grey),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rating",style: TextStyle(color: Colors.grey[700],fontSize: 16),),

                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar(
                      initialRating: 4,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ratingWidget: RatingWidget(
                        full: Icon(Icons.star,color: primary),
                        half: Icon(Icons.star_half,color: primary),
                        empty:Icon(Icons.star,color: Colors.grey[300],),
                      ),
                      ignoreGestures: true,
                      itemSize: 40,
                      itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Distance",style: TextStyle(color: Colors.grey[700],fontSize: 16),),
                      SizedBox(width: 10,),
                      Text("${distance.toInt()} mil",style: TextStyle(color: primary,fontSize: 16),),

                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Slider(
                    value: distance,
                    max: 50,
                    min: 0,
                    onChanged: (value){
                      setState(() {
                        distance=value;
                      });
                    }
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Price",style: TextStyle(color: Colors.grey[700],fontSize: 16),),
                      SizedBox(width: 10,),
                      Text("\$${selectRange.start.toInt()} - \$${selectRange.end.toInt()}",style: TextStyle(color: primary,fontSize: 16),),

                    ],
                  ),
                ),
                SizedBox(height: 10,),
                RangeSlider(
                    values: selectRange,
                    max: 1000,
                    min: 0,
                    onChanged: (value){
                      setState(() {
                        selectRange=value;
                      });
                    }
                ),
                SizedBox(height: 10,),
                ListTile(
                  leading: Checkbox(
                    value: false,
                      onChanged: (value){
                        setState(() {
                        });
                      }
                  ),
                  title: Text("Only Free Events"),
                ),
                SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                  },
                  child:  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10,0,10,20),
                    decoration: BoxDecoration(
                        gradient: colorGradient,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    alignment: Alignment.center,
                    child: Text("SHOW 100+ EVENTS",style: TextStyle(fontSize:18,fontWeight: FontWeight.w500,color: Colors.white),),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
