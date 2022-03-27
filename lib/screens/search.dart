import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:weweyou/model/event_model.dart';
import 'package:weweyou/model/group_model.dart';
import 'package:weweyou/provider/UserDataProvider.dart';
import 'package:weweyou/screens/group_screen.dart';
import 'package:weweyou/utils/constants.dart';
import 'package:weweyou/widgets/event_card.dart';
import 'package:weweyou/widgets/simple_appbar.dart';

import 'event_detail.dart';
import 'my_event_detail.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String dropdownValue='Search by Location';
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
              Text("Search",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),)
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
              child: Column(
                children: [

                  Expanded(
                    child: FutureBuilder<List<_SearchModel>>(
                        future: getSearchData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {

                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          else {
                            if (snapshot.hasError) {
                              // Return error
                              print("fav error ${snapshot.error.toString()}");
                              return Center(
                                child: Text("Something went wrong"),
                              );
                            }
                            else {
                              List<_SearchModel> events=[];
                              List<_SearchModel> itineraries=[];
                              List<_SearchModel> groups=[];
                              snapshot.data!.forEach((element) {
                                if(element.type==1)
                                  events.add(element);
                                else if(element.type==2)
                                  itineraries.add(element);
                                else if(element.type==3)
                                  groups.add(element);
                              });
                              return Column(

                                children: [
                                  Container(
                                      height: 50,

                                      child:TypeAheadField(
                                        textFieldConfiguration: TextFieldConfiguration(


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
                                            hintText: 'Search event, group or itinerary',
                                            // If  you are using latest version of flutter then lable text and hint text shown like this
                                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                          ),
                                        ),
                                        suggestionsCallback: (pattern) async {

                                          List<_SearchModel> searchList=[];
                                          snapshot.data!.forEach((element) {
                                            if (element.name.contains(pattern))
                                              searchList.add(element);
                                          });

                                          return searchList;
                                        },
                                        itemBuilder: (context, _SearchModel suggestion) {
                                          return Column(
                                            children: [
                                              if(suggestion.type==1)
                                                ListTile(
                                                  leading: Icon(Icons.calendar_today),
                                                  title: Text(suggestion.name),
                                                  subtitle: Text("Event"),
                                                )
                                              else if(suggestion.type==2)
                                                ListTile(
                                                  leading: Icon(Icons.list),
                                                  title: Text(suggestion.name),
                                                  subtitle: Text("Itinerary"),
                                                )
                                              else if(suggestion.type==3)
                                                  ListTile(
                                                    leading: Icon(Icons.people),
                                                    title: Text(suggestion.name),
                                                    subtitle: Text("Group"),
                                                  )
                                            ],
                                          );
                                        },
                                        onSuggestionSelected: (_SearchModel suggestion) {

                                          if(suggestion.type==1){
                                            if(suggestion.model.userId==provider.userData!.id){
                                              Navigator.push(context, new MaterialPageRoute(
                                                  builder: (context) => MyEventDetail(suggestion.model)));
                                            }
                                            else{

                                              Navigator.pushReplacement(context, new MaterialPageRoute(
                                                  builder: (context) => EventDetail(suggestion.model,provider.userData!.id,provider.userData!.apitoken)));
                                            }

                                          }
                                          else if(suggestion.type==2) {

                                          }
                                          else if(suggestion.type==3){
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GroupScreen(suggestion.model,provider.userData!.id,provider.userData!.apitoken)));
                                          }
                                        },
                                      )
                                  ),
                                  Expanded(
                                    child: DefaultTabController(
                                        length: 3,
                                        child:Column(
                                          children: [
                                            TabBar(
                                              labelColor:primary,
                                              unselectedLabelColor: Colors.white,
                                              indicatorWeight: 0.5,

                                              labelStyle: TextStyle(fontSize: 10),

                                              tabs: [
                                                Tab(text: 'EVENTS',),
                                                Tab(text: 'ITINERARY'),
                                                Tab(text: 'GROUPS'),
                                              ],
                                            ),

                                            Container(
                                              height: MediaQuery.of(context).size.height*0.78,

                                              child: TabBarView(children: <Widget>[
                                                Container(
                                                    child:  ListView.builder(
                                                      itemCount: events.length,
                                                      itemBuilder: (BuildContext context, int index){
                                                        //print("id idddd ${snapshot.data![index].id}");
                                                        return Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: EventCard(events[index].model,"user_view"),
                                                        );
                                                      },
                                                    )
                                                ),
                                                Center(
                                                  child: Text("No Itineraries",style: TextStyle(color: Colors.white),),
                                                ),
                                                Container(
                                                  child:  ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: groups.length,
                                                    itemBuilder: (BuildContext context, int index){
                                                      return  ListTile(
                                                        onTap: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GroupScreen(groups[index].model,provider.userData!.id,provider.userData!.apitoken)));
                                                        },
                                                        leading: Container(
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage(groups[index].model.image),
                                                                fit: BoxFit.cover
                                                            ),
                                                            shape: BoxShape.circle,
                                                          ),
                                                          height: 50,
                                                          width: 50,
                                                        ),
                                                        title: Text(groups[index].name,style: TextStyle(color: Colors.white)),
                                                        //subtitle: Text("${snapshot.data![index].membersId.length} members",style: TextStyle(color: Colors.white),),
                                                      );
                                                    },
                                                  ),
                                                ),

                                              ]),
                                            )

                                          ],

                                        )
                                    ),
                                  )
                                ],
                              );
                            }
                          }
                        }
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
  Future<List<_SearchModel>> getSearchData()async{
    List<_SearchModel> searchItems=[];

    var response= await Dio().get('$apiUrl/api/events');
    if(response.statusCode==200 && response.data['code']=="200"){
      EventModelClass eventModel=EventModelClass.fromJson(response.data);
      eventModel.data.forEach((element) {
        _SearchModel model=_SearchModel(element, 1, element.title);
        if(element.is_active==1)
          searchItems.add(model);
      });
    }


    var groupResponse= await Dio().get('$apiUrl/api/groups');
    if(groupResponse.statusCode==200 && groupResponse.data['code']=="200"){
      GroupModel groupModel=GroupModel.fromJson(groupResponse.data);
      groupModel.data.forEach((element) {
        _SearchModel model=_SearchModel(element, 3, element.name);
        searchItems.add(model);
      });
    }


    return searchItems;
  }

}
class _SearchModel{
  var model;
  int type;
  String name;

  _SearchModel(this.model, this.type, this.name);
}
