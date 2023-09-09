import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/screens/music_player_screen.dart';
import 'package:Molhem/screens/video_screen.dart';
import 'package:Molhem/screens/youtue_video_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../core/helpers/theme_helper.dart';
import '../core/utils/store_history.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
class VideoComponent extends StatefulWidget {
  final String name;
  final String sourceType;

  final String videoSource;

  const VideoComponent({
    Key? key,
    required this.name,
    required this.videoSource,
    required this.sourceType,
  }) : super(key: key);

  @override
  State<VideoComponent> createState() => _VideoComponentState();
}

class _VideoComponentState extends State<VideoComponent> {
  String? _poster;

  String getVideoIdFromUrl(String url) {
    String videoId = '';
    if (url.contains('youtu.be/')) {
      videoId = url.split('youtu.be/')[1];
      if (videoId.contains('&')) {
        videoId = videoId.split('&')[0];
      }
    } else if (url.contains('watch?v=')) {
      videoId = url.split('watch?v=')[1];
      if (videoId.contains('&')) {
        videoId = videoId.split('&')[0];
      }
    }
    return videoId;
  }

  getThumbnailUrl(String videoId) async{
    // final yt = YoutubeExplode();
    // final video = await yt.videos.get(videoId);
    // final thumbnailUrl = video.thumbnails.highResUrl;
    // yt.close();
    // _poster = thumbnailUrl;
    setState(() {
      _poster = 'https://img.youtube.com/vi/$videoId/0.jpg';
    });

  }


  @override
  void initState() {
    super.initState();
    getThumbnailUrl(getVideoIdFromUrl(widget.videoSource));
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async{
        await storeHistory(
          context: context,
          action: 'watched ${widget.name} video',
          degree: 'good'
        ).then((value){
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
              widget.sourceType == 'youtube' ?
              YoutubeVideoScreen(videoUrl: widget.videoSource)
                  : VideoScreen(videoUrl: widget.videoSource,),
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
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Color(0xfff1d4d4),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(-3,3),
                  color: Colors.grey,
                blurRadius: 2
              ),
              BoxShadow(
                  offset: Offset(3,0),
                  color: Colors.grey
              ),
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(_poster != null) ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12.0),
                topLeft: Radius.circular(12.0),
              ),
              child: CachedNetworkImage(
                imageUrl: _poster!,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(widget.name,maxLines: 1,style: TextStyle(fontSize: 24,color: Color(0xffaa6a6a))),
            )
          ],
        ),
      ),
    );
  }
}
