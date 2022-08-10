import 'package:firebase_login_dummy/ui/signup_screen.dart';
import 'package:firebase_login_dummy/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:fluttertoast/fluttertoast.dart';

import '../services/auth.dart';
import 'home_screen.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  TextEditingController emailTextEditing = TextEditingController();
  TextEditingController passwordTextEditing = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _auth = firebase_auth.FirebaseAuth.instance;
  AuthMethods authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -100,
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(key: _formKey,
                child: Column(
                 mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: emailTextEditing,
                      validator: (value){
                        if(value!.isEmpty){
                          return ('please enter your email');
                        }
                        if(!RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value)){
                          return ('Please valid email id');
                        }
                        return null;
                      },
                        onSaved: (value){
                          emailTextEditing.text = value!;
                        },
                      style: simpleTextFieldStyle(),
                      decoration: textFieldInputDecoration("Email Id")
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordTextEditing,
                        validator: (value){
                          if(value!.isEmpty){
                            return ('please enter your password');
                          }
                          if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value)){
                            return ('Please valid Password');
                          }
                          return null;
                        },
                        onSaved: (value){
                        passwordTextEditing.text = value!;
                        },
                        style: simpleTextFieldStyle(),
                      decoration: textFieldInputDecoration("Password")
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(),
                        const Spacer(),
                        Text('Forget Password?',
                        style: simpleTextFieldStyle(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    InkWell(
                      onTap: () {
                        signIn(emailTextEditing.text, passwordTextEditing.text);
                      },
                      child: Container(
                        height: 50,width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue
                        ),
                        child: const Center(
                          child: Text('Sign In',style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                          )),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        authMethods.googleSignIn(context);
                      },
                      child: Container(
                        height: 50,width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.cyan,width: 1),
                            color: Colors.white
                        ),
                        child: const Center(
                          child: Text('Signing with Google',style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          )),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't Have An Account?"),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                          },
                          child: const Text("Register Now",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline
                          ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth.signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
            Fluttertoast.showToast(msg: "login successfully"),
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        )
      })
          .catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      }
      );
    }
  }
}
