import 'package:flutter/material.dart';
import 'package:video_controls/video_controls.dart';
// import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String videoUrl;
  VideoScreen({Key? key,required this.videoUrl}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoController _controller;

  @override
  void initState() {
    print(widget.videoUrl);
    super.initState();
    _controller = VideoController.network(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 3/4, //w/h,
          child: VideoPlayer(
             _controller
          ),
        ),
      ),
    );
  }
}
