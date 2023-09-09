import 'package:Molhem/core/utils/get_device_token.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Molhem/data/entities/user_auth_credentials.dart';
import 'package:Molhem/data/models/user_information.dart';

class UserServices{
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<bool> storeUserInformation(UserInformation userInformation) async{
    return await firestore.collection('users').add(userInformation.toFirestore()).then((value){
      return true;
    }).catchError((onError){
      return false;
    });
  }

  static Future updateChildScore(double newScore,String uid) async{
    QuerySnapshot data = await firestore.collection('users').get();
    List<QueryDocumentSnapshot> users = data.docs;
    QueryDocumentSnapshot user = users.where((element) => element['uid'] == uid).first;
    await firestore.collection('users').doc(user.id).update({
      'score': user['score'] + newScore
    });
  }

  static Future updateParentDeviceToken({required String uid, required String token}) async{
    //only for parent because parent only gets notifications
    QuerySnapshot data = await firestore.collection('users').get();
    List<QueryDocumentSnapshot> users = data.docs;
    QueryDocumentSnapshot user = users.where((element) => element['uid'] == uid).first;
    await firestore.collection('users').doc(user.id).update({
      'deviceToken': token
    });
  }


  static Future changeLoggedUserType(String role,String uid) async{
    try{
      QuerySnapshot data = await firestore.collection('users').get();
      String id = data.docs.where((element) => element['uid'] == uid).first.id;
      await firestore.collection('users').doc(id).update({
        'loggedAs': role
      });

    }catch(error){
      rethrow;
    }
  }
}