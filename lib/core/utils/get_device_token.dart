import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> getDeviceToken() async{
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  String? token = await firebaseMessaging.getToken();
  return token?? '';
}