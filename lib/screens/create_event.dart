import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as dateTimePicker;

import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:weweyou/model/category_model.dart';
import 'package:weweyou/model/ticket_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:weweyou/utils/custom_dailogs.dart';

import 'home.dart';
class CreateEvent extends StatefulWidget {
  String mainEventId;

  CreateEvent(this.mainEventId);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  bool isTicketFree = false;
  bool isSubEvent = false;
  String imageUrl = "";
  bool imageUploading = false;
  String currency='USD';
  String type='Main Event';
  String official='Yes';

  var _imageFile;
  double? latti,longi;

  List<TicketModel> ticketsList=[];

  final picker = ImagePicker();
  final _infoFormKey = GlobalKey<FormState>();

  Future uploadImageToFirebase(BuildContext context) async {
    setState(() {
      imageUploading = true;
    });
    var storage = FirebaseStorage.instance;
    TaskSnapshot snapshot = await storage.ref().child('pictures/${DateTime
        .now()
        .millisecondsSinceEpoch}').putFile(_imageFile!);
    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        imageUploading = false;
      });
    }
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
    uploadImageToFirebase(context);
  }

  Future pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
    uploadImageToFirebase(context);
  }
  bool categoriesLoaded=false;
  List<String> categories=[];
  List<Category> allCategories=[];

  Future getCategories()async{
    var response= await Dio().get('$apiUrl/api/categories');
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        CategoryModel category=CategoryModel.fromJson(response.data);
        category.data.forEach((element) {
          categories.add(element.name);
          allCategories.add(element);
        });
        setState(() {
          eventType=category.data[0].name;
          categoryId=category.data[0].id.toString();
          categoriesLoaded=true;
        });
      }
      else{
        setState(() {
          eventType="no category";
          categoriesLoaded=true;
        });
      }

    }
    else{
      setState(() {
        eventType="no category";
        categoriesLoaded=true;
      });
    }

  }

  TimeOfDay selectedTime = TimeOfDay.now();
  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if(timeOfDay != null)
    {
      setState(() {
        selectedTime = timeOfDay;
        startTimeController.text=selectedTime.format(context);
      });
    }
  }
  int dateTimeMilli=DateTime.now().millisecondsSinceEpoch;

  choiceDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Card(
          margin: EdgeInsets.only(top: MediaQuery
              .of(context)
              .size
              .height * 0.8),
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
                  onTap: () {
                    pickImage();
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: Text("Take Picture From Camera", style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    pickImageFromGallery();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: Text("Choose From Gallery", style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),),
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

  int tickets = 0;
  var titleController = TextEditingController();
  var categoryController = TextEditingController();
  var locationController = TextEditingController();
  var addressController = TextEditingController();
  var startDateController = TextEditingController();
  var startTimeController = TextEditingController();
  var endDateController = TextEditingController();
  var endTimeController = TextEditingController();
  var currencyController = TextEditingController();
  var officialTicketController = TextEditingController();


  var ticketNameController = TextEditingController();
  var ticketQtyController = TextEditingController();

  var descriptionController = TextEditingController();


  var priceController = TextEditingController();
  var eventController = TextEditingController();
  String? eventType;
  String? categoryId;
  String? month, date, day;
  final f = new DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    getCategories();
    month = getMonthName(DateTime.now().month);
    date = f.format(DateTime.now()).toString();
    day = DateTime.now().day.toString();
  }

  int _step = 0;

  String getMonthName(int monthNumber) {
    String name = "";
    switch (monthNumber) {
      case 1:
        {
          name = "January";
        }
        break;
      case 2:
        {
          name = "February";
        }
        break;
      case 3:
        {
          name = "March";
        }
        break;
      case 4:
        {
          name = "April";
        }
        break;
      case 5:
        {
          name = "May";
        }
        break;
      case 6:
        {
          name = "June";
        }
        break;
      case 7:
        {
          name = "July";
        }
        break;
      case 8:
        {
          name = "August";
        }
        break;
      case 9:
        {
          name = "September";
        }
        break;
      case 10:
        {
          name = "October";
        }
        break;
      case 11:
        {
          name = "November";
        }
        break;
      case 12:
        {
          name = "December";
        }
        break;
      default:
        {
          name = "January";
        }
        break;
    }
    return name;
  }

  bool freeTicket = false,
      paidTicket = false,
      donation = false,
      offline = false,
      online = false,
      privateListing = false,
      confidentialListing = false,
      onlineEvent = false;

  String city="",country="";

  Future createEvent(int userId,apiToken)async{
    String fileName = _imageFile.path.split('/').last;
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Creating event",barrierDismissible: true);
    allCategories.forEach((element) {
      if(eventType==element.name){
        categoryId=element.id.toString();
      }
    });
    print("array of ticckets : ${ticketsList.map((e)=>e.toJson()).toList()}");
    /*http.Response response=await http.post(
      Uri.parse('$apiUrl/api/createevent'),
      headers: <String, String>{
        "apitoken": apiToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: {
        'title': titleController.text,
        'user_id': userId,
        'address': locationController.text,
        'slug': "new_event",
        'description': descriptionController.text,
        'latitude': latti,
        'longitude': longi,
        'category_id': int.parse(categoryId!),
        'start_date': startDateController.text,
        'start_time': startTimeController.text,
        'private_listing': privateListing?1:0,
        'confidential_listing': confidentialListing?1:0,
        'online': onlineEvent?1:0,
        'city':city,
        'images':imageUrl,
        'ticket_type':ticketsList.map((e)=>e.toJson()).toList(),
      },
    );
    pr.close();
    print(response.body);*/
    Dio dio = new Dio();
    FormData formdata = new FormData();

    List<Map<String,dynamic>> tickets=[];
    ticketsList.forEach((element) {
      tickets.add({
        "title":element.title,
        "quantity":element.quantity,
        "description":element.description,
        "online":element.online,
        "offline":element.offline,
        "free":element.free,
        "paid":element.paid,
        "price":element.price
      });
    });
    print("mmmsp of ticckets : ${tickets}");
    print("json map of ticckets : ${jsonEncode(tickets)}");
    print("json list of ticckets : ${jsonEncode(ticketsList.map((e)=>e.toJson()).toList())}");
    formdata = FormData.fromMap({
      'title': titleController.text,
      'user_id': userId,
      'address': locationController.text,
      'slug': "new_event",
      'description': descriptionController.text,
      'latitude': latti,
      'longitude': longi,
      'category_id': int.parse(categoryId!),
      'start_date': startDateController.text,
      'start_time': startTimeController.text,
      'private_listing': privateListing?1:0,
      'confidential_listing': confidentialListing?1:0,
      'online': onlineEvent?1:0,
      'city':city,
      'images':imageUrl,
      'ticket_type':jsonEncode(tickets),
    });
    var response= await dio.post(
        '$apiUrl/api/createevent',
        data: formdata, options: Options(
        headers: {
          "apitoken": apiToken
        },
        method: 'POST',
        responseType: ResponseType.json // or ResponseType.JSON
      )
    );
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        pr.close();
        final snackBar = SnackBar(content: Text("${response.data['message']}"),backgroundColor: Colors.green,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
      }
      else{
        pr.close();
        final snackBar = SnackBar(content: Text("Error : ${response.data['message']}"),backgroundColor: Colors.red,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

    }

  }


  Future createSubEvent(int userId,apiToken)async{
    print("main evo ido ${widget.mainEventId}");
    String fileName = _imageFile.path.split('/').last;
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Creating event",barrierDismissible: true);
    allCategories.forEach((element) {
      if(eventType==element.name){
        categoryId=element.id.toString();
      }
    });
    List<Map<String,dynamic>> tickets=[];
    ticketsList.forEach((element) {
      tickets.add({
        "title":element.title,
        "quantity":element.quantity,
        "description":element.description,
        "online":element.online,
        "offline":element.offline,
        "free":element.free,
        "paid":element.paid,
        "price":element.price
      });
    });
    Dio dio = new Dio();
    FormData formdata = new FormData();
    print("array of ticckets : ${ticketsList.map((e)=>e.toJson()).toList()}");
    formdata = FormData.fromMap({

      'title': titleController.text,
      'user_id': userId,
      'parent_id': int.parse(widget.mainEventId),
      'address': locationController.text,
      'slug': "sub_event",
      'description': descriptionController.text,
      'latitude': latti,
      'longitude': longi,
      'category_id': int.parse(categoryId!),
      'start_date': startDateController.text,
      'start_time': startTimeController.text,
      'private_listing': privateListing?1:0,
      'confidential_listing': confidentialListing?1:0,
      'online': onlineEvent?1:0,
      'city':city,
      'images':imageUrl,
      'ticket_type':jsonEncode(tickets),
    });
    var response= await dio.post(
        '$apiUrl/api/createsubevent',
        data: formdata, options: Options(
        headers: {
          "apitoken": apiToken
        },
        method: 'POST',
        responseType: ResponseType.json // or ResponseType.JSON
    )
    );
    //print("repsonse ${response.statusCode} ${response.data}");

     if(response.statusCode==200){
      if(response.data['code']=="200"){
        pr.close();
        final snackBar = SnackBar(content: Text("${response.data['message']}"),backgroundColor: Colors.green,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var margin = MediaQuery
        .of(context)
        .size
        .width * 0.05;
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: primary,
      body: Column(
        children: [
          SizedBox(height: 50,),
          Row(
            children: [
              SizedBox(width: 10,),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded, color: Colors.white,),
              ),
              SizedBox(width: 10,),
              // Text("Create Event",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),)
            ],
          ),
          SizedBox(height: 20,),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: lightBackgroundColor,

                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomRight: Radius.zero,
                      bottomLeft: Radius.zero)
              ),
              child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Text("Create An Event", style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),),

                    SizedBox(
                      height: height * 0.03,
                    ),
                    Expanded(
                      child: Container(
                        child: Theme(
                          data: ThemeData(
                            canvasColor: lightBackgroundColor,
                            primarySwatch: Colors.red,
                          ),
                          child: Stepper(
                            type: StepperType.horizontal,

                            controlsBuilder: (BuildContext context,  ControlsDetails controls) {
                              return _step == 0 ?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(9, 14, 9, 9),
                                    child: Container(
                                      height: height * 0.045,
                                      width: width * 0.3,
                                      color: primary,
                                      child: InkWell(
                                        onTap: controls.onStepContinue,
                                        child: Center(
                                          child: Text("Next", style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300
                                          ),),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ) : _step == 3 ?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        9, 14, 9, 9),
                                    child: Container(
                                      height: height * 0.045,
                                      width: width * 0.3,
                                      color: Colors.black45,
                                      child: InkWell(
                                        onTap: controls.onStepCancel,
                                        child: Center(
                                          child: Text("BACK", style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300
                                          ),),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        9, 14, 9, 9),
                                    child: Container(
                                      height: height * 0.045,
                                      width: width * 0.3,
                                      color: primary,
                                      child: InkWell(
                                        onTap: () {
                                          if(widget.mainEventId=="")
                                            createEvent(provider.userData!.id, provider.userData!.apitoken);
                                          else
                                            createSubEvent(provider.userData!.id, provider.userData!.apitoken);
                                        },
                                        child: Center(
                                          child: Text(
                                            "CREATE EVENT", style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300
                                          ),),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ) :
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        9, 14, 9, 9),
                                    child: Container(
                                      height: height * 0.045,
                                      width: width * 0.3,
                                      color: Colors.black54,
                                      child: InkWell(
                                        onTap: controls.onStepCancel,
                                        child: Center(
                                          child: Text("BACK", style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300
                                          ),),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        9, 14, 9, 9),
                                    child: Container(
                                      height: height * 0.045,
                                      width: width * 0.3,
                                      color: primary,
                                      child: InkWell(
                                        onTap: controls.onStepContinue,
                                        child: Center(
                                          child: Text("NEXT", style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300
                                          ),),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            currentStep: _step,
                            onStepCancel: () {
                              if (_step > 0) {
                                setState(() {
                                  _step -= 1;
                                });
                              }
                            },
                            onStepContinue: () {
                              if (_step < 3) {
                                if(_step==0){
                                  if (_infoFormKey.currentState!.validate()) {
                                    setState(() {
                                      _step += 1;
                                    });
                                  }
                                }
                                else if(_step==1){
                                  if(ticketsList.length>=1){
                                    setState(() {
                                      _step += 1;
                                    });
                                  }
                                  else{
                                    final snackBar = SnackBar(content: Text("Please add at least 1 ticket"),backgroundColor: Colors.red,);
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }

                                }
                                else if(_step==2){
                                  setState(() {
                                    _step += 1;
                                  });
                                }

                              }
                              else if (_step == 3) {

                              }
                            },
                            onStepTapped: (int index) {
                              setState(() {
                                _step = index;
                              });
                            },

                            steps: <Step>[
                              Step(
                                  isActive: _step >= 0 ? true : false,
                                  state: _step >= 1
                                      ? StepState.complete
                                      : StepState.disabled,
                                  title: Text(''),
                                  content: Form(
                                    key: _infoFormKey,
                                    child: ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      children: [
                                        Center(
                                          child: Text(
                                            "General Info", style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16
                                          ),),
                                        ),

                                        SizedBox(
                                          height: height * 0.03,
                                        ),

                                        // Event Title
                                        Container(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Event Name", style: TextStyle(
                                              color: Colors.white,

                                            ),),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 8, 0, 0),
                                          child: Container(
                                            child: TextFormField(
                                              controller: titleController,
                                              style: TextStyle(
                                                  color: Colors.black
                                              ),
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
                                                hintText: "Enter event name",
                                                hintStyle: TextStyle(color: Colors.grey),
                                                filled: true,
                                                fillColor: Colors.white,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Enter Data";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          height: height * 0.02,
                                        ),

                                        // Category
                                        Container(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Event Category", style: TextStyle(
                                              color: Colors.white,

                                            ),),
                                          ),
                                        ),
                                        categoriesLoaded?Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 8, 0, 0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(7.0),
                                            ),
                                            height: height * 0.063,
                                            padding: EdgeInsets.only(left: 10,right: 10),
                                            child: Theme(
                                              data: ThemeData(canvasColor: Colors.white),
                                              child: DropdownButton<String>(
                                                value: eventType,
                                                isExpanded: true,
                                                icon: const Icon(Icons.arrow_drop_down),
                                                iconSize: 24,
                                                elevation: 16,
                                                style: const TextStyle(color: Colors.black),
                                                underline: Container(
                                                ),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    eventType = newValue!;
                                                  });
                                                },
                                                items: categories
                                                    .map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ):Center(child:CircularProgressIndicator()),



                                        SizedBox(
                                          height: height * 0.02,
                                        ),

                                        // Location
                                        Container(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Location", style: TextStyle(
                                              color: Colors.white,

                                            ),),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 8, 0, 0),
                                          child: Container(

                                            child: TextFormField(
                                              controller: locationController,
                                              style: TextStyle(
                                                  color: Colors.black
                                              ),
                                              readOnly: true,
                                              onTap: ()async{
                                                LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        PlacePicker(mapApiKey)));

                                                // Handle the result in your way
                                                print(result);
                                                latti=result.latLng!.latitude;
                                                longi=result.latLng!.longitude;

                                                locationController.text='${result.formattedAddress.toString()}';
                                                setState(() {
                                                  city='${result.city.toString()}';
                                                  country='${result.country.toString()}';
                                                });
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
                                                hintText: "Enter event location",
                                                hintStyle: TextStyle(color: Colors.grey),
                                                filled: true,
                                                fillColor: Colors.white,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Enter Data";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),


                                        SizedBox(
                                          height: height * 0.02,
                                        ),

                                        // Location
                                        Container(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text("Event Description", style: TextStyle(
                                              color: Colors.white,

                                            ),),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 8, 0, 0),
                                          child: Container(

                                            child: TextFormField(
                                              maxLines: 3,
                                              minLines: 3,
                                              controller: descriptionController,
                                              style: TextStyle(
                                                  color: Colors.black
                                              ),
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
                                                hintText: "Enter event description",
                                                hintStyle: TextStyle(color: Colors.grey),
                                                filled: true,
                                                fillColor: Colors.white,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Enter Data";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Start Date
                                            Container(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("Start Date & Time",
                                                  style: TextStyle(
                                                    color: Colors.white,

                                                  ),),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets
                                                  .fromLTRB(0, 4, 0, 0),
                                              child: Container(

                                                child: TextFormField(
                                                  readOnly: true,
                                                  onTap: ()async{
                                                    dateTimePicker.DatePicker.showDateTimePicker(context,
                                                        showTitleActions: true,
                                                        minTime: DateTime.now(),
                                                        maxTime: DateTime(2025, 1, 1),
                                                        onChanged: (picked) {
                                                          final f = new DateFormat('dd-MM-yyyy – kk:mm');
                                                          month = getMonthName(picked.month);
                                                          date = f.format(picked).toString();
                                                          day = picked.day.toString();
                                                          final tf = new DateFormat('kk:mm');
                                                          startDateController.text = f.format(picked);
                                                          startTimeController.text=tf.format(picked);
                                                          dateTimeMilli=picked.millisecondsSinceEpoch;
                                                        },
                                                        onConfirm: (picked) {
                                                          final f = new DateFormat('dd-MM-yyyy – kk:mm');
                                                          final tf = new DateFormat('kk:mm');
                                                          month = getMonthName(picked.month);
                                                          date = f.format(picked).toString();
                                                          day = picked.day.toString();
                                                          startTimeController.text=tf.format(picked);
                                                          startDateController.text = f.format(picked);
                                                          dateTimeMilli=picked.millisecondsSinceEpoch;
                                                        },
                                                        currentTime: DateTime.now(),
                                                    );
                                                  },
                                                  controller: startDateController,
                                                  style: TextStyle(
                                                      color: Colors.black
                                                  ),
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
                                                    hintText: "Enter date and time",
                                                    hintStyle: TextStyle(color: Colors.grey),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Enter Data";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Start
                                        



                                        SizedBox(
                                          height: height * 0.02,
                                        ),



                                      ],
                                    ),
                                  )
                              ),
                              Step(
                                  isActive: _step >= 1 ? true : false,
                                  state: _step >= 2
                                      ? StepState.complete
                                      : StepState.disabled,
                                  title: Text(''),
                                  content: ListView(
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    children: [
                                      Center(
                                        child: Text(
                                          "TICKET INFORMATION", style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16
                                        ),),
                                      ),

                                      SizedBox(
                                        height: height * 0.04,
                                      ),


                                      // ticket type
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 20, 5),
                                        child: Container(
                                          child: Text("TICKET TYPES",
                                            style: TextStyle(color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                children: [
                                                  Theme(
                                                    data: ThemeData(
                                                        accentColor: Colors
                                                            .red,
                                                        unselectedWidgetColor: Colors
                                                            .white),
                                                    child: Checkbox(
                                                      value: freeTicket,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          freeTicket = value!;
                                                        });
                                                      },
                                                    ),
                                                  ),


                                                  Text("Free Ticket",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),),
                                                ],
                                              ),
                                              SizedBox(width: width * 0.08),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                children: [
                                                  Theme(
                                                    data: ThemeData(
                                                        accentColor: Colors
                                                            .red,
                                                        unselectedWidgetColor: Colors
                                                            .white),
                                                    child: Checkbox(
                                                      value: paidTicket,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          paidTicket = value!;
                                                        });
                                                      },
                                                    ),
                                                  ),


                                                  Text("Paid Ticket",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),),
                                                ],
                                              ),


                                            ],
                                          ),

                                        ],
                                      ),


                                      // ticket Sale option
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 20, 20, 5),
                                        child: Container(
                                          child: Text("TICKET TYPES",
                                            style: TextStyle(color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: [
                                              Theme(
                                                data: ThemeData(
                                                    accentColor: Colors.red,
                                                    unselectedWidgetColor: Colors
                                                        .white),
                                                child: Checkbox(
                                                  value: online,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      online = value!;
                                                    });
                                                  },
                                                ),
                                              ),


                                              Text("Online", style: TextStyle(
                                                color: Colors.white,
                                              ),),
                                            ],
                                          ),
                                          SizedBox(width: width * 0.08),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: [
                                              Theme(
                                                data: ThemeData(
                                                    accentColor: Colors.red,
                                                    unselectedWidgetColor: Colors
                                                        .white),
                                                child: Checkbox(
                                                  value: offline,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      offline = value!;
                                                    });
                                                  },
                                                ),
                                              ),


                                              Text("Offline", style: TextStyle(
                                                color: Colors.white,
                                              ),),
                                            ],
                                          ),


                                        ],
                                      ),

                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex:2,
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      "Price", style: TextStyle(
                                                      color: Colors.white,

                                                    ),),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                                  height: height * 0.063,
                                                  child: Theme(
                                                    data: ThemeData(canvasColor: Colors.white),
                                                    child: DropdownButton<String>(
                                                      value: currency,
                                                      isExpanded:true,
                                                      icon:  Icon(Icons.arrow_drop_down),
                                                      iconSize: 24,
                                                      elevation: 16,
                                                      style:  TextStyle(fontSize:16,color: Colors.grey),
                                                      underline: Container(
                                                      ),
                                                      onChanged: (String? newValue) {
                                                        setState(() {
                                                          currency = newValue!;
                                                        });
                                                      },
                                                      items: <String>['USD','EUR','JPY']
                                                          .map<DropdownMenuItem<String>>((String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex:8,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,

                                              children: [
                                                // Start Time
                                                Container(
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text("",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(10, 4, 0, 0),
                                                  child: Container(

                                                    child: TextFormField(
                                                      keyboardType: TextInputType.number,
                                                      controller: priceController,
                                                      style: TextStyle(
                                                          color: Colors.black
                                                      ),
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
                                                        hintText: "Enter price",
                                                        hintStyle: TextStyle(color: Colors.grey),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                                      ),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return "Enter Data";
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Start Date
                                          Container(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text("Ticket Name",
                                                style: TextStyle(
                                                  color: Colors.white,

                                                ),),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets
                                                .fromLTRB(0, 4, 0, 0),
                                            child: Container(
                                              child: TextFormField(
                                                controller: ticketNameController,
                                                style: TextStyle(
                                                    color: Colors.black
                                                ),
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
                                                  hintText: "Enter Ticket Name",
                                                  hintStyle: TextStyle(color: Colors.grey),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Enter Data";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Start Date
                                          Container(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text("Ticket Quantity",
                                                style: TextStyle(
                                                  color: Colors.white,

                                                ),),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets
                                                .fromLTRB(0, 4, 0, 0),
                                            child: Container(

                                              child: TextFormField(
                                                keyboardType: TextInputType.number,
                                                controller: ticketQtyController,
                                                style: TextStyle(
                                                    color: Colors.black
                                                ),
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
                                                  hintText: "Enter Quantity",
                                                  hintStyle: TextStyle(color: Colors.grey),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Enter Data";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      InkWell(
                                        onTap:(){

                                          TicketModel model=new TicketModel(
                                              ticketNameController.text==""?"Ticket${ticketsList.length+1}":ticketNameController.text,
                                              ticketQtyController.text==""?0:int.parse(ticketQtyController.text),
                                              "Event Ticket",
                                             // priceController.text==""?"0":priceController.text,
                                              online?1:0,
                                              offline?1:0,
                                              freeTicket?1:0,
                                              paidTicket?1:0,
                                              freeTicket?"0":priceController.text
                                          );
                                          setState(() {
                                            ticketsList.add(model);
                                          });
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            // Start Date
                                            Container(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child:Icon(Icons.add_circle, color: primary, size: 30),
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Container(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text("Add Ticket",
                                                  style: TextStyle(
                                                    color: Colors.white,

                                                  ),),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      if(ticketsList.length>0)
                                        Container(
                                          height: 50,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount:ticketsList.length,
                                            itemBuilder: (BuildContext context,int index){
                                              return InkWell(
                                                onLongPress: (){
                                                  setState(() {
                                                    ticketsList.removeAt(index);
                                                  });
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(0,0,10,0),
                                                  height: 60,
                                                  width: 100,
                                                  color: primary,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        child: Text(ticketsList[index].title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 15),),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.01,
                                                      ),
                                                      Container(
                                                        child: Text('${ticketsList[index].quantity} - ${ticketsList[index].price}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 13),),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      if(ticketsList.length>0)
                                        Container(
                                          alignment:Alignment.center,
                                          margin: EdgeInsets.fromLTRB(0,10,0,0),
                                          child: Text("Long press to remove a ticket",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 12),),
                                        ),
                                      // Currency



                                      /*SizedBox(
                                          height: height * 0.02,
                                        ),

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Icon(
                                              Icons.add_circle, color: Colors.red,
                                              size: 45,),
                                            Text(
                                              "Add Ticket Price", style: TextStyle(
                                                  color: Colors.black
                                              ),)
                                          ],
                                        ),*/

                                      SizedBox(
                                        height: height * 0.03,
                                      ),


                                      // Are these official tickets
                                      Container(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Are these official tickets?",
                                            style: TextStyle(
                                              color: Colors.white,

                                            ),),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 0, 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(7.0),
                                          ),
                                          height: height * 0.063,
                                          padding: EdgeInsets.only(left: 10,right: 10),
                                          child: Theme(
                                            data: ThemeData(canvasColor: Colors.white),
                                            child: DropdownButton<String>(
                                              value: official,
                                              isExpanded: true,
                                              icon: const Icon(Icons.arrow_drop_down),
                                              iconSize: 24,
                                              elevation: 16,
                                              style: const TextStyle(color: Colors.black),
                                              underline: Container(
                                              ),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  official = newValue!;
                                                });
                                              },
                                              items: <String>['Yes', 'No']
                                                  .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),


                                    ],
                                  )
                              ),
                              Step(
                                  isActive: _step >= 2 ? true : false,
                                  state: _step >= 3
                                      ? StepState.complete
                                      : StepState.disabled,
                                  title: Text(''),
                                  content: ListView(
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    children: [
                                      Center(
                                        child: Text(
                                          "Event Type", style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16
                                        ),),
                                      ),

                                      SizedBox(
                                        height: height * 0.03,
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Theme(
                                            data: ThemeData(
                                                accentColor: Colors.red,
                                                unselectedWidgetColor: Colors
                                                    .white),
                                            child: Checkbox(
                                              value: privateListing,
                                              onChanged: (value) {
                                                setState(() {
                                                  privateListing = value!;
                                                });
                                              },
                                            ),
                                          ),


                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text("Private Listing",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),),

                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(0, 4, 0, 0),
                                                child: Container(
                                                  width: width * 0.7,
                                                  height: height * 0.07,
                                                  child: Text(
                                                    "Private listing are not visible on our directory. They are accessible only by the organizer approval ",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),


                                      SizedBox(
                                        height: height * 0.01,
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Theme(
                                            data: ThemeData(
                                                accentColor: Colors.red,
                                                unselectedWidgetColor: Colors
                                                    .white),
                                            child: Checkbox(
                                              value: confidentialListing,
                                              onChanged: (value) {
                                                setState(() {
                                                  confidentialListing = value!;
                                                });
                                              },
                                            ),
                                          ),


                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text("Confidential Listing",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),),

                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(0, 4, 0, 0),
                                                child: Container(
                                                  width: width * 0.7,
                                                  height: height * 0.07,
                                                  child: Text(
                                                    "Confidential listing are not visible on our directory. They are Accessible only by users having received the link",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        height: height * 0.01,
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Theme(
                                            data: ThemeData(
                                                accentColor: Colors.red,
                                                unselectedWidgetColor: Colors
                                                    .white),
                                            child: Checkbox(
                                              value: onlineEvent,
                                              onChanged: (value) {
                                                setState(() {
                                                  onlineEvent = value!;
                                                });
                                              },
                                            ),
                                          ),


                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                "Online Event", style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),),

                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(0, 4, 0, 0),
                                                child: Container(
                                                  width: width * 0.7,
                                                  height: height * 0.07,
                                                  child: Text(
                                                    "Please State if your event is in online format",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),


                                    ],
                                  )
                              ),
                              Step(
                                  isActive: _step >= 3 ? true : false,
                                  state: _step >= 4
                                      ? StepState.complete
                                      : StepState.disabled,
                                  title: Text(''),
                                  content: ListView(
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    children: [
                                      Center(
                                        child: Text(
                                          "Event Cover", style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16
                                        ),),
                                      ),

                                      SizedBox(
                                        height: height * 0.04,
                                      ),
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
                                      SizedBox(
                                        height: 10,
                                      ),

                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
              ),
            ),
          )
        ],
      ),


    );
  }

}



