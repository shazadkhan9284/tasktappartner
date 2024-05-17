import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../models/user_model.dart';
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;
UserModel? userModelCurrentinfo;

