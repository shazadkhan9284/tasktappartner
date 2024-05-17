import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(ContactUsApp());
}

class ContactUsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return MaterialApp(
      title: 'Contact & Help Center',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Set to false to remove the debug banner
      home: ContactUsPage(),
    );
  }
}

class ContactUsPage extends StatelessWidget {
  final String phoneNumber = '+919529629498'; // Change this to your actual phone number
  final String emailAddress = 'shazad9284khan@gmial.com'; // Change this to your actual email address

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact & Help Center '),
        backgroundColor: Color(0xff928883),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Navigate back to previous screen
        ),
      ),
      backgroundColor: Color(0xfff3f3f3),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/ttplogo.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstATop,
              ),
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Phone: $phoneNumber',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  try {
                    launch('tel:$phoneNumber');
                  } catch (e) {
                    print('Error launching phone call: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: Colors.yellow),
                  elevation: 0,
                ),
                child: Text(
                  'Call',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  try {
                    launch('mailto:$emailAddress');
                  } catch (e) {
                    print('Error launching email: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: Colors.yellow),
                  elevation: 0,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, color: Colors.black),
                      SizedBox(width: 5),
                      Text(
                        'Email',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Email: $emailAddress',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      try {
                        launch('https://www.instagram.com/');
                      } catch (e) {
                        print('Error launching Instagram: $e');
                      }
                    },
                    child: Image.asset(
                      'images/instalogo.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      try {
                        launch('https://web.whatsapp.com/');
                      } catch (e) {
                        print('Error launching WhatsApp: $e');
                      }
                    },
                    child: Image.asset(
                      'images/wlogo.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      try {
                        launch('https://www.facebook.com/');
                      } catch (e) {
                        print('Error launching Facebook: $e');
                      }
                    },
                    child: Image.asset(
                      'images/fblogo.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Image.asset(
                    'images/ttplogo.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MSK Enterprises PvtLtd',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'All rights reserved',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Since @2003 ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'MSK Enterprises PvtLtd',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
