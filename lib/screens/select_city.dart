import 'package:flutter/material.dart';

import 'package:weweyou/screens/home.dart';
import 'package:weweyou/utils/constants.dart';
class SelectCity extends StatefulWidget {
  const SelectCity({Key? key}) : super(key: key);

  @override
  _SelectCityState createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width/1.4;
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
              Text("Select City",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),)
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
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 10,),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Icon(Icons.search),
                            SizedBox(width: 10,),
                            Text("Search City")
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                              gridDelegate:  SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: (itemWidth / itemHeight),

                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                              itemCount: 3,
                              itemBuilder: (BuildContext ctx, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage("assets/images/city.png"),
                                                fit: BoxFit.cover
                                            ),
                                            borderRadius: BorderRadius.circular(15)),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text("City Name",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color:Colors.white,),),
                                    Text("Country",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12,color: Colors.white),),
                                  ],
                                );
                              }),
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));

                      },
                      child: Container(
                          height: 50,
                          padding: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width*0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: primary
                          ),
                          alignment: Alignment.center,
                          child: Text("Let's Start",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)

                      ),
                    ),
                    ),


                ],
              ),
            ),
          )

        ],
      )
    );
  }
}
