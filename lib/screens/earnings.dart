import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasktap_partner/screens/woks.dart';

import 'main_screen.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Total Earnings App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('earnings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => MainScreen()));
          }
        ),
      ),
    );
  }
}

class TotalEarningsPage extends StatefulWidget {
  final bool fromCompleteTaskButton;

  const TotalEarningsPage({Key? key, this.fromCompleteTaskButton = false}) : super(key: key);

  @override
  _TotalEarningsPageState createState() => _TotalEarningsPageState();
}

class _TotalEarningsPageState extends State<TotalEarningsPage> {
  double totalEarnings = 0.0;
  bool _fromCompleteTaskButton = false;

  @override
  void initState() {
    super.initState();
    fetchTotalEarnings();
    _fromCompleteTaskButton = widget.fromCompleteTaskButton;
  }

  Future<void> fetchTotalEarnings() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? partnerId = user?.uid;

    if (partnerId != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('partner')
          .doc(partnerId)
          .get();

      // Retrieve totalearnings as a dynamic value from Firestore
      dynamic earningsFromFirestore = snapshot['totalearnings'];

      if (earningsFromFirestore != null) {
        if (earningsFromFirestore is int) {
          // Convert integer to double
          setState(() {
            totalEarnings = (earningsFromFirestore as int).toDouble();
          });
        } else if (earningsFromFirestore is double) {
          // Directly assign double value
          setState(() {
            totalEarnings = earningsFromFirestore as double;
          });
        }
      }
    } else {
      // User is not logged in
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Earnings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Earnings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '\u20B9$totalEarnings', // Displaying total earnings with rupee sign
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            if (_fromCompleteTaskButton)
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String amountReceived = '';

                      return AlertDialog(
                        title: Text('Confirm Payment'),
                        content: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            amountReceived = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Enter Amount Received',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              double amount = double.tryParse(amountReceived) ??
                                  0.0;
                              if (amount > 0) {
                                await updateTotalEarnings(amount);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Total earnings updated successfully.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (c) =>
                                        NewWorksPage())); // Navigate back to previous page
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Please enter a valid amount.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .yellow, // Background color
                            ),
                            child: Text(
                              'Confirm',
                              style: TextStyle(fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Background color
                ),
                child: Text('Confirm Payment',
                  style: TextStyle(fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),


            SizedBox(height: 20),
            Text(
              'Warnings:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.yellow),
                  // Alert icon at the beginning
                  SizedBox(width: 10),
                  // Add some space between icon and text
                  Expanded(
                    child: Text(
                      'Ensure to collect payments from clients promptly and accurately to avoid any discrepancies.',
                      style: TextStyle(color: Colors.black),
                      maxLines: 2, // Set maximum lines to prevent overflow
                      overflow: TextOverflow.ellipsis, // Handle text overflow
                    ),
                  ),
                  SizedBox(width: 10),
                  // Add some space between text and icon
                  Icon(Icons.warning, color: Colors.yellow),
                  // Alert icon at the end
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Image.asset(
                  'images/ttplogo.png', // Check if this path is correct
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MSK Enterprises Pvt Ltd',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'All Copyright rights reserved @2003',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'MSK Enterprises Pvt Ltd',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateTotalEarnings(double amountReceived) async {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Get the ID of the current partner (current user)
      String? partnerId = currentUser.uid;

      if (partnerId != null) {
        try {
          // Get a reference to the partner document in the partner collection
          DocumentReference partnerRef =
          FirebaseFirestore.instance.collection('partner').doc(partnerId);

          // Update the total earnings of the current partner in a transaction
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot snapshot = await transaction.get(partnerRef);
            if (snapshot.exists) {
              // Get the current total earnings
              dynamic currentEarnings = snapshot['totalearnings'];

              // Ensure currentEarnings is of type double
              double currentEarningsDouble = currentEarnings is int
                  ? (currentEarnings as int).toDouble()
                  : currentEarnings as double;

              // Calculate the new total earnings by adding the received amount
              double newEarnings = currentEarningsDouble + amountReceived;

              // Update the 'totalearnings' field in the partner document
              transaction.update(partnerRef, {'totalearnings': newEarnings});
            }
          });

          // Show success toast message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Amount added to your account successfully.'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          print('Error updating total earnings: $e');
          // Show error toast message if there's an error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred while updating earnings.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}