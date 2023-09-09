import 'package:dartz/dartz.dart';
import '../../../../core/error_handling/fcm_store_notification_error.dart';
import '../../../models/fcm_notification.dart';

abstract class NotificationsLocalDataSource{
  Future<List<FCMNotification>> fetchNotifications({required int limit, required int offset});
  Future<Either<FCMStoreNotificationError,bool>> storeNotification(FCMNotification notification,String userReference);
  Future<bool> deleteNotification(int id,String userReference);
}