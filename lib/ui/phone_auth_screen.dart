import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import '../services/auth.dart';


class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  int start = 30;
  bool wait = false;
  String buttonName = "Send";
  TextEditingController phoneNumberController = TextEditingController();
  Authentication authentication =Authentication();
  String verificationIdFinal ="";
  String smsCode = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: Text('Sign IN',
                style: TextStyle(
                    color: Colors.white,fontSize: 20,fontWeight: FontWeight.w700
            ),
            ),
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 150),
                  textField(),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: 1,
                            decoration: BoxDecoration(
                              color: Colors.grey
                            ),
                          ),
                        ),
                        Text('Enter 6 digit OTP'),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: 1,
                            decoration: BoxDecoration(
                                color: Colors.grey
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  otpField(),
                  SizedBox(height: 30),
                  RichText(text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Send OTP again in ",
                        style: TextStyle(
                          color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400)
                      ),
                      TextSpan(
                          text: "00:$start",
                          style: TextStyle(
                              color: Colors.pinkAccent,fontSize: 12,fontWeight: FontWeight.w400)
                      ),
                      TextSpan(
                          text: " sec",
                          style: TextStyle(
                              color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400)
                      )
                    ]
                  )),
                  SizedBox(height: 100),
                  InkWell(
                    onTap: () {
                      Authentication().signInWithPhoneNumber(verificationIdFinal, smsCode, context);
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text('Submit',style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,fontWeight: FontWeight.w600
                        )),
                      ),
                    ),
                  )
                ],
              )
            ),
          )
        )
    );
  }

  void startTimer(){
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if(start == 0){
        setState(() {
          timer.cancel();
          wait= false;
        });
      }else{
        setState(() {
          start--;
        });
      }
    });
  }

  Widget otpField(){
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width,
      fieldWidth: 40,
      otpFieldStyle: OtpFieldStyle(
        backgroundColor: Colors.black12,
      ),
      style: TextStyle(
          fontSize: 18,
        color: Colors.black,
      ),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.box,
      onChanged: (value){
        smsCode = value;
      },
      onCompleted: (pin) {
        print("Completed: " + pin);
        setState(() {
          smsCode=pin;
        });
      },
    );
  }

  Widget textField(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black12
      ),
      child: TextFormField(
        controller: phoneNumberController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
        ],
        style: TextStyle(
          color: Colors.deepOrange,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter your Mobile number',
          hintStyle: TextStyle(fontSize: 15,color: Colors.white),
          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 19),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 19),
            child: Text("(+91)",
            style: TextStyle(fontSize: 15,color: Colors.deepOrange),
            ),
          ),
          suffixIcon: InkWell(
            onTap: wait?null: () async{
              startTimer();
              setState(() {
                start = 30;
                wait = true;
                buttonName= "Resend";
              });
              await authentication.verifyPhoneNumber("+91${phoneNumberController.text}", context, setData);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child: Text(buttonName,
                style: TextStyle(fontSize: 16,color: wait? Colors.grey : Colors.green,fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void setData(verificationId){
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTimer();
  }
}
