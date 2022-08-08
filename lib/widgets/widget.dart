import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset(
      'assets/images/Login.jpg',
      height: 100,
      width: 300,
      fit: BoxFit.cover,
      // width: double.infinity,
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.cyanAccent,
    ),
    labelText: hintText,
    labelStyle: TextStyle(color: Colors.teal),
    filled: true,
    fillColor: Colors.transparent,
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.deepOrange,)),
  );
}

TextStyle simpleTextFieldStyle(){
  return TextStyle(
    color: Colors.green,
  );
}
