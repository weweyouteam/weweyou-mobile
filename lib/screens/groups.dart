import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:weweyou/model/group_member_model.dart';
import 'package:weweyou/model/group_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/create_group.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/utils/custom_dailogs.dart';

import 'group_screen.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  Future<List<Group>> getDocuments() async {
    var response= await Dio().get('$apiUrl/api/groups');
    print("repsonse ${response.statusCode} ${response.data}");
    List<Group> groups=[];
    if(response.statusCode==200){
      if(response.data['code']=="200"){
        GroupModel groupModel=GroupModel.fromJson(response.data);
        groupModel.data.forEach((element) {
          groups.add(element);
        });
      }
    }
    return groups;

  }

  Future<bool> checkForGroupMember(groupId,userId,apiToken) async {
    print("group Id $groupId : userId $userId");
    var response= await Dio().get('$apiUrl/api/group/members?id=$groupId',
      options: Options(
          headers: {
            "apitoken": apiToken
          }
      ),);
    print("repsonse ${response.statusCode} ${response.data}");
    bool isMember=false;
    if(response.statusCode==200 && response.data['code']=="200"){
      GroupMemberModel groupModel=GroupMemberModel.fromJson(response.data);
      groupModel.data.forEach((element) {
        if(element.memberId==userId){
          isMember=true;
        }
      });
    }
    return isMember;

  }
  Future<void> joinGroupDialog(Group model,int userId,apiToken,BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          insetAnimationDuration: const Duration(seconds: 1),
          insetAnimationCurve: Curves.fastOutSlowIn,
          elevation: 2,

          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    if(model.image=="")
                      Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        image: DecorationImage(
                          image: AssetImage("assets/images/logo.png"),
                          fit: BoxFit.cover,
                        )
                      ),

                    )
                    else
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(model.image),
                              fit: BoxFit.cover,
                            )
                        ),

                      ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15,
                            child: Icon(Icons.close,size: 15,color: Colors.black,),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                    child: Column(
                      children: [
                        Text(model.name,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                      ],
                    )

                ),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: ()async{
                    final ProgressDialog pr = ProgressDialog(context: context);
                    pr.show(max: 100, msg: "Adding");
                    Dio dio = new Dio();
                    FormData formdata = new FormData();
                    formdata = FormData.fromMap({
                      'group_id': model.id,
                    });
                    var response=await dio.post(
                        '$apiUrl/api/join/group',
                        data: formdata,
                        options: Options(
                          headers: {
                            "apitoken": apiToken
                          },
                          method: 'POST',
                          responseType: ResponseType.json,

                        )
                    );
                    if(response.statusCode==200){
                      if(response.data['code']=="200"){
                        pr.close();
                        final snackBar = SnackBar(content: Text("${response.data['message']}"),backgroundColor: Colors.green,);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => GroupScreen(model,userId,apiToken)));
                      }
                      else{
                        pr.close();
                        final snackBar = SnackBar(content: Text("Error : ${response.data['message']}"),backgroundColor: Colors.red,);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }

                    }
                    else{
                      pr.close();
                      final snackBar = SnackBar(content: Text("Error : Unable to join group"),backgroundColor: Colors.red,);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }


                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40,right: 40),
                    child:Text('JOIN GROUP',style: TextStyle(color:Colors.white,fontSize: 15,fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        color: Colors.red.shade900,
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => CreateGroup()));
        },
        backgroundColor: primary,
        child: Icon(Icons.add,color: Colors.white,),
      ),
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
                Text("Groups",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),)
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
                child: FutureBuilder<List<Group>>(
                    future: getDocuments(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {

                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      else {
                        if (snapshot.hasError) {
                          print("error ${snapshot.error}");
                          return Center(
                            child: Text("Something went wrong",style: TextStyle(color: Colors.white),),
                          );
                        }
                        else if(snapshot.data!.length==0){
                          return Center(
                            child: Text("No Groups",style: TextStyle(color: Colors.white),),
                          );
                        }
                        else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index){
                              return ListTile(
                                onTap: ()async{
                                  final ProgressDialog pr = ProgressDialog(context: context);
                                  pr.show(max: 100, msg: "Please Wait");
                                  bool isMember=await checkForGroupMember(snapshot.data![index].id,provider.userData!.id,provider.userData!.apitoken);
                                  pr.close();
                                  if(isMember){
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GroupScreen(snapshot.data![index],provider.userData!.id,provider.userData!.apitoken)));

                                  }
                                  else{
                                    joinGroupDialog(snapshot.data![index],provider.userData!.id,provider.userData!.apitoken, context);
                                  }

                                },
                                leading: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(snapshot.data![index].image),
                                        fit: BoxFit.cover
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  height: 50,
                                  width: 50,
                                ),
                                title: Text(snapshot.data![index].name,style: TextStyle(color: Colors.white)),
                                trailing:  Container(
                                  height:50,
                                  width: 50,
                                  child: FutureBuilder<bool>(
                                      future: checkForGroupMember(snapshot.data![index].id,provider.userData!.id,provider.userData!.apitoken),
                                      builder: (context, isMember) {
                                        if (isMember.connectionState == ConnectionState.waiting) {

                                          return Center(child: CupertinoActivityIndicator(),);
                                        }
                                        else {
                                          if (isMember.hasError) {
                                            // Return error
                                            print("error ${isMember.error.toString()}");
                                            return Icon(Icons.error,color: Colors.white,);
                                          }

                                          else {
                                            return isMember.data!?Container():Icon(Icons.person_add_alt,color: Colors.white,);
                                          }
                                        }
                                      }
                                  ),
                                ),
                                //subtitle: Text("${snapshot.data![index].membersId.length} members",style: TextStyle(color: Colors.white),),
                              );
                            },
                          );
                        }
                      }
                    }
                ),
              ),
            )
          ],
      ),
    );
  }
}
