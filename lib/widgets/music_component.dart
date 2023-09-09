import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/utils/store_history.dart';
import '../screens/music_player_screen.dart';

class MusicComponent extends StatelessWidget {
  final String name;
  final String musicSource;

  const MusicComponent({
    Key? key,
    required this.name,
    required this.musicSource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await storeHistory(
            context: context,
            degree: 'good',
            action: 'listened to $name music'
        ).then((_){
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
        });
      },
      child: Container(
        margin: EdgeInsets.all(4),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Color(0xffeeedf4),
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
            Container(
              // alignment: context.locale.languageCode == 'en' ? Alignment.centerLeft: Alignment.centerRight,
              padding: EdgeInsets.all(8.0),
              child: AutoSizeText(
                name,
                style: TextStyle(fontSize: 24, color: Color(0xff8088a9)),
                maxLines: 2,
              ),
            ),
            // Add an indicator for the music component
            Positioned(
              bottom: 10,
              right: 10,
              child: Icon(
                Icons.music_note,
                color: Color(0xff8088a9),
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}