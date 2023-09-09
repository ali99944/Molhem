import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/screens/music_player_screen.dart';
import 'package:Molhem/screens/videos_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/helpers/theme_helper.dart';

class VideoCategory extends StatelessWidget {
  final String name;
  final String categoryId;
  final String image;

  const VideoCategory({
    Key? key,
    required this.name,
    required this.categoryId,
    required this.image
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                VideosList(categoryId: categoryId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        height: 320,
        margin: EdgeInsets.only(bottom: 12.0,right: 12.0,left: 12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Color(0xfff1d4d4),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(-3,3),
                  color: Colors.grey,
                blurRadius: 2
              ),
              BoxShadow(
                offset: Offset(3,0),
                color: Colors.grey,
                blurRadius: 2
              )
            ]
        ),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: CachedNetworkImage(imageUrl: image,fit: BoxFit.cover,)),
            Text(name,style: TextStyle(fontSize: 28,color: Color(0xffaa6a6a)),)
          ],
        ),
      ),
    );
  }
}
