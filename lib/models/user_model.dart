import 'package:flutter/cupertino.dart';

class UserModel{
  String? uid;
  String? username;
  String? email;

  UserModel({this.email, this.username, this.uid});

  //Receiving data from server
  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username']
    );
  }
  //sending data to our server
Map<String, dynamic> toMap(){
    return
       {
         'uid': uid,
         'email':email,
         'username':username,
       };

}

}