import 'dart:async';
import 'package:flutter/material.dart';
import '../Assistants/assistant_methods.dart';
import '../global/global.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _zoomAnimation;
  bool _firstImageVisible = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Adjust duration as needed
    );

    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeInOut), // Zoom in first half of animation
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Start zoom out animation when zoom in animation completes
        _animationController.reverse();
      }
    });

    // Start the animation
    _animationController.forward();

    // Start the timer
    startTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void startTimer() {
    Timer(Duration(seconds: 2), () async {
      setState(() {
        _firstImageVisible = false;
      });
      Timer(Duration(seconds: 2), () async {
        if (firebaseAuth.currentUser != null) {
          AssistantsMethods.readCurrentOnlineUsInfo();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => MainScreen()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => LoginScreen()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Color(0xFF928781), // Set background color to yellow
      body: Center(
        child: AnimatedBuilder(
          animation: _zoomAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _zoomAnimation.value,
              child: child,
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_firstImageVisible)
                Expanded(
                  child: Image.asset('images/Splash1.png'), // Replace with your first image
                ),
              SizedBox(height: 20),
              if (!_firstImageVisible)
                Expanded(
                  child: Image.asset('images/Splash2.png'), // Replace with your second image
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SplashScreen(), // Updated to SplashScreen
  ));
}
