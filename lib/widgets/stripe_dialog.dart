
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:weweyou/model/event_model.dart';
import 'package:weweyou/model/ticket_model.dart';
import 'package:weweyou/screens/my_profile.dart';
import 'package:weweyou/utils/constants.dart';

Future<void> showStripeDialog(BuildContext context,apiToken,Event model,Tickets ticket,quantity) async {
  var _cardNumberController=TextEditingController();
  var _monthController=TextEditingController();
  var _cvvController=TextEditingController();
  String month="";
  String year="";
  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.35,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Text("Add Card Details",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);

                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Icon(Icons.close,color: Colors.black,),
                            ),
                          ),
                        )
                      ],
                    ),

                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          SizedBox(height: 10,),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _cardNumberController,
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
                                  color: Colors.transparent,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 0.5
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0.5,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Card Number',
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: TextFormField(
                                    controller: _monthController,
                                    readOnly: true,
                                    onTap: (){
                                      showMonthPicker(
                                        context: context,
                                        firstDate: DateTime(DateTime.now().year - 1, 5),
                                        lastDate: DateTime(DateTime.now().year + 1, 9),
                                        initialDate: DateTime.now(),
                                      ).then((date) {
                                        if (date != null) {
                                          var dateFormat = DateFormat("MM/yyyy");
                                          var monthFormat = DateFormat("yyyy");
                                          var yearFormat = DateFormat("yyyy");
                                          _monthController.text=dateFormat.format(date);
                                          year=yearFormat.format(date);
                                          month=monthFormat.format(date);
                                        }
                                      });
                                    },
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
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7.0),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.5
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7.0),
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 0.5,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      hintText: 'MM\\YY',
                                      // If  you are using latest version of flutter then lable text and hint text shown like this
                                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    controller: _cvvController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7.0),
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7.0),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.5
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7.0),
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 0.5,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      hintText: 'CVC',
                                      // If  you are using latest version of flutter then lable text and hint text shown like this
                                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20,),



                          InkWell(
                            onTap: ()async{
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context);
                                final ProgressDialog pr = ProgressDialog(context: context);
                                pr.show(max: 100, msg: "Booking Tickets",barrierDismissible: true);

                                Dio dio = new Dio();
                                FormData formdata = new FormData();
                                formdata = FormData.fromMap({
                                  'event_id': model.id,
                                  'ticket_id': ticket.id,
                                  'quantity': quantity,
                                  'event_category': model.categoryId,
                                  'exp_month': month,
                                  'exp_year': year,
                                  'cvc': _cvvController.text.trim(),
                                  'number':  _cardNumberController.text.trim(),
                                });
                                var response=await dio.post(
                                    '$apiUrl/api/stripe/payment',
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
                                  final snackBar = SnackBar(content: Text("Error : Unable to book ticket"),backgroundColor: Colors.red,);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.red.shade900,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(20,10,20,10),
                              child: Text("Book",style: TextStyle(fontSize:18,fontWeight: FontWeight.w400,color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}