import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login_dummy/models/user_model.dart';
import 'package:firebase_login_dummy/ui/signin_screen.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();


  @override
  void initState (){
    super.initState();
    FirebaseFirestore.instance
    .collection("user")
    .doc(user!.uid)
    .get()
    .then((value){
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome HomeScreen',
                  style: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.w800,
                      fontSize: 25
                  ),),
                SizedBox(height: 50),
                Text("${loggedInUser.username}",
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                    fontSize: 20
                ),),
                SizedBox(height: 20),
                Text("${loggedInUser.email}",
                  style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20
                  ),),
                SizedBox(height: 40),
                InkWell(
                  onTap: () {
                    logout(context);
                  },
                  child: Container(height: 50,width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.cyan
                    ),
                    child: const Center(
                      child: Text('Logout',style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      )),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }


  Future<void> logout(BuildContext context)async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInScreen()));
  }
}
