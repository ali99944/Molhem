import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/utils/push_notification.dart';
import 'package:Molhem/screens/feel_items_list.dart';
import 'package:Molhem/screens/learning_topics.dart';
import 'package:Molhem/screens/play.dart';
import 'package:Molhem/screens/avatar_screen.dart';
import 'package:Molhem/screens/stories.dart';
import 'package:Molhem/screens/story_selection_screen.dart';
import 'package:Molhem/screens/videos_categories.dart';
import 'package:Molhem/screens/videos_list.dart';
import 'package:Molhem/screens/want_items_screen.dart';
import 'package:Molhem/widgets/child_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart' show BuildContextEasyLocalizationExtension, StringTranslateExtension, TextTranslateExtension, tr;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constants/app_strings.dart';
import '../core/helpers/theme_helper.dart';
import '../core/utils/UpperFirstLetter.dart';
import '../core/utils/get_device_token.dart';
import '../widgets/child_main_component.dart';
import 'friend.dart';
import 'music.dart';
import 'test_categories.dart';
import 'package:alan_voice/alan_voice.dart';

class ChildHomeScreen extends StatefulWidget {
  const ChildHomeScreen({super.key});

  @override
  State<ChildHomeScreen> createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends State<ChildHomeScreen> {
  Timer? timer;

  bool _isOpened = false;
  _ChildHomeScreenState() {
    AlanVoice.addButton(
        "ec4283dc5385a8bbf778591b75ba3f542e956eca572e1d8b807a3e2338fdd0dc/stage");
    AlanVoice.onCommand.add((command) async{

      print(command.data['command']);
      print(command.data);
      switch (command.data['command'].toString()) {
        case "open_music":
          AlanVoice.deactivate();
          Navigator.of(context).pushNamed('/music');

        case "open_want":
          Navigator.of(context).pushNamed('/want');

        case "call_parent":
          String? phone = context.read<AuthStatusBloc>().userInformation?.phone;

          if (phone != null) {
            Uri uri = Uri.parse('tel:0$phone');

            if (await canLaunch(uri.toString())) {
              await launch(uri.toString());
            } else {
              // Handle case when the phone app cannot be launched
            }
          } else {
            // Handle case when the phone number is not available
          }

        case "back":
          Navigator.pop(context);

        case "open_feelings":
          Navigator.of(context).pushNamed('/feel');

        case "tell_the_day":
          String day = <String>[
            "Saturday",
            "sunday",
            "monday",
            "tuesday",
            "wednesday",
            "Thursday",
            "friday"
          ][DateTime.now().day % 7];

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The Day Is ${day}',style: TextStyle(
              fontSize: 26
            ),))
          );

        case "logout":
          await FirebaseAuth.instance.signOut();

        default:
          print(command);
          return print('something else');
      }
    });
  }

  @override
  void initState() {
    _popupSuggestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: Container(
          color: ThemeHelper.autismColor,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text('hi_message',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),).tr(args: [upperFirstLetter(context.read<AuthStatusBloc>().userInformation?.username ?? 'Test')]),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => AvatarScreen())
                      );
                    },
                    child: FluttermojiCircleAvatar(radius: 30,backgroundColor: Color(0xff7ea5ad),),
                  )
                ],
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Friend())
                  );
                },
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(offset: Offset(2,2),color: Colors.grey),
                        BoxShadow(offset: Offset(-2,0),color: Colors.grey),
                      ]
                  ),
                  alignment: Alignment.center,
                  child: Text('friend_talk.x',style:ThemeHelper.headingText(context)?.copyWith(
                    fontSize: 30
                  ),).tr(),
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: ThemeHelper.autismColor,
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height:50,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.only(bottom: 8.0),
                  child: Text('socialCat',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:21 ,

                  ),).tr(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => WantItemsScreen())
                        );
                      },
                      child: Container(
                        width: 140,
                        padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                                color: Colors.green,
                                width: 3
                            )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/want.png',width: 50,height: 50,),
                            Text('i_want',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),).tr()
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => FeelItemsList())
                        );
                      },
                      child: Container(
                        width: 140,
                        padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                                color: Colors.green,
                                width: 3
                            )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/think.png',width: 50,height: 50,fit: BoxFit.cover,),
                            Text('i_feel',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),).tr()
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 12.0,),
                Container(
                  padding: EdgeInsets.all(8.0),
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: ThemeHelper.autismColor
                  ),
                  alignment: Alignment.center,
                  child: Text('categories',style: TextStyle(fontSize: 20),).tr(),
                ),
                SizedBox(height: 12.0,),
                Expanded(
                  flex: 1,
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12
                    ),
                    children: [
                      ChildMainComponent(
                        name: 'Learn',
                        assetPath: 'assets/learn.png',
                        destination: LearningTopics(),
                        color: Color(0xffa7914e),
                        backgroundColor: Color(0xfff1ecdd),
                      ),
                      ChildMainComponent(
                        name: 'Tests',
                        assetPath: 'assets/test.png',
                        destination: TestCategories(),
                        color: Color(0xffa08086),
                        backgroundColor: Color(0xfff9d7e6),
                      ),
                      ChildMainComponent(
                        name: 'Play',
                        assetPath: 'assets/play.png',
                        destination: Play(),
                        color: Color(0xff52451d),
                        backgroundColor: Color(0xfffbecdb),
                      ),
                      ChildMainComponent(
                        name: 'Stories',
                        assetPath: 'assets/stories.png',
                        destination: StorySelectionScreen(),
                        color: Color(0xff7ea5ad),
                        backgroundColor: Color(0xffeaf7fa),
                      ),
                      ChildMainComponent(
                        name: 'Music',
                        assetPath: 'assets/music.png',
                        destination: Music(),
                        color: Color(0xff8088a9),
                        backgroundColor: Color(0xffeeedf4),
                      ),
                      ChildMainComponent(
                        name: 'Videos',
                        assetPath: 'assets/video.png',
                        destination: VideosCategories(),
                        color: Color(0xffaa6a6a),
                        backgroundColor: Color(0xfff1d4d4),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          AnimatedPositioned(
            top: 60,
            right: _isOpened ? 0 : (context.locale.languageCode == 'en' ?  -110 : -170),
            duration: Duration(seconds: 1),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: AnimatedContainer(
                padding: EdgeInsets.all(4.0),
                width: context.locale.languageCode == 'en' ? 150 : 210,
                height: 50,
                duration: Duration(seconds: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: ThemeHelper.blueAlter,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          _isOpened = !_isOpened;
                        });
                      },
                      child: Icon(_isOpened ? Icons.chevron_right : Icons.chevron_left,color: Colors.white,size: 40,),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        await FirebaseAuth.instance.signOut();
                      },
                      child: AutoSizeText(
                        'logout_message'.tr(),
                        style: TextStyle(
                            color: Color(0xffaa6a6a),
                            fontSize: 28,
                            fontWeight: FontWeight.bold
                        ),
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _popupSuggestion() async {
    String childToken = await getDeviceToken();

    String code = context.locale.languageCode; // en or ar

    List<Map<String, String>>? messages = collection[code];

    Random random = Random();
    Map<String,String> randomMessage = messages![random.nextInt(messages.length)];

    String title = randomMessage['title'] ?? '';
    String body = randomMessage['body'] ?? '';

    await pushNotification(body: body, title: title, token: childToken)
        .then((value) {
      print('received');
    }).catchError((onError) {
      print('error');
    });
  }

}