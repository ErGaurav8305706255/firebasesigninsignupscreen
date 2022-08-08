import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login_dummy/models/user_model.dart';
import 'package:firebase_login_dummy/ui/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/widget.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


  TextEditingController usernameTextEditing = TextEditingController();
  TextEditingController emailTextEditing = TextEditingController();
  TextEditingController passwordTextEditing = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

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
                        validator: (value){
                          if(value!.isEmpty){
                            return ('please enter your Name');
                          }
                          if(!RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$").hasMatch(value)){
                            return ('Please valid Name');
                          }
                          return null;
                        },
                        onSaved: (value){
                          usernameTextEditing.text = value!;
                        },
                      controller: usernameTextEditing,

                        style: simpleTextFieldStyle(),
                        decoration: textFieldInputDecoration("User Name")
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
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
                      controller: emailTextEditing,
                        style: simpleTextFieldStyle(),
                        decoration: textFieldInputDecoration("Email Id")
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return ('please enter your password');
                          }
                          if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value)){
                            return ('Please Enter valid password');
                          }
                          return null;
                        },
                      controller: passwordTextEditing,
                        style: simpleTextFieldStyle(),
                        decoration: textFieldInputDecoration("Password")
                    ),

                    const SizedBox(height: 50),
                    InkWell(onTap: () {
                      signUP(emailTextEditing.text, passwordTextEditing.text);

                    },
                      child: Container(
                        height: 50,width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue
                        ),
                        child: const Center(
                          child: Text('SignUp',style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          )),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.cyan,width: 1),
                          color: Colors.white
                      ),
                      child: const Center(
                        child: Text('Sign In with Google',style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        )),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an Account?"),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text("SignIn Now",
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

  void signUP(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
            postDetailsToFirestore()})
      .catchError((e){
        Fluttertoast.showToast(msg: e!.message);
    }
    );
    }
  }
    postDetailsToFirestore() async{

    //calling our firestore
    //calling our usermodel
    //sending these value

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    //writing all the value

    userModel.email = user.email;
    userModel.uid = user.uid;
    userModel.username = usernameTextEditing.text;
    await firebaseFirestore
    .collection('user')
    .doc(user.uid)
    .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");
    Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false);

  }
}
