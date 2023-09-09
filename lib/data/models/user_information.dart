import 'package:cloud_firestore/cloud_firestore.dart';

class UserInformation{
  final String username;
  final String email;
  int? age;
  String? uid;
  String? childToken;
  String? parentToken;
  String? loggedAs;
  final String phone;
  int? lastChildLoginTime = 0;

  UserInformation({
    required this.username,
    required this.email,
    this.age,
    this.uid,
    required this.phone,
    this.childToken,
    this.parentToken,
    this.loggedAs,
    this.lastChildLoginTime
  });

  Map<String,dynamic> toFirestore(){
    return {
      'uid': uid,
      'email':email,
      'age':age,
      'username':username,
      'phone': phone,
      'childToken': childToken,
      'parentToken':parentToken,
      'loggedAs':loggedAs,
      'lastChildLoginTime':lastChildLoginTime
    };
  }

  factory UserInformation.fromFirestore(QueryDocumentSnapshot snapshot){
    Map<String,dynamic> document = snapshot.data() as Map<String,dynamic>;

    return UserInformation(
      uid:  document['uid'],
      email:  document['email'],
      age:  document['age'],
      username:  document['username'],
      phone: document['phone'],
      childToken: document['childToken'],
      parentToken: document['parentToken'],
      loggedAs: document['loggedAs'],
      lastChildLoginTime: document['lastChildLoginTime']
    );

  }
}