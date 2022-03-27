import 'package:flutter/material.dart';

import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:weweyou/screens/news_detail.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  final PageController controller = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.3,
            child: Stack(
              children: [
                PageView(
                  onPageChanged: (int index) {
                    _currentPageNotifier.value = index;
                  },
                  scrollDirection: Axis.horizontal,
                  controller: controller,
                  children: <Widget>[
                    Container(
                      color: Colors.blue,
                      child: Image.asset("assets/images/concert.png",fit: BoxFit.cover,),
                    ),
                    Container(
                      child: Image.asset("assets/images/concert.png",fit: BoxFit.cover,),
                    ),
                    Container(
                      child: Image.asset("assets/images/concert.png",fit: BoxFit.cover,),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0,30,10,0),
                    child: Icon(Icons.search,color: Colors.white,)
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, MediaQuery.of(context).size.height*0.18, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("#Hashtag #Hashtag",style: TextStyle(fontSize:12,color: Colors.white),),
                      SizedBox(height: 5,),
                      Text("Highlighted News Title",style: TextStyle(fontSize:20,color: Colors.white),),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: CirclePageIndicator(
                      dotColor: Colors.grey,
                      size: 5,
                      selectedSize: 5,
                      selectedDotColor: Colors.white,
                      itemCount: 3,
                      currentPageNotifier: _currentPageNotifier,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (BuildContext context,int index){
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NewDetail()));
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 130,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: AssetImage("assets/images/rave.png"),
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("New Title",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w300)),
                              SizedBox(height: 50,),
                              Text("10 Oct, 2021",style: TextStyle(color: Colors.grey,fontSize: 12),)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
