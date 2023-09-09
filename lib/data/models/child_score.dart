import 'package:cloud_firestore/cloud_firestore.dart';

class ChildScore{
  final String test;
  final int score;
  final int max;
  final int timestamp;

  ChildScore({
    required this.test,
    required this.score,
    required this.max,
    required this.timestamp
  });

  factory ChildScore.fromFirestore(QueryDocumentSnapshot snapshot){
    return ChildScore(
      test: snapshot.get("test"),
      score: snapshot.get("score"),
      max: snapshot.get("max"),
      timestamp: snapshot.get("timestamp")
    );
  }
}