
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:weweyou/model/user_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/event_detail.dart';
import 'package:weweyou/screens/home.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/utils/sharedPref.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  bool signUp=false,logIn=false,main=false;

  @override
  void initState() {
    super.initState();
    setState(() {
      main=true;
    });
  }
  var changeEmailController=TextEditingController();
  Future<void> _showPasswordDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text('Change Password',style: TextStyle(color: Colors.white),),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text("A mail has been sent to you. Please check your mail for reset password link",style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showErrorDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text('Error',style: TextStyle(color: Colors.white),),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text(message,style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showForgotPasswordDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              insetAnimationDuration: const Duration(seconds: 1),
              insetAnimationCurve: Curves.fastOutSlowIn,
              elevation: 2,

              child: Container(
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width*0.5,
                decoration: BoxDecoration(
                    color: lightBackgroundColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Form(
                  key: _forgotFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text('Forgot Password',textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.white),),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.all(10),

                            ),
                          )
                        ],
                      ),

                      Expanded(
                        child: ListView(
                          children: [
                            TextFormField(
                              style: TextStyle(color: Colors.black),

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: changeEmailController,
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
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.grey[200],
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),



                            SizedBox(height: 15,),
                            InkWell(
                              onTap: ()async{
                                final ProgressDialog pr = ProgressDialog(context: context);
                                if (_forgotFormKey.currentState!.validate()) {
                                  /*final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                                  await firebaseAuth.sendPasswordResetEmail(email: changeEmailController.text.trim()).then((value){
                                    Navigator.pop(context);
                                    _showPasswordDialog();

                                  }).catchError((onError){
                                    Navigator.pop(context);
                                    _showErrorDialog(onError.toString());
                                    print(onError.toString());

                                  });*/
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
                                  child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)

                              ),
                            ),
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

  String text="Hi!";
  var emailController=TextEditingController();
  var confirmPasswordController=TextEditingController();
  var loginPasswordController=TextEditingController();
  var registerPasswordController=TextEditingController();
  var firstNameController=TextEditingController();
  var lastNameController=TextEditingController();
  var locationController=TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final _forgotFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.black],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/images/slide3.png',
                height: MediaQuery.of(context).size.height*0.6,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.25,
                left: 20
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      main=true;
                      logIn=false;
                      text="Hi!";
                      signUp=false;
                    });
                  },
                  child: CircleAvatar(
                    maxRadius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.arrow_back_ios_rounded,color: primary,size: 15,),
                  ),
                ),
                SizedBox(width: 10,),
                Text(text,style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: AnimatedContainer(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.3,
                  bottom: MediaQuery.of(context).size.height*0.1
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20)
              ),
              width: MediaQuery.of(context).size.width*0.9,
              height: main ? MediaQuery.of(context).size.height*0.7 : 0.0,
              alignment: Alignment.center,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.black),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: emailController,
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
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[200],
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        setState(() {
                          main=false;
                          logIn=true;
                          text="Login!";
                          signUp=false;
                        });
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
                          child: Text("Continue",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)

                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("or",style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: ()async{
                        // Trigger the sign-in flow

                        await FacebookAuth.instance.login().then((value)async{
                          /*final graphResponse = await Dio().get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${value.accessToken!.token}');

                          final profile = jsonDecode(graphResponse.data);
                          print("profile : $profile");*/
                          /*final ProgressDialog pr = ProgressDialog(context: context);
                          pr.show(max: 100, msg: "Logging In");
                          Dio dio = new Dio();
                          FormData formdata = new FormData();

                          formdata = FormData.fromMap({
                            'email': value.accessToken!.email,
                            'fb_id': value.accessToken!.token,
                          });
                          var response = await dio.post(
                              '$apiUrl/api/fblogin',
                              data: formdata, options: Options(
                              method: 'POST',
                              responseType: ResponseType
                                  .json // or ResponseType.JSON
                          )
                          );
                          if (response.statusCode == 200) {
                            if(response.data['code']=="200"){
                              SignupModel user=SignupModel.fromJson(response.data);
                              final provider = Provider.of<UserDataProvider>(context, listen: false);
                              print("apitokenn ${user.data.apitoken}");
                              provider.setUserData(user.data);
                              setPrefUserId(user.data.id.toString());
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomePage()));
                            }
                            else{
                              pr.close();
                              final snackBar = SnackBar(content: Text("Error : ${response.data['mesaage']}"),backgroundColor: Colors.red,);
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }

                          }
                          else {
                            final snackBar = SnackBar(
                              content: Text("Error : unable to login"),
                              backgroundColor: Colors.red,);
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar);
                          }*/
                        });

                      },
                      child: Container(
                          height: 50,
                          padding: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width*0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white
                          ),
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                  child: Image.asset("assets/images/facebook.png")
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: Text("Continue with Facebook",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),

                              ),
                            ],
                          )

                      ),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: ()async{
                        GoogleSignIn _googleSignIn = GoogleSignIn(
                          scopes: [
                            'email',
                            'https://www.googleapis.com/auth/contacts.readonly',
                          ],
                        );
                        await _googleSignIn.signIn().then((value)async{
                          print("id = ${value!.id} ${value.email}");
                          final ProgressDialog pr = ProgressDialog(context: context);
                          pr.show(max: 100, msg: "Logging In");
                          Dio dio = new Dio();
                          FormData formdata = new FormData();

                          formdata = FormData.fromMap({
                            'email': value.email,
                            'google_id': value.id,
                          });
                          var response = await dio.post(
                              '$apiUrl/api/googlesignup',
                              data: formdata, options: Options(
                              method: 'POST',
                              responseType: ResponseType
                                  .json // or ResponseType.JSON
                          )
                          );
                          if (response.statusCode == 200) {
                            if(response.data['code']=="200"){
                              SignupModel user=SignupModel.fromJson(response.data);
                              final provider = Provider.of<UserDataProvider>(context, listen: false);
                              print("apitokenn ${user.data.apitoken}");
                              provider.setUserData(user.data);
                              setPrefUserId(user.data.id.toString());
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomePage()));
                            }
                            else{
                              pr.close();
                              final snackBar = SnackBar(content: Text("Error : ${response.data['mesaage']}"),backgroundColor: Colors.red,);
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }

                          }
                          else {
                            final snackBar = SnackBar(
                              content: Text("Error : unable to login"),
                              backgroundColor: Colors.red,);
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar);
                          }
                        });


                      },
                      child: Container(
                          height: 50,
                          padding: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width*0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white
                          ),
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset("assets/images/google.png")
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text("Continue with Google",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),

                              ),
                            ],
                          )

                      ),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GetStarted()));

                      },
                      child: Container(
                          height: 50,
                          padding: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width*0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white
                          ),
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset("assets/images/apple.png")
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text("Continue with Apple",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),

                              ),
                            ],
                          )

                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      child: Row(
                        children: [
                          Text("Don't have an account?",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500)),
                          InkWell(
                            onTap: (){
                              setState(() {
                                main=false;
                                logIn=false;
                                signUp=true;
                                text="Sign Up";
                              });
                            },
                              child: Text("  Sign Up",style: TextStyle(color: primary,fontSize: 15,fontWeight: FontWeight.w500))),

                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        _showForgotPasswordDialog();
                      },
                      child: Text("Forgot your password?",style: TextStyle(color: primary,fontSize: 15,fontWeight: FontWeight.w500)),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: AnimatedContainer(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.1,
                  bottom: MediaQuery.of(context).size.height*0.1
              ),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20)
              ),
              width: MediaQuery.of(context).size.width*0.9,
              height: logIn ? MediaQuery.of(context).size.height*0.38 : 0.0,
              alignment: Alignment.center,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _loginFormKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        style: TextStyle(color: Colors.black),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller: emailController,
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
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[200],
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        style: TextStyle(color: Colors.black),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller: loginPasswordController,
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
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[200],
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: ()async{
                          final ProgressDialog pr = ProgressDialog(context: context);
                          if (_loginFormKey.currentState!.validate()) {
                            pr.show(max: 100, msg: "Logging In");
                            Dio dio = new Dio();
                            FormData formdata = new FormData();

                            formdata = FormData.fromMap({
                              'email': emailController.text,
                              'password': loginPasswordController.text.trim(),
                            });
                            var response = await dio.post(
                                '$apiUrl/api/signin',
                                data: formdata, options: Options(
                                method: 'POST',
                                responseType: ResponseType
                                    .json // or ResponseType.JSON
                            )
                            );
                            if (response.statusCode == 200) {
                              if(response.data['code']=="200"){
                                SignupModel user=SignupModel.fromJson(response.data);
                                final provider = Provider.of<UserDataProvider>(context, listen: false);
                                print("apitokenn ${user.data.apitoken}");
                                provider.setUserData(user.data);
                                setPrefUserId(user.data.id.toString());
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HomePage()));
                              }
                              else{
                                pr.close();
                                final snackBar = SnackBar(content: Text("Error : ${response.data['mesaage']}"),backgroundColor: Colors.red,);
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }

                            }
                            else {
                              final snackBar = SnackBar(
                                content: Text("Error : unable to login"),
                                backgroundColor: Colors.red,);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar);
                            }
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
                            child: Text("Continue",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)

                        ),
                      ),
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          _showForgotPasswordDialog();
                        },
                        child: Text("Forgot your password?",style: TextStyle(color: primary,fontSize: 15,fontWeight: FontWeight.w500)),
                      )
                      ]

                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: AnimatedContainer(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.3,
                  bottom: MediaQuery.of(context).size.height*0.1
              ),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20)
              ),
              width: MediaQuery.of(context).size.width*0.9,
              height: signUp ? MediaQuery.of(context).size.height*0.6 : 0.0,
              alignment: Alignment.center,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                      children: [
                        TextFormField(
                          style: TextStyle(color: Colors.black),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: emailController,
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
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[200],
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              flex:1,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: TextFormField(
                                  style: TextStyle(color: Colors.black),

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  controller: firstNameController,
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
                                    hintText: "First Name",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex:1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: TextFormField(
                                  style: TextStyle(color: Colors.black),

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  controller: lastNameController,
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
                                    hintText: "Last Name",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: registerPasswordController,
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
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[200],
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: confirmPasswordController,
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
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[200],
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onTap: ()async{
                            LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    PlacePicker(mapApiKey)));

                            // Handle the result in your way
                            print(result);
                            locationController.text=result.formattedAddress.toString();
                          },
                          readOnly: true,
                          controller: locationController,
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
                            hintText: "Location",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[200],
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("By selecting agree and continue below,",style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w300)),
                              Row(
                                children: [
                                  Text("I agree",style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w300)),

                                  Text(" Terms of service and privacy policy",style: TextStyle(color: primary,fontSize: 15,fontWeight: FontWeight.w500)),
                                ],
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: ()async{
                            final ProgressDialog pr = ProgressDialog(context: context);
                            if (_formKey.currentState!.validate()) {
                              if (registerPasswordController.text == confirmPasswordController.text) {
                                pr.show(max: 100, msg: "Signing Up User",barrierDismissible: true);
                                Dio dio = new Dio();
                                FormData formdata = new FormData();

                                formdata = FormData.fromMap({
                                  'name': "${firstNameController.text} ${lastNameController.text}",
                                  'email': emailController.text,
                                  'address': locationController.text,
                                  'password': registerPasswordController.text.trim(),
                                  //"FileName" : fileName,
                                  /*"ImageFile": await MultipartFile.fromFile(
                                    imageFile.path,
                                    filename: fileName,
                                    //contentType: new MediaType("image", "jpeg"),
                                  )*/
                                });
                                var response= await dio.post(
                                    '$apiUrl/api/signup',
                                    data: formdata, options: Options(
                                    method: 'POST',
                                    responseType: ResponseType.json // or ResponseType.JSON
                                  )
                                );
                                print("repsonse ${response.statusCode} ${response.data}");
                                if(response.statusCode==200){
                                  if(response.data['code']=="200"){
                                    SignupModel user=SignupModel.fromJson(response.data);
                                    final provider = Provider.of<UserDataProvider>(context, listen: false);
                                    provider.setUserData(user.data);
                                    setPrefUserId(user.data.id.toString());
                                    pr.close();
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                                  }
                                  else{
                                    pr.close();
                                    final snackBar = SnackBar(content: Text("Error : ${response.data['mesaage']}"),backgroundColor: Colors.red,);
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }

                                }
                                else{
                                  pr.close();
                                  final snackBar = SnackBar(content: Text("Error : Unable to register user"),backgroundColor: Colors.red,);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                                /*coll.insertOne({
                                  'id':userId,
                                  'firstName': firstNameController.text,
                                  'lastName': lastNameController.text,
                                  'email': emailController.text,
                                  'location': locationController.text,
                                  'phone': "none",
                                  'password': registerPasswordController.text.trim(),
                                  'avatar': "none",
                                }).then((value){
                                  UserModel user=new UserModel(
                                    userId,
                                    firstNameController.text,
                                    lastNameController.text,
                                    emailController.text,
                                    "none",
                                    locationController.text,
                                    "none"
                                  );
                                  final provider = Provider.of<UserDataProvider>(context, listen: false);
                                  provider.setUserData(user);
                                  setUserData(userId);
                                  db.close();
                                  pr.close();
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));

                                }).onError((error, stackTrace) {
                                  db.close();
                                  pr.close();
                                  final snackBar = SnackBar(content: Text("Error : ${error.toString()}"),backgroundColor: Colors.red,);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                });
                                pr.close();
                              }*/
                              }
                              else {
                                final snackBar = SnackBar(
                                  content: Text("Error : password donot match"),
                                  backgroundColor: Colors.red,);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    snackBar);
                              }
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
                              child: Text("Agree & Continue",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)

                          ),
                        ),
                      ]

                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
