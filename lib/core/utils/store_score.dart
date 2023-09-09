import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth_status_bloc/auth_status_bloc.dart';

Future<void> storeScore({
  required int score,
  required String category,
  required BuildContext context
}) async{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? id = context.read<AuthStatusBloc>().id;
  await firestore
      .collection('users')
      .doc(id)
      .collection('child-scores')
      .add({
    'max': 5,
    'score': score,
    'test': category,
    'timestamp':DateTime.now().millisecondsSinceEpoch
  });
}