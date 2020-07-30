import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatapp/views/chatRoomScreen.dart';
import 'package:chatapp/views/chatRoomScreen.dart';
import 'forgetpassword.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isloading = false;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  QuerySnapshot snapshotUserInfo;
  signIn(){
    if(formKey.currentState.validate()){
      HelperFunctions.savedUserEmailSharedPreference(emailTextEditingController.text);

          setState(() {
            isloading = true;
          });
      databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
        snapshotUserInfo=val;
        HelperFunctions.savedUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
      });
      authMethods.signUpWithEmailandPassword(emailTextEditingController.text, passwordTextEditingController.text)
  .then((val){
    if(val != null){

      HelperFunctions.savedUserLoggedInSharedPreference(true);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder:(context) => ChatRoom()));
      }
    });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      appBar: appBarMain(
        context,),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Image.asset("assets/image.png",height: 200,),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                 Form(
                   key: formKey,
                   child: Column(children: [
                     TextFormField(
                       validator: (val){
                         return RegExp(
                             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                             .hasMatch(val) ? null : "please provide valid Email";
                       },
                       controller: emailTextEditingController,
                       decoration: textFieldInputDecoration("email"),
                       style: simpleTextFieldStyle(),
                     ),
                     TextFormField(
                       obscureText: true,
                         validator: (val){
                           return val.length > 6 ? null : "Please provide 6 charchter password";
                         },
                         controller: passwordTextEditingController,
                         decoration: textFieldInputDecoration("password")
                     ),

                   ],),
                 ),
                     SizedBox(height: 10,),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        },
                        child: Container(
                          child: Text("Forgot Password ?",
                          style: simpleTextFieldStyle(),
                          )
                        ),
                      ),
                      SizedBox(height: 8,),
                      GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16.0))),
                            onPressed: () {
                              signIn();
                            },
                            child: Text("Sign In", style: TextStyle(
                              color: Colors.white,
                              fontSize: 17
                            ),),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          color: Colors.white70,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(16.0))),
                          onPressed: () {},
                          child: Text("Sign In with Google", style: TextStyle(
                              color: Colors.black54,
                              fontSize: 17
                          ),),
                        ),
                      ),
                      SizedBox(height: 16,),

                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: Colors.pinkAccent,
                              height: 8.0,
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            'OR',
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.pinkAccent,
                              height: 8.0,
                            ),
                          )
                        ],
                      ),


                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Not yet Registered? ",style: mediumTextFieldStyle(),),
                          GestureDetector(
                            onTap: (){
                              widget.toggle();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text("Register Now", style: TextStyle(
                                color: Colors.black87,
                                fontSize: 17,
                                decoration: TextDecoration.underline
                              ),),
                            ),
                          )
                        ],

                      ),

                    ]
                  ),
                )
              ],
            ),
          )

        ],
      ),

    );

  }
}
