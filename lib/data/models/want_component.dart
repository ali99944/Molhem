import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/src/widgets/framework.dart';

class WantComponent{
  final String name;
  final String nameAr;
  final String image;
  final String degree;
   WantComponent({ required this.name,required this.image, required this.degree,required this.nameAr});

   factory WantComponent.fromFirestore(QueryDocumentSnapshot snapshot, BuildContext context){

     return WantComponent(
         name: snapshot.get('content') ,
       image: snapshot.get('image'),
       degree: snapshot.get('degree'),
       nameAr:snapshot.get('content-ar')
     );
   }
}