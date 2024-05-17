import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../global/global.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController emailTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            child: Image.asset(
              darkTheme ? 'images/fgt.jpg' : 'images/fgt.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 350.0,
            left: 15.0,
            right: 15.0,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: widget._formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: widget.emailTextEditingController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (widget._formKey.currentState!.validate()) {
                          // Add logic to send password reset email
                          _sendPasswordResetEmail(widget.emailTextEditingController.text.trim());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        'Send Reset Password link',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                SizedBox(height: 10.0), // Add space between the buttons
                TextButton(
                  child: Text(
                    'Alreday have an Account ? log In',
                    style: TextStyle(color: Colors.black,fontSize: 20.0,),


                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                  },
                )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendPasswordResetEmail(String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email)
      .then((value) {
        Fluttertoast.showToast(msg: "Password reset email sent successfully");
      })
      .catchError((error) {
        Fluttertoast.showToast(msg: "Failed to send password reset email: $error");
      });
  }
}
