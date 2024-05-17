import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../screens/forgot_password_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      theme: ThemeData(
        backgroundColor: Color(0xff928883),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  late DocumentSnapshot? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      String partnerId = user.uid;
      final DocumentSnapshot snapshot = await firestoreInstance
          .collection('partner')
          .doc(partnerId)
          .get();

      setState(() {
        userData = snapshot;
      });
    } else {
      // Handle not authenticated
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      color: Color(0xff928883),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
          backgroundColor: Color(0xff928883),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                if (userData != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUserDataPage(userData: userData!),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        backgroundColor: Color(0xff928883),
        body: userData != null
            ? ListView(
          children: [
            _buildListTile('Name', userData!['name'], Icons.person),
            _buildListTile('Email', userData!['email'], Icons.email),
            _buildListTile('Age', userData!['age'], Icons.cake),
            _buildListTile('Gender', userData!['gender'], Icons.people),
            _buildListTile('Address', userData!['address'], Icons.location_on),
            _buildListTile('Phone', userData!['phone'], Icons.phone),
            _buildListTile('Aadhar Number', userData!['aadharNumber'], Icons.credit_card),
            _buildListTile('Education', userData!['education'], Icons.school),
            _buildListTile('Work Experience', userData!['workexperience'], Icons.work),
          ],
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildListTile(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              SizedBox(width: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.yellow, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                value,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditUserDataPage extends StatefulWidget {
  final DocumentSnapshot userData;

  const EditUserDataPage({Key? key, required this.userData}) : super(key: key);

  @override
  _EditUserDataPageState createState() => _EditUserDataPageState();
}

class _EditUserDataPageState extends State<EditUserDataPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _aadharNumberController;
  late TextEditingController _educationController;
  late TextEditingController _workExperienceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['name']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _ageController = TextEditingController(text: widget.userData['age']);
    _genderController = TextEditingController(text: widget.userData['gender']);
    _addressController = TextEditingController(text: widget.userData['address']);
    _phoneController = TextEditingController(text: widget.userData['phone']);
    _aadharNumberController = TextEditingController(text: widget.userData['aadharNumber']);
    _educationController = TextEditingController(text: widget.userData['education']);
    _workExperienceController = TextEditingController(text: widget.userData['workexperience']);
  }

  Future<void> updateUser() async {
    final updatedData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'age': _ageController.text,
      'gender': _genderController.text,
      'address': _addressController.text,
      'phone': _phoneController.text,
      'aadharNumber': _aadharNumberController.text,
      'education': _educationController.text,
      'workexperience': _workExperienceController.text,
    };

    await FirebaseFirestore.instance
        .collection('partner')
        .doc(widget.userData.id)
        .update(updatedData);

    Fluttertoast.showToast(
      msg: "Update Successful",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Color(0xff928883),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Name', _nameController),
            _buildTextField('Email', _emailController),
            _buildTextField('Age', _ageController),
            _buildTextField('Gender', _genderController),
            _buildTextField('Address', _addressController),
            _buildTextField('Phone', _phoneController),
            _buildTextField('Aadhar Number', _aadharNumberController),
            _buildTextField('Education', _educationController),
            _buildTextField('Work Experience', _workExperienceController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => ForgotPasswordScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
              ),
              child: Text(
                'Reset Password',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: updateUser,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow,
              ),
              child: Text('Update'),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xff928883),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _aadharNumberController.dispose();
    _educationController.dispose();
    _workExperienceController.dispose();
    super.dispose();
  }
}
