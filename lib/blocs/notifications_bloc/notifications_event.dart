part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
}

class FetchNotifications extends NotificationsEvent{


  @override
  List<Object?> get props => [];
}


class DeleteNotification extends NotificationsEvent{
  final int notificationId;
  const DeleteNotification({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}