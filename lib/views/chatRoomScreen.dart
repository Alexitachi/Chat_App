import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/search.dart';
import 'package:chatapp/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'conversation_screen.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {


  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  @override
  Stream chatRoomsStream;
  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
        itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
  return ChatRoomsTile(
    snapshot.data.documents[index].data["chatRoomId"]
        .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
      snapshot.data.documents[index].data["chatRoomId"]
  );
          }) : Container();
      }
    );
  }
  void initState(){
    getUserInfo();


    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });

    });
    setState(() {

      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('ChatApp'),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: Icon(Icons.search,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SearchScreen()
          ));

        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsTile(this.userName,this.chatRoomId);
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        color: Colors.pink[50],
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: FlatButton(


          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoomId)
            ));

          },
          child: Row(
            children: [

              Container(
                height: 60,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(60)
                ),
                child: Text("${userName.substring(0,1).toUpperCase()}",style: TextStyle(
                  color: Colors.white
                ),),
              ),
              SizedBox(width: 8,),
              Text(userName, style: mediumTextFieldStyle(),)
            ],
          ),
        ),
      ),
    );
  }
}
