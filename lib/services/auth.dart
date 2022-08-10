import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../ui/home_screen.dart';

class AuthMethods {

  Future<void> googleSignIn(BuildContext context) async {
    final _auth = FirebaseAuth.instance;
    User?  user;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = (await googleSignIn.signIn().then((uid) => {
      Fluttertoast.showToast(msg: "login successfully"),
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      )
    })
        .catchError((e){
          Fluttertoast.showToast(msg: e!.message);
        }
        )) as GoogleSignInAccount?;
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      // Getting users credential
      UserCredential result = await _auth.signInWithCredential(authCredential);
      User? user = result.user;
      if (kDebugMode) {
        print('Signup successfully:${user.displayName}');
      }
    }
  }
}