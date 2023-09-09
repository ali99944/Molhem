import 'package:Molhem/screens/short_stories_screen.dart';
import 'package:Molhem/screens/stories.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/helpers/theme_helper.dart';

class StorySelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          height: 120,
          padding: EdgeInsets.all(8.0),
          color: Color(0xff7ea5ad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Container(height:40,child: Text('choose_story_type',style: TextStyle(fontSize: 28),).tr()),
              Expanded(child: Text('choose_story_type_desc',style: ThemeHelper.headingText(context)?.copyWith(fontWeight: FontWeight.normal,fontSize: 24),).tr()),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(color: Color(0xff7ea5ad),),
          Center(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShortStoryScreen(),
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
                  SizedBox(height: 16,),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Stories(),
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
        ],
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
      width: double.infinity,
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
            fit: BoxFit.cover,
          ),
          SizedBox(height: 16.0),
          Text(
            text,
            style: ThemeHelper.headingText(context)
          ),
        ],
      ),
    );
  }
}