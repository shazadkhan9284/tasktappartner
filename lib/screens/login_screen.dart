
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_database/firebase_database.dart';
  import 'package:flutter/material.dart';
  import 'package:fluttertoast/fluttertoast.dart';
  import 'package:tasktap_partner/screens/register_screen.dart';
  import '../global/global.dart';
  import '../splashScreen/splash_screen.dart';
  import 'forgot_password_screen.dart';
  import 'main_screen.dart';
  
  void main() {
    runApp(MyApp());
  }
  
  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        theme: ThemeData(
          // Set cursor color to black
          textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
        ),
        home: LoginScreen(),
      );
    }
  }

  class LoginScreen extends StatefulWidget {
    LoginScreen({Key? key}) : super(key: key);

    bool _passwordVisible = false;
    final _formKey = GlobalKey<FormState>();

    final TextEditingController emailTextEditingController = TextEditingController();
    final TextEditingController passwordTextEditingController = TextEditingController();

    void _submit(BuildContext context) async {
      if (_formKey.currentState!.validate()) {
        try {
          final authResult = await firebaseAuth.signInWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim(),
          );

          final userRef = FirebaseFirestore.instance.collection("partner");
          final snapshot = await userRef.doc(authResult.user!.uid).get();

          if (snapshot.exists) {
            await Fluttertoast.showToast(msg: "Successfully Logged In");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          } else {
            await Fluttertoast.showToast(msg: "No record exists with this email");
            firebaseAuth.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SplashScreen()),
            );
          }
        } catch (e) {
          Fluttertoast.showToast(msg: "Error occurred: $e");
        }
      } else {
        Fluttertoast.showToast(msg: "Not all fields are valid");
      }
    }

    @override
    _LoginScreenState createState() => _LoginScreenState();
  }

  class _LoginScreenState extends State<LoginScreen> {
    @override
    Widget build(BuildContext context) {
      bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

      return Scaffold(
        body: SingleChildScrollView( // Wrap with SingleChildScrollView
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                child: Image.asset(
                  darkTheme ? 'images/rbgl.png' : 'images/rbgl.png',
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
                        TextFormField(
                          controller: widget.passwordTextEditingController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: 'Enter your password',
                            hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.yellow),
                            ),
                          ),
                          obscureText: !widget._passwordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            widget._submit(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.yellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (c) => ForgotPasswordScreen()));
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => RegisterScreen()));
                          },
                          child: Text(
                            'Create an account',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
