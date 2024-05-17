
import 'package:firebase_database/firebase_database.dart';

import '../global/global.dart';
import '../models/user_model.dart';

class AssistantsMethods{
  static void readCurrentOnlineUsInfo() async{
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
    .ref()
    .child("user")
    .child(currentUser!.uid);

    userRef.once().then((snap){
      if(snap.snapshot.value != null){
        userModelCurrentinfo = UserModel.fromsnapshot(snap.snapshot);
      }
    });
  }
}