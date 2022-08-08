
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future signInWithEmailAndPassword(String email, String password) async{
    try {
      var result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User firebaseUser = result.user;
    }catch(e){
    }
  }
}