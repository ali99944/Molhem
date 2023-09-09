import 'package:Molhem/widgets/parent_drawer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../widgets/notification_list.dart';


class ChildNotifications extends StatefulWidget {
  static const String notificationsScreen = '/notificationsScreen';

  const ChildNotifications({super.key});

  @override
  _ChildNotificationsState createState() => _ChildNotificationsState();
}

class _ChildNotificationsState extends State<ChildNotifications> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => _scaffoldState.currentState!.openDrawer(),
              child: Icon(Icons.menu),
            ),
          )
        ],
        title: const Text('notifications').tr(),
      ),
      drawer: ParentDrawer(),
      body: NotificationsList(),
    );
  }
}
