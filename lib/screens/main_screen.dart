import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasktap_partner/screens/woks.dart';
import '../bottom_tab/aboutus.dart';
import '../bottom_tab/account.dart';
import '../bottom_tab/contacus.dart';
import '../global/global.dart';
import 'earnings.dart';
import 'login_screen.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Manpower Services',
    home: MainScreen(),
  ));
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);


  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late User? currentUser; // Initialize User? to null
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override


  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back button
        title: Text(
          'TaskTap  👷',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Bell MT', // Use Bell MT font family
            fontWeight: FontWeight.bold, // Make it bold
          ),
        ),
        backgroundColor: Color(0xff928883),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => ContactUsApp()));
            },
            icon: Icon(Icons.headset_mic,color: Colors.yellow, size: 30,),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => AboutUsPage()));
            },
            icon: Icon(Icons.notifications,color: Colors.yellow, size: 30,),
          ),
        ],
      ),

      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bg.png"), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min, // Ensure the column takes the minimum height necessary
            children: [
              SizedBox(height: 20), // Add space at the top
              Container(
                height: 200, // Adjust height as needed
                child: SlideWidget(), // Slide widget added here
              ),
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NewWorksPage()));
                    },
                    child:Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/task.png"),
                          fit: BoxFit.cover,
                        ),
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "TASK",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Explore the latest Work opportunities!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),



                  ),
                ),
              ),
              SizedBox(height: 20), // Add space between text and image
              Stack(
                children: [
                  Image.asset(
                    "images/btg4.png",
                    height: 190.0,
                    width: 410,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ],
          ),

        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
            caption: TextStyle(color: Colors.black), // Set label text color to black
          ),
        ),
        child: BottomNavigationBar(
          // backgroundColor: Color(0xff928883), // Set your desired background color
          selectedItemColor: Colors.black, // Set selected item text color
          unselectedItemColor: Colors.black.withOpacity(0.6), // Set unselected item text color
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on_outlined),
              label: 'Earnings',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Account',
            ),
          ],
          onTap: (int index) {
            // Handle navigation here
            switch (index) {
              case 0:
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => MainScreen()));
                break;
              case 1:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => TotalEarningsPage()));
                break;
              case 2:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => AccountScreen()));
                break;
            }
          },
        ),
      ),







    );
  }
}

class SlideWidget extends StatefulWidget {
  @override
  _SlideWidgetState createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<SlideWidget> with AutomaticKeepAliveClientMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0), // Set border radius
      child: Container(
        height: 250, // Adjust height as needed
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            SlideItem(image: "images/sl1.png"),
            SlideItem(image: "images/sl2.png"),
            SlideItem(image: "images/sl3.png"),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SlideItem extends StatelessWidget {
  final String image;

  const SlideItem({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}