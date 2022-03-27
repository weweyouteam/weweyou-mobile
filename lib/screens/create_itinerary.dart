import 'dart:io';


import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:weweyou/utils/custom_dailogs.dart';import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
class CreateItinerary extends StatefulWidget {
  const CreateItinerary({Key? key}) : super(key: key);

  @override
  _CreateItineraryState createState() => _CreateItineraryState();
}

class _CreateItineraryState extends State<CreateItinerary> {
  bool isTicketFree=false;
  bool isSubEvent=false;
  int tickets=0;
  String imageUrl="";
  bool imageUploading=false;
  File? _imageFile;

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  Future uploadImageToFirebase(BuildContext context) async {
    setState((){
      imageUploading=true;
    });
    var storage = FirebaseStorage.instance;
    TaskSnapshot snapshot = await storage.ref().child('pictures/${DateTime.now().millisecondsSinceEpoch}').putFile(_imageFile!);
    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        imageUploading=false;
      });
    }
  }
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
    uploadImageToFirebase(context);
  }

  Future pickImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
    uploadImageToFirebase(context);
  }

  choiceDialog(){
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Card(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.8),
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
          ),
          elevation: 2,

          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: (){
                    pickImage();
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40,right: 40),
                    child:Text("Take Picture From Camera",style: TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    pickImageFromGallery();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40,right: 40),
                    child:Text("Choose From Gallery",style: TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
  var titleController=TextEditingController();
  var descriptionController=TextEditingController();
  var priceController=TextEditingController();
  var eventController=TextEditingController();
  String eventId="";
  String eventType='Conference';
  String? month,date,day;
  final f = new DateFormat('dd-MM-yyyy');
  @override
  void initState() {
    super.initState();
    month=getMonthName(DateTime.now().month);
    date=f.format(DateTime.now()).toString();
    day=DateTime.now().day.toString();
  }

  String getMonthName(int monthNumber){
    String name="";
    switch(monthNumber) {
      case 1: {  name="January"; }
      break;
      case 2: {  name="February"; }
      break;
      case 3: {  name="March"; }
      break;
      case 4: {  name="April"; }
      break;
      case 5: {  name="May"; }
      break;
      case 6: {  name="June"; }
      break;
      case 7: {  name="July"; }
      break;
      case 8: {  name="August"; }
      break;
      case 9: {  name="September"; }
      break;
      case 10: {  name="October"; }
      break;
      case 11: {  name="November"; }
      break;
      case 12: {  name="December"; }
      break;
      default: { name="January"; }
      break;
    }
    return name;
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: primary,
      body: Form(
        key: _formKey,
        child: Column(
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
                Text("Create Itinerary",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),)
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

                    Text("Select Date",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),),
                    SizedBox(height: 20,),
                    DatePicker(
                      DateTime.now(),
                      initialSelectedDate: DateTime.now(),
                      selectionColor: primary,
                      dateTextStyle: TextStyle(color: Colors.white),
                      dayTextStyle: TextStyle(color: Colors.white),
                      monthTextStyle: TextStyle(color: Colors.white),
                      selectedTextColor: Colors.white,
                      onDateChange: (selectedDate) {
                        setState(() {
                          month=getMonthName(selectedDate.month);
                          date=f.format(selectedDate).toString();
                          day=selectedDate.day.toString();
                        });
                      },
                    ),
                    SizedBox(height: 20,),
                    Text("Select Image",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),),
                    SizedBox(height: 20,),

                    imageUploading?Center(child: CircularProgressIndicator(),)
                        :
                    InkWell(
                      onTap: (){
                        choiceDialog();
                      },
                      child: imageUrl==""?
                      Container(
                        color: lightBackgroundColor,
                        child: DottedBorder(
                            color: primary,
                            strokeWidth: 1,
                            dashPattern: [7],
                            borderType: BorderType.Rect,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/upload.png",color: primary,height: 50,width: 50,fit: BoxFit.cover,),
                                  SizedBox(height: 10,),
                                  Text("Upload Image",style: TextStyle(color: primary,fontWeight: FontWeight.w300),)
                                ],
                              ),
                            )
                        ),
                      ):
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text("Enter Information",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),),
                    SizedBox(height: 20,),
                    TextFormField(
                      style: TextStyle(color: Colors.black),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: titleController,
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
                        hintText: "Enter Title",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[200],
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      maxLines: 3,
                      minLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: descriptionController,
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
                        hintText: "Enter Breif Description",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[200],
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      readOnly: true,

                      style: TextStyle(color: Colors.black),
                      controller: eventController,
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
                        hintText: "Select Event",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[200],
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),


                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        if(_formKey.currentState!.validate()){
                          final ProgressDialog pr = ProgressDialog(context: context);
                          pr.show(max: 100, msg: "Adding");
                          String key=DateTime.now().millisecondsSinceEpoch.toString();


                         /* FirebaseFirestore.instance.collection('itineraries').doc(key).set({
                            'title': titleController.text,
                            'description': descriptionController.text,
                            'image': imageUrl,
                            'price': priceController.text,
                            'eventId':eventId,
                            'eventName':eventController.text,
                            'date':date,
                            'userId':provider.userData!.id,
                            'day':day,
                            'month':month
                          }).then((value) {
                            pr.close();
                           showSuccessDailog("Your itinerary is successfully created", context);
                          }).onError((error, stackTrace) {
                            pr.close();
                            showFailuresDailog(error.toString(), context);
                          });*/
                        }
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
                        child: Text("Create Itinerary",style: TextStyle(fontSize:18,fontWeight: FontWeight.w500,color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
