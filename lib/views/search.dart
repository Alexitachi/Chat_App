import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'conversation_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String _myName;
class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap:true,
        itemBuilder: (context, index){
          return SearchTile(
            userName: searchSnapshot.documents[0].data["name"],
            userEmail: searchSnapshot.documents[0].data["email"],
          );
        }) : Container();
  }

  initiateSearch() {
    databaseMethods.getUserByUsername(searchTextEditingController.text)
        .then((val){
      setState(() {
        searchSnapshot = val;
        print("$searchSnapshot");
      });
    });
  }

  createChatRoomAndStartConversation(String userName){

    List<String> users = [Constants.myName,userName];
    String chatRoomId =getChatRoomId( Constants.myName, userName);


    Map<String, dynamic> charRoomMap = {
      "users" : users,
      "chatRoomId" : chatRoomId,
    };
    DatabaseMethods().createChatRoom(chatRoomId, charRoomMap);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ConversationScreen(
          chatRoomId
        )
    ));
  }

  Widget SearchTile({String userName,String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 34, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName,style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),),
              Text(userEmail,style: simpleTextFieldStyle(),)
            ],
          ),
          Spacer(),

          FloatingActionButton(
            onPressed: (){
              createChatRoomAndStartConversation(
                userName
              );
            },
            child: Container(

              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [

                      Colors.greenAccent,
                      Colors.blue,
                      Colors.purpleAccent

                    ],

                  ),
                  borderRadius: BorderRadius.circular(60)
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Image.asset("assets/chat.png",height: 5, width: 5,color: Colors.white,),

            ),
          ),

        ],
      ),
    );
  }


  @override
  void initState() {

    super.initState();
  }

  getUserInfo() async{
    _myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {

    });
    print("${_myName}");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/ab.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                padding: EdgeInsets.only(top: 100,left: 30,right: 30,bottom: 30),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: searchTextEditingController,
                          decoration: InputDecoration(
                            hintText: "Search Username",
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                              filled: true,
                              fillColor: Colors.white70,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                              borderSide: BorderSide(color:  Colors.pink),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                              borderSide: BorderSide(color: Colors.black45)
                              )

                          ),
                        ),
                    ),
                   Padding(
                     padding: const EdgeInsets.only(left:8.0),
                     child: FloatingActionButton(
                       heroTag: "btn1",
                        onPressed: (){
                          initiateSearch();
                        },
                        child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.pink,
                                      Colors.blue
                                    ],

                                ),
                                borderRadius: BorderRadius.circular(60)
                            ),
                            padding: EdgeInsets.all(12),
                            child: Image.asset("assets/search1.png",
                              height: 25, width: 25,color: Colors.white,)),

                      ),
                   ),
                  ],
                ),
              ),
              searchList()
            ],
          ),
        )
      )
    );
  }
}





getChatRoomId(String a, String b){
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)){
    return"$b\_$a";

  }
  else{
    return"$a\_$b";
  }
}