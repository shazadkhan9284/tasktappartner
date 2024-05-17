import 'package:firebase_database/firebase_database.dart';

class UserModel{
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? gender;
  String? age;
  String? education;
  String? aadharNumber;
  String? photoUrl; // Add this field

UserModel({
  this.id,
  this.name,
  this.email,
  this.phone,
  this.address,
  this.gender,
  this.age,
  this.education,
  this.aadharNumber,
  this.photoUrl,
});
UserModel.fromsnapshot(DataSnapshot snap){
  phone =(snap.value as dynamic)["phone"];
  name =(snap.value as dynamic)["name"];
  id=snap.key;
  email =(snap.value as dynamic)["email"];
  address =(snap.value as dynamic)["address"];
  education =(snap.value as dynamic)["education"];
  photoUrl = (snap.value as dynamic)["photoUrl"];
}
// Add getter for photoUrl
  String? getPhotoUrl() {
    return photoUrl;
  }
  // Add setter for photoUrl
  void setPhotoUrl(String? url) {
    photoUrl = url;
  }
}
