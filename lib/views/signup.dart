import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/widget/widget.dart';
import 'chatRoomScreen.dart';
import 'package:chatapp/views/chatRoomScreen.dart';
import 'package:chatapp/helper/helperfunctions.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isloading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();

  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUp(){
    if(formKey.currentState.validate()){
    setState(() {
      isloading = true;
    });
    authMethods.signUpWithEmailandPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
      //print("${val.uid}");

      Map<String, String> userInfoMap = {
        "name" :  userNameTextEditingController.text,
        "email" : emailTextEditingController.text,
      };

      HelperFunctions.savedUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.savedUserNameSharedPreference(userNameTextEditingController.text);

    databaseMethods.uploadUserInfo(userInfoMap);

      HelperFunctions.savedUserLoggedInSharedPreference(true);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => ChatRoom()
      ));
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
      body: isloading ? Container(
        child: Center(child: CircularProgressIndicator(backgroundColor: Colors.pink,)),
      ): Stack(
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
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                validator: (val){
                                  return val.isEmpty || val.length < 4 ? "Please Provide Username": null;
                                },
                                controller: userNameTextEditingController,
                                decoration: textFieldInputDecoration("Username"),
                                style: simpleTextFieldStyle(),
                              ),
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

                            ],
                          ),
                        ),
                        SizedBox(height: 16,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16.0))),
                            onPressed: () {
                              signMeUp();
                            },
                            child: Text("Sign Up", style: TextStyle(
                                color: Colors.white,
                                fontSize: 17
                            ),),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Colors.white70,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16.0))),
                            onPressed: () {

                            },
                            child: Text("Sign Up with Google", style: TextStyle(
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
                            Text("Already Have Account? ",style: mediumTextFieldStyle(),),
                            GestureDetector(
                              onTap: (){
                                widget.toggle();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Text("Login", style: TextStyle(
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
