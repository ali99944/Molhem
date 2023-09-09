import 'package:Molhem/screens/parent_feelings_list.dart';
import 'package:Molhem/screens/parent_learn_topics.dart';
import 'package:Molhem/screens/parent_music_list.dart';
import 'package:Molhem/screens/parent_story_selection_screen.dart';
import 'package:Molhem/screens/parent_test_categories.dart';
import 'package:Molhem/screens/parent_videos_categories.dart';
import 'package:Molhem/screens/parent_want_items_screen.dart';
import 'package:Molhem/screens/voice_commands_list.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/helpers/theme_helper.dart';
import 'child_history.dart';
import 'child_notifications.dart';
import 'child_score_screen.dart';
import 'control_session_screen.dart';

class AppDataControlSession extends StatefulWidget {
  const AppDataControlSession({Key? key}) : super(key: key);

  @override
  State<AppDataControlSession> createState() => _AppDataControlSessionState();
}

class _AppDataControlSessionState extends State<AppDataControlSession> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          GridView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 9/6
            ),
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ParentWantItemsScreen())
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xff7ea5ad),
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: Text(
                    'parent_want_list',
                    style: ThemeHelper.headingText(context)?.copyWith(
                        fontSize: 30
                    ),
                  ).tr(),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ParentFeelingsList())
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xff7ea5ad),
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: Text(
                    'parent_feel_list',
                    style: ThemeHelper.headingText(context)?.copyWith(
                        fontSize: 30
                    ),
                  ).tr(),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ParentMusicList())
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xff7ea5ad),
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: Text(
                    'music',
                    style: ThemeHelper.headingText(context)?.copyWith(
                        fontSize: 30
                    ),
                  ).tr(),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ParentTestCategories())
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xff7ea5ad),
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: Text(
                    'tests',
                    style: ThemeHelper.headingText(context)?.copyWith(
                        fontSize: 30
                    ),
                  ).tr(),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ParentVideosCategories())
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xff7ea5ad),
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: Text(
                    'videos',
                    style: ThemeHelper.headingText(context)?.copyWith(
                        fontSize: 30
                    ),
                  ).tr(),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ParentLearningTopics())
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xff7ea5ad),
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: Text(
                    'learn',
                    style: ThemeHelper.headingText(context)?.copyWith(
                        fontSize: 30
                    ),
                  ).tr(),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ParentStorySelectionScreen())
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xff7ea5ad),
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: Text(
                    'stories',
                    style: ThemeHelper.headingText(context)?.copyWith(
                        fontSize: 30
                    ),
                  ).tr(),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => VoiceCommandsList())
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xff7ea5ad),
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: AutoSizeText(
                    'voice_commands'.tr(),
                    style: ThemeHelper.headingText(context)?.copyWith(
                        fontSize: 30
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.0,)
        ],
      ),
    );
  }
}
