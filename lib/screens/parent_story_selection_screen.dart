import 'package:Molhem/screens/parent_short_stories_screen.dart';
import 'package:Molhem/screens/parent_stories_list.dart';
import 'package:Molhem/screens/stories.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/helpers/theme_helper.dart';

class ParentStorySelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('choose_story_type').tr(),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_image.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParentShortStoryScreen(),
                      ),
                    );
                  },
                  child: StoryOptionCard(
                    backgroundColor: Color(0xff8088a9),
                    image: AssetImage('assets/background_image.png'),
                    text: 'short_stories'.tr(),
                  ),
                ),
              ),
              SizedBox(height: 12,),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParentStoriesList(),
                      ),
                    );
                  },
                  child: StoryOptionCard(
                    backgroundColor: ThemeHelper.blueAlter,
                    image: AssetImage('assets/background_image.png'),
                    text: 'long_stories'.tr(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoryOptionCard extends StatelessWidget {
  final Color backgroundColor;
  final ImageProvider image;
  final String text;

  const StoryOptionCard({
    required this.backgroundColor,
    required this.image,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.0,
      height: 160.0,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: image,
            width: 150.0,
            height: 150.0,
          ),
          SizedBox(height: 16.0),
          Text(
            text,
            style: ThemeHelper.headingText(context)?.copyWith(
              fontSize: 40
            ),
          ),
        ],
      ),
    );
  }
}