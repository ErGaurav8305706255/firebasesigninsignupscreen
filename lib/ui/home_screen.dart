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
    .doc(user?.uid)
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
                const Text('Welcome Home Screen',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w800,
                      fontSize: 25
                  ),),
                const SizedBox(height: 80),
                Text("User Name:-  ${loggedInUser.username}",
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                    fontSize: 20
                ),),
                const SizedBox(height: 20),
                Text("Email ID:-  ${loggedInUser.email}",
                  style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20
                  ),),
                const SizedBox(height: 40),
                InkWell(
                  onTap: () {
                    logout(context);
                  },
                  child: Container(
                    height: 50,width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange
                    ),
                    child: const Center(
                      child: Text('Logout',style: TextStyle(
                        fontSize: 18,
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
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignInScreen()));
  }
}
