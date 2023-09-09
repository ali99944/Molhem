import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:flutter/material.dart';

import '../core/utils/store_history.dart';
import '../screens/music_player_screen.dart';

class ParentMusicComponent extends StatelessWidget {
  final String name;
  final String musicSource;

  const ParentMusicComponent({
    Key? key,
    required this.name,
    required this.musicSource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                MusicPlayerScreen(musicSource: musicSource,musicTitle: name),
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
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: ThemeHelper.blueAlter,
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(-3, 3),
              blurRadius: 2,
              color: Colors.grey,
            ),
            BoxShadow(
              offset: Offset(3, 0),
              blurRadius: 2,
              color: Colors.grey,
            ),
          ],
          // Add a background image or color here
          image: DecorationImage(
            image: AssetImage('assets/music_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Your existing AutoSizeText widget
            Directionality(
              textDirection: TextDirection.ltr,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: AutoSizeText(
                  name,
                  style: ThemeHelper.headingText(context)?.copyWith(
                    fontSize: 28
                  ),
                  maxLines: 2,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Icon(
                Icons.music_note,
                color: Color(0xff464a5b),
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}