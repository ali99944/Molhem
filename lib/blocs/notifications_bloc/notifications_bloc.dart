import 'dart:math';

import 'package:bloc/bloc.dart' show Bloc;
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../data/datasource/remote/notifications_data/notifications_local_data_source_impl.dart';
import '../../data/models/fcm_notification.dart';


part 'notifications_event.dart';
part 'notifications_state.dart';

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus ==
      AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

var channel;
var flutterLocalNotificationsPlugin;

void loadFCM() async {
  channel = const AndroidNotificationChannel(
    'jpc_user_notifications_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
    enableVibration: true,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);


}

void listenFCM() async {
  // FirebaseMessaging.instance.subscribeToTopic('/updates');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      if (message.data['session-control'] == 'true') {
        return await FirebaseAuth.instance.signOut();
      }

      // const AndroidInitializationSettings androidInitializationSettings =
      // AndroidInitializationSettings('@mipmap/ic_launcher');
      //
      // await flutterLocalNotificationsPlugin.initialize(
      //   InitializationSettings(
      //     android: androidInitializationSettings,
      //   ),
      // );


      var initializationSettingsAndroid =  AndroidInitializationSettings('@mipmap/ic_launcher');

      AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.max,
        priority: Priority.max,
        icon: initializationSettingsAndroid.defaultIcon,

      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
      );
    }
  });
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationState> {
  final int _perPage = 20;

  NotificationsBloc() : super(const NotificationState()) {
    requestPermission();
    loadFCM();
    listenFCM();

    NotificationsLocalDataSourceImpl notificationsLocalDataSourceImpl = NotificationsLocalDataSourceImpl();

    on<NotificationsEvent>((event, emit) async{
      if(event is FetchNotifications){
        if(state.hasReachedMax) return;

        try{
          if(state.status == NotificationStatus.loading){
            List<FCMNotification> notifications = await notificationsLocalDataSourceImpl.fetchNotifications(limit: _perPage,offset: 0);
            print(notifications);
            return emit(
                state.copyWith(
                    status: notifications.isEmpty ? NotificationStatus.empty : NotificationStatus.success,
                    notifications: notifications,
                    hasReachedMax: notifications.length <= _perPage
                )
            );
          }else{
            List<FCMNotification> notifications = await notificationsLocalDataSourceImpl.fetchNotifications(limit: _perPage,offset: state.notifications.length);
            if(notifications.isEmpty){
              emit(state.copyWith(hasReachedMax: true));
            }else{
              emit(
                  state.copyWith(
                      status: NotificationStatus.success,
                      notifications: List.of(state.notifications)..addAll(notifications),
                      hasReachedMax: false
                  )
              );
            }
          }
        }catch(e){
          emit(state.copyWith(status: NotificationStatus.error,errorMessage: "failed to get posts"));
        }
      }
    },transformer: droppable());
  }
}