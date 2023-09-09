import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Feeling{
  final String content;
  final String image;
  final String degree;

  const Feeling({
    required this.content,
    required this.image,
    required this.degree
  });

  factory Feeling.fromSnapshot(QueryDocumentSnapshot snapshot,BuildContext context){
    String code = context.locale.languageCode;

    return Feeling(
      content: code == 'en' ? snapshot.get('content') : snapshot.get('content-ar'),
      image: snapshot.get('image'),
      degree: snapshot.get('degree')
    );
  }
}