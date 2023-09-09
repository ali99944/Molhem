import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMNotification{
  final String title;
  final String body;
  final int sendTime;

  const FCMNotification({
    required this.title,
    required this.body,
    required this.sendTime,
  });

  factory FCMNotification.nullFCM(){
    return FCMNotification(
        title: 'no title',
        body: 'no body',
        sendTime: DateTime.now().millisecondsSinceEpoch
    );
  }

  factory FCMNotification.fromRemote(RemoteMessage message){
    RemoteNotification? notification = message.notification;

    if(notification != null){
      return FCMNotification(
          title: notification.title!,
          body: notification.body!,
          sendTime: DateTime.now().millisecondsSinceEpoch
      );
    }else{
      return FCMNotification.nullFCM();
    }
  }

  factory FCMNotification.fromJson(Map<String,Object?> json){
    return FCMNotification(
      title: json['title'] as String,
      body: json['body'] as String,
      sendTime: json['timestamp'] as int,
    );
  }

  factory FCMNotification.fromSnapshot(DocumentSnapshot snapshot){
    return FCMNotification(
      title: snapshot.get('title'),
      body: snapshot.get('body'),
      sendTime: snapshot.get('timestamp'),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'title': title,
      'body': body,
      'sendTime': sendTime
    };
  }
}