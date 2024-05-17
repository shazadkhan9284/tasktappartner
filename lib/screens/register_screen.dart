
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasktap_partner/screens/woks.dart';
import '../global/global.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();
  final educationTextEditingController = TextEditingController();
  final workexperienceTextEditingController = TextEditingController();
  final aadharTextEditingController = TextEditingController();
  final ageTextEditingController = TextEditingController();
  String? selectedGender;
  File? aadharImage;

  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        aadharImage = File(pickedFile.path);
      });
      Fluttertoast.showToast(msg: "Image selected");
    }
  }


  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        );

        // Get the current user
        final User? currentUser = authResult.user;

        if (currentUser != null) {
          String? aadharImageUrl = await uploadAadharImage(aadharImage, currentUser.uid);
          // Prepare user data
          Map<String, dynamic> userMap = {
            "id": currentUser.uid,
            "name": nameTextEditingController.text.trim(),
            "email": emailTextEditingController.text.trim(),
            "address": addressTextEditingController.text.trim(),
            "phone": phoneTextEditingController.text.trim(),
            'workexperience': workexperienceTextEditingController.text.trim(),
            'gender': selectedGender,
            "age": ageTextEditingController.text.trim(),
            'education': educationTextEditingController.text.trim(),
            'aadharNumber': aadharTextEditingController.text.trim(),
            'role': 'partner',
            'totalearnings': 0, // Adding the new field
            'aadharImageUrl': aadharImageUrl,
          };

          // Store user data in Firestore
          await FirebaseFirestore.instance
              .collection('partner')
              .doc(currentUser.uid)
              .set(userMap);

          // Show success message
          Fluttertoast.showToast(msg: "Successfully Registered");

          // Navigate to the main screen
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => MainScreen()));
        }
      } catch (error) {
        // Show error message
        Fluttertoast.showToast(msg: "Error occurred: $error");
      }
    } else {
      // Show validation error message
      Fluttertoast.showToast(msg: "Not all fields are valid");
    }
  }

  Future<String?> uploadAadharImage(File? imageFile, String userId) async {
    if (imageFile == null) return null;

    try {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('aadhar_images').child('$userId.jpg');
      await storageRef.putFile(imageFile);

      // Get download URL
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (error) {
      print("Error uploading Aadhar image: $error");
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery
        .of(context)
        .platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              child: Image.asset(
                darkTheme ? 'images/rbg.png' : 'images/rbg.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 200.0, 15.0, 0.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameTextEditingController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors
                                    .black), // Default border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors
                                    .yellow), // Border color when focused
                              ),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Name can\'t be empty';
                              }
                              if (text.length < 2) {
                                return 'Please enter a valid name';
                              }
                              if (text.length > 40) {
                                return 'Name can\'t be more than 40 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: emailTextEditingController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors
                                    .black), // Default border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors
                                    .yellow), // Border color when focused
                              ),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Email can\'t be empty';
                              }
                              if (!text.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: phoneTextEditingController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors
                                    .black), // Default border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors
                                    .yellow), // Border color when focused
                              ),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Phone number can\'t be empty';
                              }
                              // Add your phone number validation logic here
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: addressTextEditingController,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors
                                    .black), // Default border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors
                                    .yellow), // Border color when focused
                              ),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Address can\'t be empty';
                              }
                              return null;
                            },
                            maxLines: 2,
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: passwordTextEditingController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors
                                    .black), // Default border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors
                                    .yellow), // Border color when focused
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    _passwordVisible ? Icons.visibility : Icons
                                        .visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_passwordVisible,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Password can\'t be empty';
                              }
                              if (text.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: confirmTextEditingController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors
                                    .black), // Default border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors
                                    .yellow), // Border color when focused
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    _passwordVisible ? Icons.visibility : Icons
                                        .visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_passwordVisible,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Confirm Password can\'t be empty';
                              }
                              if (text != passwordTextEditingController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: workexperienceTextEditingController,
                            decoration: InputDecoration(
                              labelText: 'workexperience',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.yellow),
                              ),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'workexperience can\'t be empty';
                              }
                              return null;
                            },
                            maxLines: 2,
                          ),
                          SizedBox(height: 10.0),
                          DropdownButtonFormField<String>(
                            value: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                value: 'Male',
                                child: Text('Male'),
                              ),
                              DropdownMenuItem(
                                value: 'Female',
                                child: Text('Female'),
                              ),
                              DropdownMenuItem(
                                value: 'Other',
                                child: Text('Other'),
                              ),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.yellow),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: ageTextEditingController,
                            decoration: InputDecoration(
                              labelText: 'Enter Your Age',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors
                                    .black), // Default border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors
                                    .yellow), // Border color when focused
                              ),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Age must be 18 or Above';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: educationTextEditingController,
                            decoration: InputDecoration(
                              labelText: 'Educational Qualifications',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.yellow),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: aadharTextEditingController,
                            decoration: InputDecoration(
                              labelText: 'Aadhar Number',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.yellow),
                              ),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Aadhar Number can\'t be empty';
                              }
                              // Add your Aadhar number validation logic here
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () => _getImage(),
                            child: Text('Upload Aadhar Card Image'),
                          ),
                          SizedBox(height: 10.0),
                          // Other form fields...
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.yellow, // Button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  color: Colors.black), // Font color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
