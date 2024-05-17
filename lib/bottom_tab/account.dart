import 'package:flutter/material.dart';
import 'package:tasktap_partner/bottom_tab/profile_screen.dart';
import '../global/global.dart';
import '../screens/login_screen.dart';
import '../splashScreen/splash_screen.dart';
import '../screens/main_screen.dart';
import 'aboutus.dart';
import 'contacus.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => MainScreen()));}
        ),
        title: Text(
          'Account',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xff928883),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              if (userModelCurrentinfo != null && userModelCurrentinfo!.name != null)
                Text(
                  userModelCurrentinfo!.name!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),

              // Add code here to display the user's image
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
                  children: [
                    SizedBox(width: 10), // Add some space between the icon and the image
                    Image.asset(
                      'images/ttplogo.png', // Replace 'your_image.png' with the path to your image
                      width: 120, // Adjust the width as needed
                      height: 120, // Adjust the height as needed
                    ),
                  ],
                ),
              ),


              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => MyHomePage()));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.edit, color: Colors.yellow, size: 25),
                      SizedBox(width: 10),
                      Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Call the share method to share referral information
                  //CustomShare.share('Check out TaskTap! Earn ₹500 on signup!', subject: 'TaskTap Referral');
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.monetization_on, color: Colors.yellow, size: 25),
                      SizedBox(width: 10),
                      Text(
                        "Refer And Earn ₹500",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => ContactUsApp()));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.phone, color: Colors.yellow, size: 25),
                      SizedBox(width: 10),
                      Text(
                        "Contact Support",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => AboutUsPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.library_books, color: Colors.yellow, size: 25),
                      SizedBox(width: 10),
                      Text(
                        "Terms And Conditions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => AboutUsPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.info, color: Colors.yellow, size: 25),
                      SizedBox(width: 10),
                      Text(
                        "About Us",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => ContactUsApp()));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.help, color: Colors.yellow, size: 25),
                      SizedBox(width: 10),
                      Text(
                        "Help Center",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Logout functionality
                  firebaseAuth.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => SplashScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Logout",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.red, // Changed to red color
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.logout, color: Colors.red, size: 30), // Icon
                  ],
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.red, // Changed to red color
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.login, color: Colors.red, size: 30), // Icon
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xff928883), // Set background color to transparent
    );
  }
}

