import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:weweyou/utils/constants.dart';
class SimpleAppBar extends StatefulWidget {
  String title;

  SimpleAppBar(this.title);

  @override
  _SimpleAppBarState createState() => _SimpleAppBarState();
}

class _SimpleAppBarState extends State<SimpleAppBar> {

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      decoration: BoxDecoration(
        gradient: colorGradient
      ),
      padding: EdgeInsets.only(top: statusBarHeight),
      height:  AppBar().preferredSize.height+statusBarHeight,
      alignment: Alignment.center,
      child: Text(widget.title,style: TextStyle(color: Colors.white),),
    );
  }
}

