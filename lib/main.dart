import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/views/chatRoomScreen.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/views/signin.dart';
import 'package:chatapp/views/signup.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userISLoggedIn = false;
  @override
  void initstate(){
    super.initState();

  }
  getLoggedInState() async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
setState(() {
  getLoggedInState();
  userISLoggedIn = value;
});
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userISLoggedIn ? ChatRoom() : Authenticate() ,
    );
  }
}
class IamBlank extends StatefulWidget {
  @override
  _IamBlankState createState() => _IamBlankState();
}

class _IamBlankState extends State<IamBlank> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
