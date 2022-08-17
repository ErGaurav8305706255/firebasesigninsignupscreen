import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../ui/home_screen.dart';


class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
        await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // handle the error here
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                'The account already exists with a different credential.',
              ),
            );
          }
          else if (e.code == 'invalid-credential') {
            // handle the error here
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          // handle the error here
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign-In. Try again.',
            ),
          );
        }
      }
      return user;
    }
    return null;
  }
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }


Future<void> verifyPhoneNumber(String phoneNumber, BuildContext context,Function setData)async{
    PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential phoneAuthCredential)async {
      showSnackBar(context,"Verification Completed");
    };
    PhoneVerificationFailed verificationFailed =(FirebaseAuthException exception){
      showSnackBar(context,exception.toString());
    };
    PhoneCodeSent codeSent =
        (String verificationID, [int? forceResendingToken]){
          showSnackBar(context,"Verification Code sent on the Phone number");
          setData(verificationID);
        };
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID){
          showSnackBar(context,"Time Out");
        };

    try{
      await _auth.verifyPhoneNumber(phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    }catch(e){
      showSnackBar(context,e.toString());
    }
}

Future <void> signInWithPhoneNumber(String verificationId, String smsCode, BuildContext context)async{
    try{
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
     UserCredential userCredential= await _auth.signInWithCredential(credential);
     userCredential;
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomeScreen()),
             (route) => false);
     showSnackBar(context, "Logged In Successfully");
    }
        catch(e){
          showSnackBar(context, toString());
        }
}
void showSnackBar(BuildContext context, String text){
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

}

