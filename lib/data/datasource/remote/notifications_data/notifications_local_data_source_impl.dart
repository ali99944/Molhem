import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/error_handling/fcm_store_notification_error.dart';
import '../../../models/fcm_notification.dart';
import 'notifications_local_data_source.dart';

class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource{

  @override
  Future<bool> deleteNotification(int id, String userReference) async{
    // Database database = await SqfliteHelper().database;
    // try{
    //   return await database.delete('notifications',where: 'id = ?',whereArgs: [id]) > 0;
    // }catch(deleteError){
    //   return false;
    // }

    return true;
  }

  @override
  Future<List<FCMNotification>> fetchNotifications({
    required int limit,
    required int offset
  }) async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot users = await firestore.collection('users').get();
    String id = users.docs.where((element) => element['uid'] == uid).first.id;
    QuerySnapshot snapshot = await firestore
        .collection('users')
        .doc(id)
        .collection('child-notifications')
        .get();

    List<DocumentSnapshot> docs = snapshot.docs;
    List<FCMNotification> notifications_ = docs.map((doc){
      return FCMNotification.fromSnapshot(doc);
    }).toList();


    return await Future.delayed(Duration(seconds: 2),(){
      if(offset == 0 && notifications_.isNotEmpty){
        if(notifications_.length > limit){
          return notifications_.sublist(offset,limit);
        }else{
          return notifications_;
        }
      }else if(offset > notifications_.length){
        return [];
      }else if(offset < notifications_.length && notifications_.length - offset < limit){
        return notifications_.sublist(offset,notifications_.length - offset);
      }

      return notifications_.sublist(offset,offset + limit);
    });
  }

  @override
  Future<Either<FCMStoreNotificationError, bool>> storeNotification(FCMNotification notification, String userReference) async{
    try{
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('users').doc(userReference).collection('child-notifications').add(
        notification.toJson()
      );


      return Right(true);
    }catch(insertionError){
      return Left(FCMStoreNotificationError(''));
    }
  }
}