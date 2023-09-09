import 'package:cloud_firestore/cloud_firestore.dart';

class ChildHistory{
  final String action;
  final String degree;
  final int timestamp;

  ChildHistory({
    required this.action,
    required this.degree,
    required this.timestamp
  });

  factory ChildHistory.fromFirestore(QueryDocumentSnapshot snapshot){
    return ChildHistory(
      action: snapshot.get("action"),
      degree: snapshot.get("degree"),
      timestamp: snapshot.get("timestamp")
    );
  }
}