import 'package:flutter/material.dart';

import 'package:weweyou/screens/payment_screen.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/utils/custom_dailogs.dart';

class GetTickets extends StatefulWidget {
  const GetTickets({Key? key}) : super(key: key);

  @override
  _GetTicketsState createState() => _GetTicketsState();
}

class _GetTicketsState extends State<GetTickets> {
  int price=20;
  int ticket=0;
  int total=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20,),
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
                Text("Tickets",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),)
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
                child: ListView(
                  children: [
                    SizedBox(height: 20,),
                    Text("Select Tickets",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),),
                    SizedBox(height: 20,),
                    Card(
                      elevation: 10,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 100,
                              color: primary,
                              alignment: Alignment.center,
                              child: Text(ticket.toString(),style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.w900),),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Event Name",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),),
                                  SizedBox(height: 3,),
                                  Text("29 Oct, 2021",style: TextStyle(color: Colors.grey,fontSize: 10,fontWeight: FontWeight.w300),),
                                  SizedBox(height: 3,),
                                  Text("\$$price X $ticket = $total",style: TextStyle(color: primary,fontSize: 10,fontWeight: FontWeight.w300),)
                                ],
                              ),
                            ),

                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        ticket++;
                                        total=price*ticket;
                                      });
                                    },
                                    child: Icon(Icons.add,color: primary,size: 40,),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      if(ticket>0)
                                      setState(() {
                                        ticket--;
                                        total=price*ticket;
                                      });
                                    },
                                    child: Icon(Icons.remove,color: primary,size: 40,),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        /*Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => PaymentScreen()));*/
                        /*CustomDailog custom=new CustomDailog();
                        custom.showSuccessDailog("Your tickets has been booked", context);*/
                      },
                      child:  Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(10,0,10,20),
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        alignment: Alignment.center,
                        child: Text("BOOK TICKETS",style: TextStyle(fontSize:18,fontWeight: FontWeight.w500,color: Colors.white),),
                      ),
                    ),
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
