import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:weweyou/utils/constants.dart';
typedef void MyCallback();
class CustomAppBar extends StatefulWidget {
  final MyCallback callback;
  String title;

  CustomAppBar(this.callback, this.title);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
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
              icon: Icon(Icons.arrow_back_sharp,color: Colors.white,),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(widget.title,style: TextStyle(color: Colors.white),),
          )
        ],
      ),
    );
  }
}

