import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tasktap_partner/screens/earnings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manpower Services',
      home: NewWorksPage(),
    );
  }
}

class NewWorksPage extends StatefulWidget {
  @override
  _NewWorksPageState createState() => _NewWorksPageState();
}

class _NewWorksPageState extends State<NewWorksPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  late DocumentSnapshot userData;
  late String partnerId;
  String _selectedStatus = 'All';

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
      // Handle unauthenticated user
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Task',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xff928883),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (c) => MainScreen()),
            );
          },
        ),
        actions: [
          DropdownButton<String>(
            value: _selectedStatus,
            onChanged: (String? newValue) {
              setState(() {
                _selectedStatus = newValue!;
              });
            },
            items: <String>['All', 'Pending', 'accepted', 'completed']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('task').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<QueryDocumentSnapshot> filteredTasks = snapshot.data!.docs;

          if (_selectedStatus != 'All') {
            filteredTasks = snapshot.data!.docs.where((task) {
              return task.data() is Map<String, dynamic>? &&
                  (task.data() as Map<String, dynamic>?)?.containsKey(
                      'status') == true &&
                  (task.data() as Map<String, dynamic>?)?['status'] ==
                      _selectedStatus;
            }).toList();
          }

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: filteredTasks.map<Widget>((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String,
                  dynamic>;
              String taskId = document.id;

              bool isTaskAccepted = data['status'] == 'accepted';

              DateTime date = (data['selectedDate'] as Timestamp).toDate();
              String formattedDate = DateFormat('yyyy-MM-dd').format(date);

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey[300],
                          ),
                          child: Text(
                            'Status: ${data.containsKey('status')
                                ? data['status']
                                : 'Pending'}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Work Details',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text('Address: ${data['fullAddress']}'),
                          Text('Landmark: ${data['landmark']}'),
                          Text('Pincode: ${data['pincode']}'),
                          Text('District: ${data['district']}'),
                          Text('State: ${data['state']}'),
                          Text('Task: ${data['task']}'),
                          Row(
                            children: [
                              Text('Phone Number: ${data['phoneNumber']}'),
                              IconButton(
                                icon: Icon(Icons.phone),
                                onPressed: () async {
                                  String phoneNumber = 'tel:${data['phoneNumber']}';
                                  if (await canLaunch(phoneNumber)) {
                                    await launch(phoneNumber);
                                  } else {
                                    throw 'Could not launch $phoneNumber';
                                  }
                                },
                              ),
                            ],
                          ),
                          Text('Hours: ${data['selectedHours']}'),
                          Text('Amount: ${data['paymentAmount']}'),
                          Text('OwnerID: ${data['userId']}'),
                          SizedBox(height: 8.0),
                          Text(
                            'Date: $formattedDate',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: 8.0),
                          if (!isTaskAccepted &&
                              data['status'] != 'accepted' &&
                              data['status'] != 'completed')
                            ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String workerPhone = '';
                                    String workerName = '';
                                    String ownerId = data['userId'];

                                    final GlobalKey<
                                        FormState> _formKey = GlobalKey<
                                        FormState>();

                                    return AlertDialog(
                                      title: Text('Enter Worker Details'),
                                      content: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a phone number';
                                                }
                                                if (value.length < 10) {
                                                  return 'Phone number must be at least 10 digits';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) =>
                                              workerPhone = value,
                                              decoration: InputDecoration(
                                                labelText: 'Worker PhoneNo.',
                                              ),
                                            ),
                                            TextFormField(
                                              onChanged: (value) =>
                                              workerName = value,
                                              decoration: InputDecoration(
                                                labelText: 'Worker Name',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState
                                                ?.validate() ?? false) {
                                              _updateUserData(
                                                context,
                                                document.id,
                                                workerPhone,
                                                workerName,
                                                ownerId: ownerId,
                                              );
                                            }
                                          },
                                          child: Text('Submit'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('Accept Task'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                              ),
                            ),
                          if (isTaskAccepted && data['status'] == 'accepted' &&
                              data['status'] != 'completed')
                            ElevatedButton(
                              onPressed: () async {
                                if (isTaskAccepted &&
                                    data['status'] == 'accepted' &&
                                    data['status'] != 'completed') {
                                  _confirmPayment(
                                      context, document.id, data['userId']);
                                } else {
                                  // Show a message indicating that the task needs to be accepted first
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Please accept the task first.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Text('Confirm Payment'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),

                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      backgroundColor: Color(0xff928883),
    );
  }

  void _updateUserData(BuildContext context,
      String taskId,
      String workerPhone,
      String workerName,
      {required String ownerId, String userId = ''}) async {
    try {
      if (taskId.isNotEmpty &&
          ownerId.isNotEmpty &&
          workerPhone.isNotEmpty &&
          workerName.isNotEmpty) {
        // Prepare the data to be updated in Firestore
        Map<String, dynamic> userData = {
          'workerPhone': workerPhone,
          'workerName': workerName,
          'status': 'accepted', // Set status to 'accepted'
        };

        // Get a reference to the Firestore instance
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Update the document in user_work_data collection
        await firestore
            .collection('users')
            .doc(ownerId)
            .collection('user_work_data')
            .doc(taskId)
            .set(userData, SetOptions(merge: true));

        // Update the status of the task in the 'task' collection
        await firestore.collection('task').doc(taskId).update(
            {'status': 'accepted'});

        // Add the accepted task ID to the user's acceptedTasks list
        await firestore.collection('users').doc(ownerId).update({
          'accepted': FieldValue.arrayUnion([taskId])
        });

        // Show success toast message
        Fluttertoast.showToast(
          msg: 'Task accepted and Please Visit a Site and Start Working.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Close the dialog
        Navigator.of(context).pop();
      } else {
        // Show error toast message if any field is empty
        Fluttertoast.showToast(
          msg: 'Please fill all fields.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (error) {
      // Show error toast message if any other error occurs
      Fluttertoast.showToast(
        msg: 'An error occurred: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _confirmPayment(BuildContext context, String taskId,
      String ownerId) async {
    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Update the status of the task in the 'task' collection to 'completed'
      await firestore.collection('task').doc(taskId).update(
          {'status': 'completed'});

      // Update the status of the task in the 'users' collection to 'completed'
      await firestore
          .collection('users')
          .doc(ownerId)
          .collection('user_work_data')
          .doc(taskId)
          .update({'status': 'completed'});

      // Show success toast message
      Fluttertoast.showToast(
        msg: 'Please Confirm and task is completed.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Navigate to TotalEarningsPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TotalEarningsPage(fromCompleteTaskButton: true),
        ),
      );
    } catch (error) {
      // Show error toast message if any error occurs
      Fluttertoast.showToast(
        msg: 'An error occurred: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
