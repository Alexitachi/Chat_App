import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context)
{
  return AppBar(
    backgroundColor: Colors.pink,
  title: Text('ChatApp'),
  );
}

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
  hintText: hintText,
  focusedBorder: UnderlineInputBorder(
  borderSide: BorderSide(color:  Colors.pink),
  ),
  enabledBorder: UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.black45)
  )
  );
}
TextStyle simpleTextFieldStyle(){
  return TextStyle(
    color: Colors.black
  );
}

TextStyle mediumTextFieldStyle(){
return TextStyle(
    color: Colors.black54,
    fontSize: 17
);
}