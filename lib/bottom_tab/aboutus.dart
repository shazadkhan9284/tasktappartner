import 'package:flutter/material.dart';

void main() {
  runApp(AboutUsApp());
}

class AboutUsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'About & Terms And Conditions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AboutUsPage(),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('About & Terms And Conditions'),
        backgroundColor: Color(0xff928883), // Background color for app bar
      ),
      backgroundColor: Color(0xfff3f3f3), // Background color for the entire screen
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Terms and Conditions:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'By accessing or using our services, you agree to be bound by these terms and conditions. Please read them carefully. These terms govern your access to and use of our services. If you do not agree with any part of these terms, you may not use our services.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Privacy Policy:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'We respect your privacy and are committed to protecting it. Our Privacy Policy outlines how we collect, use, maintain, and disclose information collected from users of our services. By using our services, you consent to the collection and use of information as described in our Privacy Policy.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.yellow),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome to TaskTap Partner! We\'re thrilled to have you join our network.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'TaskTap Partner is a revolutionary app designed for laborers like you, providing seamless access to work opportunities and empowering you to manage your schedule with ease.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Join our community of skilled laborers who are transforming the way work is accepted and managed. With TaskTap Partner, you have the flexibility to choose the projects that best fit your expertise and availability.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'At TaskTap Partner, we value your skills and dedication. Our platform is built on the principles of fairness, transparency, and empowerment, ensuring that you have the tools and support you need to succeed.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Whether you\'re a carpenter, plumber, electrician, or any other skilled laborer, TaskTap Partner is here to help you connect with clients and grow your business.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Ready to take control of your schedule and maximize your earning potential? Download TaskTap Partner now and join the future of labor management.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Thank you for choosing TaskTap Partner. We\'re committed to empowering you on your journey to success.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
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

            ],
          ),
        ),
      ),
    );
  }
}
