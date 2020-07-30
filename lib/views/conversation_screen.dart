import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessageStream;
  // ignore: non_constant_identifier_names
  Widget ChatMessageList(){
  return StreamBuilder(
    stream: chatMessageStream,
    builder: (context,snapShot){
      return snapShot.hasData ? ListView.builder(
          itemCount : snapShot.data.documents.length,
      itemBuilder: (context, index){
      return MessageTile(snapShot.data.documents[index].data["message"],
          snapShot.data.documents[index].data["sendBy"] == Constants.myName
      );
    }) : Container();
  },
);

  }

  sendMessage(){
    if(messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };

      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text="";
    }
  }

  @override
  void initState(){
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream = value;
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('ChatApp'),
      ),
      body: Container(
        child: Stack(
            children: [
              ChatMessageList(),
              Container(
                alignment: Alignment.bottomCenter,

                padding: EdgeInsets.only(top: 100,left: 10,right: 10,bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            hintText: "Message",
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
                        onPressed: (){
                          sendMessage();
                        },
                        child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue,
                                    Colors.white
                                  ],

                                ),
                                borderRadius: BorderRadius.circular(40)
                            ),
                            padding: EdgeInsets.all(12),
                            child: Image.asset("assets/plane.png",
                              height: 25, width: 25,)),

                      ),
                    ),
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: isSendByMe ? 10 : 0, left:  isSendByMe ? 0 : 10 ) ,
      margin: EdgeInsets.symmetric(vertical: 8,),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
           color: isSendByMe ? Colors.deepPurple[200] :  Colors.cyan[100],
          borderRadius: isSendByMe ? 
              BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(40),
                bottomLeft: Radius.circular(30),
              ) :
          BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          )

        ),
        child: Text(message, style: TextStyle(
        color: Colors.black87
        ),),
      ),
    );
  }
}
