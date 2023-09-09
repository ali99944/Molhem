import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryInformation{
  final String name;
  final String iconImage;
  final String nameAr;
  final List<dynamic> images;


  CategoryInformation({
    required this.name,
    required this.iconImage,
    required this.images,
    required this.nameAr,
  });

  factory CategoryInformation.fromFirestore(QueryDocumentSnapshot doc){
    return CategoryInformation(
      iconImage: doc['iconImage'],
      name: doc['name'],
      nameAr: doc['name-ar'],
      images: doc['images'],
    );
  }
}