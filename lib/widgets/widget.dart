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
    hintStyle: const TextStyle(
      color: Colors.cyanAccent,
    ),
    labelText: hintText,
    labelStyle: const TextStyle(color: Colors.teal),
    filled: true,
    fillColor: Colors.transparent,
    focusedBorder:
        const OutlineInputBorder(borderSide: BorderSide(color: Colors.deepOrange,)),
  );
}

TextStyle simpleTextFieldStyle(){
  return const TextStyle(
    color: Colors.green,
  );
}
