import 'package:cloud_firestore/cloud_firestore.dart';

class LearnCategory{
  final String category;
  final String iconImage;

  const LearnCategory({ required this.category,required this.iconImage });

  factory LearnCategory.fromSnapshot(QueryDocumentSnapshot snapshot){
    return LearnCategory(
      category: snapshot.get("category"),
      iconImage: snapshot.get("iconImage")
    );
  }
}