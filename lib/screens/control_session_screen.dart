import 'dart:async';
import 'dart:math';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/utils/show_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/utils/UpperFirstLetter.dart';
import '../core/utils/end_child_session_time.dart';

class ControlSessionScreen extends StatefulWidget {
  @override
  _ControlSessionScreenState createState() => _ControlSessionScreenState();
}

class _ControlSessionScreenState extends State<ControlSessionScreen> {
  Timer? timer;
  Duration sessionDuration = Duration();

  @override
  void initState() {
    super.initState();
    // Update session duration every second
    _initializeTimerFromChildLoginTime();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void endSession() async{
    String id = context.read<AuthStatusBloc>().id!;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await firestore.collection('users').doc(id).get();
    await firestore.collection('users').doc(id).update({
      'lastChildLoginTime': null
    });


    await endChildSessionTime(title: '',body: '',token: snapshot.get('childToken')).then((value)async{
      showMessage(context: context, message: 'end_session_success'.tr(args: [upperFirstLetter(context.read<AuthStatusBloc>().userInformation!.username)]));
      setState(() {
        sessionDuration = Duration();
        timer?.cancel();
      });
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'control_session_message',
            style: TextStyle(fontSize: 20),
          ).tr(args: [upperFirstLetter(context.read<AuthStatusBloc>().userInformation!.username)]),
          SizedBox(height: 10),
          Text(
            formatDuration(sessionDuration),
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Container(
            width: 200,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff7ea5ad)
              ),
              onPressed: endSession,
              child: Text('end_session',style: TextStyle(
                fontSize: 20
              ),).tr(),
            ),
          ),
        ],
      ),
    );
  }

  void _initializeTimerFromChildLoginTime() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String id = context.read<AuthStatusBloc>().id!;
    DocumentSnapshot snapshot = await firestore.collection('users').doc(id).get();
    var lastChildLoginTime = snapshot.get('lastChildLoginTime');

    if (lastChildLoginTime != null) {
      DateTime epoch = DateTime.fromMillisecondsSinceEpoch(lastChildLoginTime);
      DateTime dateTime = DateTime.now();

      Duration difference = dateTime.difference(epoch);
      sessionDuration = difference;

      setState(() {});

      timer = Timer.periodic(Duration(seconds: 1), (_) {
        setState(() {
          sessionDuration += Duration(seconds: 1);
        });
      });
    } else {
      setState(() {
        sessionDuration = Duration();
        timer = null;
      });
    }
  }
}