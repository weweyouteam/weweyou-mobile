import 'dart:io';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:weweyou/utils/custom_dailogs.dart';

import 'home.dart';
class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
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
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  String imageUrl = "";File? _imageFile;
  bool imageUploading = false;

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
  Future createGroup(int organizerId,apiToken)async{
    String fileName = _imageFile!.path.split('/').last;
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Creating group",barrierDismissible: true);

    Dio dio = new Dio();
    FormData formdata = new FormData();
    formdata = FormData.fromMap({
      'name': _nameController.text,
      'user_id': organizerId,
      'image': imageUrl,
      'description': _descriptionController.text,
    });
    var response=await dio.post(
        '$apiUrl/api/creategroup',
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

  var _nameController=TextEditingController();
  var _descriptionController=TextEditingController();
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
                Text("Create Group",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),)
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


                    Text("Select Cover",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),),
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
                      controller: _nameController,
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
                        hintText: "Enter Group Name",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _descriptionController,
                      style: TextStyle(color: Colors.black),
                      minLines: 3,
                      maxLines: 3,
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
                        hintText: "Enter Group Description",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),



                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        if (_formKey.currentState!.validate()) {
                          createGroup(provider.userData!.id,provider.userData!.apitoken);
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
                        child: Text("Create Group",style: TextStyle(fontSize:18,fontWeight: FontWeight.w500,color: Colors.white),),
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
