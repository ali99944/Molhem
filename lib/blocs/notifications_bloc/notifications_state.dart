part of 'notifications_bloc.dart';

enum NotificationStatus{loading,success,error,empty}

class NotificationState extends Equatable{
  final NotificationStatus status;
  final List<FCMNotification> notifications;
  final bool hasReachedMax;
  final String errorMessage;

  const NotificationState({
    this.status = NotificationStatus.loading,
    this.hasReachedMax = false,
    this.notifications = const [],
    this.errorMessage = ""
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<FCMNotification>? notifications,
    bool? hasReachedMax,
    String? errorMessage
  }){
    return NotificationState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status,notifications,hasReachedMax,errorMessage];
}