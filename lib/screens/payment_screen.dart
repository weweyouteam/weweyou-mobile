import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:weweyou/model/event_model.dart';
import 'package:weweyou/model/ticket_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/home.dart';
import 'package:weweyou/screens/my_profile.dart';
import 'package:weweyou/screens/payment_details.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/utils/custom_dailogs.dart';
import 'package:weweyou/widgets/stripe_dialog.dart';

class PaymentScreen extends StatefulWidget {
  Event model;Tickets ticket;

  int tickets;double price;

  PaymentScreen(this.model, this.ticket,this.tickets, this.price);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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
                Text("Purchase Details",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),)
              ],
            ),
            SizedBox(height: 20,),
            Expanded(
              child: Container(

                decoration: BoxDecoration(
                    color: lightBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)
                    )
                ),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.fromLTRB(20,40,20,40),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                    Text(widget.model.address,style: TextStyle(color: Colors.grey[600],fontSize: 15,fontWeight: FontWeight.w300,),),
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

                              ],
                            ),
                          ),
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
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20,),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(7),
                                  ),

                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: TextFormField(
                                          style: TextStyle(color: Colors.black),

                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(15),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(7.0),

                                              borderSide: BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(7.0),
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 0.5
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(7.0),
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 0.5,
                                              ),
                                            ),
                                            hintText: "Enter Discount",
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text("Apply",style: TextStyle(color: primary),),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  child:  Text("Choose your payment method",style: TextStyle(color: Colors.grey),),
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      //elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset("assets/images/mastercard.png",height: 120,width: 120,),
                                      ),
                                    ),
                                    Container(
                                      //elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset("assets/images/visa.png",height: 120,width: 120,),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                onTap: ()async{
                                  if(widget.ticket.free==1)
                                    bookFreeTicket(provider.userData!.apitoken, provider.userData!.name, provider.userData!.email);
                                  else{
                                    showStripeDialog(context,provider.userData!.apitoken,widget.model,widget.ticket,widget.tickets);
                                  }
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
                                    child: Text("GET IT",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)

                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )

          ],
        )
    );
  }
  Future bookFreeTicket(apiToken,name,email)async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Booking Tickets",barrierDismissible: true);

    Dio dio = new Dio();
    FormData formdata = new FormData();
    formdata = FormData.fromMap({
      'event_id': widget.model.id,
      'ticket_id': widget.ticket.id,
      'quantity': widget.ticket,
      'event_category': widget.model.categoryId,
      'ticket_title': widget.ticket.title,
      'customer_name': name,
      'customer_email': email,
      'event_title':  widget.model.title,
    });
    var response=await dio.post(
        '$apiUrl/api/free-booking',
        data: formdata,
        options: Options(
          headers: {
            "apitoken": apiToken
          },
          method: 'POST',
          responseType: ResponseType.json,

        )
    );
    print("repsonse ${response.statusCode} ${response.data}");

    if(response.statusCode==200){
      if(response.data['code']=="200"){
        pr.close();
        final snackBar = SnackBar(content: Text("${response.data['message']}"),backgroundColor: Colors.green,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyProfile(2)));
      }
      else{
        pr.close();
        final snackBar = SnackBar(content: Text("Error : ${response.data['message']}"),backgroundColor: Colors.red,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

    }
    else{
      pr.close();
      final snackBar = SnackBar(content: Text("Error : Unable to create event"),backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
