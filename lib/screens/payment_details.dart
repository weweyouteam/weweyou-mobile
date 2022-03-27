import 'package:flutter/material.dart';

import 'package:ticketview/ticketview.dart';
import 'package:weweyou/model/event_model.dart';
import 'package:weweyou/screens/home.dart';
import 'package:weweyou/screens/my_profile.dart';
import 'package:weweyou/utils/constants.dart';

class PaymentDetails extends StatefulWidget {
  EventModel model;

  PaymentDetails(this.model, this.tickets, this.price);

  int tickets;int price;

  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  @override
  Widget build(BuildContext context) {
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
                Text("Purchase Details",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),)
              ],
            ),
            SizedBox(height: 20,),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: lightBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)
                    )
                ),
                child: TicketView(
                  backgroundPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  backgroundColor: primary,
                  contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 0),
                  drawArc: false,
                  triangleAxis: Axis.vertical,
                  borderRadius: 6,
                  drawDivider: true,
                  trianglePos: .5,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10,),
                                Text(widget.model.title,style: TextStyle(fontSize: 22),),
                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                    Icon(Icons.access_time_rounded,size: 20,color: Colors.grey,),
                                    SizedBox(width: 5,),
                                    Text("${widget.model.startDate} ${widget.model.startTime}",style: TextStyle(color: Colors.grey[600],fontSize: 15,fontWeight: FontWeight.w300,),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Icon(Icons.access_time_rounded,size: 20,color: Colors.grey,),
                                    SizedBox(width: 5,),
                                    Text(widget.model.location,style: TextStyle(color: Colors.grey[600],fontSize: 15,fontWeight: FontWeight.w300,),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Image.asset("assets/images/ticket.png", color: Colors.grey, height: 20,width: 20,),
                                    SizedBox(width: 5,),
                                    Expanded(child: Text('${widget.tickets} Tickets - ${widget.tickets} X \$${widget.price}', style: TextStyle(color: Colors.grey[600],fontSize: 15,fontWeight: FontWeight.w300,))),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 20,right: 20),
                                  color: Colors.grey[200],
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total Price', style: TextStyle(color: primary,fontSize: 18,fontWeight: FontWeight.w400,)),
                                      Text('${widget.tickets} X \$${widget.price} = \$${widget.tickets*widget.price}', style: TextStyle(color: Colors.grey[600],fontSize: 16,fontWeight: FontWeight.w300,))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 30),
                                child: Image.asset('assets/images/qr_placeholder.png',height: 150,),

                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8),
                                child: Text('Check your email for further details', style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w300,)),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyProfile(2)));

                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top:10,left: 8.0,right: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('OKAY', style: TextStyle(color: primary,fontSize: 15,fontWeight: FontWeight.w400,)),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )


          ],
        )
    );
  }
}
