import 'package:cloud_firestore/cloud_firestore.dart';

class Story{
  final String title;
  final String titleAr;
  final String contentAr;
  final String content;
  final String image;
  final String author;

  Story({
    required this.title,
    required this.titleAr,
    required this.contentAr,
    required this.content,
    required this.image,
    required this.author
  });

  factory Story.fromFirestore(QueryDocumentSnapshot snapshot){
    return Story(
      title: snapshot['title'],
      content: snapshot['content'],
      image: snapshot['image'],
      author: snapshot['author'],
      titleAr: snapshot['title-ar'],
      contentAr: snapshot['content-ar']
    );
  }
}