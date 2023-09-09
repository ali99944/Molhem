import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../blocs/notifications_bloc/notifications_bloc.dart';
import '../core/helpers/theme_helper.dart';
import '../data/models/fcm_notification.dart';
import 'notification_item.dart';

class NotificationsList extends StatefulWidget {
  const NotificationsList({Key? key}) : super(key: key);

  @override
  State<NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<NotificationsBloc>(context).add(
        FetchNotifications()
    );

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener(){
    if(_scrollController.offset >= (_scrollController.position.maxScrollExtent * 0.9)){
      BlocProvider.of<NotificationsBloc>(context).add(
          FetchNotifications()
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc,NotificationState>(
      builder: (context,state){
        switch(state.status){
          case NotificationStatus.empty:
            return Center(
              child: Text('no_notifications').tr(),
            );
          case NotificationStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case NotificationStatus.success:
            return ListView.separated(
              controller: _scrollController,
              itemCount: state.hasReachedMax ? state.notifications.length : state.notifications.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.notifications.length) {
                  return const Center(child: CircularProgressIndicator());
                }


                FCMNotification notification = state.notifications[index];
                DateFormat dateFormat = DateFormat('mm-dd hh:MM');
                DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(notification.sendTime);
                String date = dateFormat.format(dateTime);
                return _buildNotification(
                  title: notification.title,
                  message: notification.body,
                  icon: Icons.assignment,
                  time: date,
                );
              }, separatorBuilder: (BuildContext context, int index) {
              return const Divider(thickness: 3,);
            },
            );
          case NotificationStatus.error:
            return Center(
              child: Text(state.errorMessage,style: const TextStyle(fontSize: 30),),
            );
        }
      },
    );
  }
}

Widget _buildNotification({required String title, required String message, required IconData icon, required String time}) {
  return Card(
    elevation: 2.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 48.0, color: ThemeHelper.secondaryColor),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8.0),
                Text(message),
                SizedBox(height: 8.0),
                Text(time, style: TextStyle(fontSize: 12.0, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}