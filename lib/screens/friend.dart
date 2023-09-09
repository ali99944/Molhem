import 'dart:math';

import 'package:alan_voice/alan_voice.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore_for_file: depend_on_referenced_packages
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/utils/show_change_language_dialog.dart';

class Friend extends StatefulWidget {
  const Friend({super.key});

  @override
  State<Friend> createState() => _FriendState();
}

class _FriendState extends State<Friend> with TickerProviderStateMixin{

  final FlutterTts flutterTts = FlutterTts();
  late stt.SpeechToText _speechToText;
  String _lastWords = "say_something".tr();

  bool _startAnimation = false;


  double _conf = 0.0;


  Future<void> _stopListening() async {
    await _speechToText.stop();
  }

  Future _speak(String text) async {
    await flutterTts.setLanguage(context.locale.languageCode);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.5);

    await flutterTts.speak(text);
  }

  Future _stop() async {
    await flutterTts.stop();
  }


  late AnimationController _primaryAnimationController;
  late AnimationController _secondAnimationController;

  @override
  void initState() {
    _handleAlan();
    _speechToText = stt.SpeechToText();

      flutterTts.setStartHandler(() {
      print('started');
    });

    flutterTts.setCompletionHandler(() {
      print('completed');
    });
    super.initState();

    _speechToText = stt.SpeechToText();
    _primaryAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _secondAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _primaryAnimationController.addStatusListener((status) {
      if (_primaryAnimationController.isCompleted) {
        _secondAnimationController.repeat(reverse: true);
      } else if (_primaryAnimationController.isAnimating) {
        _secondAnimationController.reset();
      } else if (_primaryAnimationController.isDismissed) {
        _secondAnimationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _speechToText.cancel();
    if(_speechToText.isListening) _speechToText.stop();
    super.dispose();
  }

  String _selectedFriend = 'zain';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCED0CC),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ThemeHelper.blueAlter,
                    Color(0xffffb6c1),
                  ]),

            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40,),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedBuilder(
                    animation: _secondAnimationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          _secondAnimationController.value * 25 - 25,
                        ),
                        child: child,
                      );
                    },
                    child: AnimatedBuilder(
                      animation: CurvedAnimation(
                          parent: _primaryAnimationController,
                          curve: Curves.easeInOut),
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                              0,
                              1 /
                                  tan(sin(_primaryAnimationController
                                      .value)) *
                                  25 +
                                  -50),
                          child: Transform.scale(
                            scale:
                            _primaryAnimationController.value * 1.75,
                            child: child,
                          ),
                        );
                      },
                      child: _selectedFriend == 'zain' ? SvgPicture.asset(
                        "assets/zanie.svg",
                      ): Image.asset('assets/bakar.png',width: 120,height: 120,),
                    ),
                  ),
                ),
                MaterialButton(
                    onPressed: () async{
                      if (_primaryAnimationController.isAnimating) {
                        _primaryAnimationController.reset();
                        _primaryAnimationController.forward();
                      } else if (_primaryAnimationController.isCompleted) {
                        _primaryAnimationController.reset();
                        _primaryAnimationController.forward();
                      } else if (_primaryAnimationController.isDismissed) {
                        _primaryAnimationController.forward();
                      }

                      PermissionStatus status = await Permission.speech.request();
                      if (status.isGranted) {
                        // Proceed with speech recognition
                      } else {
                        return;
                      }

                      bool available = await _speechToText.initialize(
                          onStatus: (val) => print('onStatus: $val'),
                          onError: (val) => print('onError: $val'),
                      );

                      if(available){
                        _speechToText.listen(
                            localeId: context.locale.languageCode,
                            onResult: (val) async {
                              _lastWords=(val.recognizedWords.toString().toLowerCase());

                              String? id = context.read<AuthStatusBloc>().id;
                              QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(id).collection('child-voice-commands').get();
                              List<QueryDocumentSnapshot> commands = snapshot.docs;
                              print(commands);

                              if(_lastWords.contains('stop')) {
                                await _speak("Stopped");
                                await _stopListening();
                                return;
                              }

                              print(_lastWords);

                              if(context.locale.languageCode == 'en'){
                                if(val.finalResult && _lastWords.trim().toLowerCase().contains('who is here') || _lastWords.trim().toLowerCase().contains('here') || _lastWords.trim().toLowerCase().contains('is here')){
                                  setState(() {
                                    _lastWords = 'im your friend Bakar what is your name';
                                  });
                                  await _speak('im your friend Bakar what is your name');
                                  return;
                                }

                                else if(val.finalResult && _lastWords.trim().toLowerCase().contains('my name is')){
                                  String name = _lastWords.split('is')[1].trim();
                                  setState(() {
                                    _lastWords = 'Hey $name How Old Are You?';
                                  });
                                  await _speak('Hey $name How Old Are You?');
                                  return;
                                }

                                else if(val.finalResult && _lastWords.trim().toLowerCase().contains('years old')){
                                  setState(() {
                                    _lastWords = 'How Was Your Day?';
                                  });
                                  await _speak('How Was Your Day?');
                                  return;
                                }

                                else if(val.finalResult && _lastWords.trim().toLowerCase().contains('fine') || _lastWords.trim().toLowerCase().contains('good')){
                                  setState(() {
                                    _lastWords = 'and what did you do?';
                                  });
                                  await _speak('and what did you do?');
                                  return;
                                }
                                else if(val.finalResult && _lastWords.trim().toLowerCase().contains('story') || _lastWords.trim().toLowerCase().contains('read')){
                                  setState(() {
                                    _lastWords = 'Well Done';
                                  });
                                  await _speak('Well Done');
                                  return;
                                }else{
                                  if(val.finalResult){
                                    List<QueryDocumentSnapshot> matches = commands
                                        .where((element) => element.get('prompt').toString().trim().toLowerCase().contains(_lastWords) || element.get('prompt').toString().trim().toLowerCase() == _lastWords)
                                        .toList();

                                    if(matches.isEmpty){
                                      return await _speak("i didn't hear what you said");
                                    }else{
                                      return await _speak(matches.first.get('answer'));
                                    }
                                  }
                                }
                              }else{
                                if(val.finalResult && _lastWords.trim().toLowerCase().contains('مرحبا') || _lastWords.trim().toLowerCase() == 'مرحبا'){
                                  setState(() {
                                    _lastWords = 'اهلا ما اسمك';
                                  });
                                 return await _speak('اهلا ما اسمك');
                                }

                                else if(val.finalResult && _lastWords.trim().toLowerCase().contains('اسمي') || _lastWords.trim().toLowerCase().contains('انا اسمي')){
                                  var username = context.read<AuthStatusBloc>().userInformation!.username;
                                  var translated = await GoogleTranslator().translate(username,from: 'en',to: 'ar');

                                  setState(() {
                                    _lastWords = 'اهلا ${translated.text} كم عمرك';
                                  });
                                  return await _speak('اهلا ${translated.text} كم عمرك');
                                }

                                else if(val.finalResult && _lastWords.trim().toLowerCase().contains('سنة') || _lastWords.trim().toLowerCase().contains('سنوات')){
                                  var username = context.read<AuthStatusBloc>().userInformation!.username;
                                  var translated = await GoogleTranslator().translate(username,from: 'en',to: 'ar');
                                  print(translated);
                                  setState(() {
                                    _lastWords = 'اهلا صديقي ${translated.text} احبرني ماذا فعلت بيومك';
                                  });
                                  return await _speak('اهلا صديقي ${translated.text} احبرني ماذا فعلت بيومك');
                                }

                                else if(val.finalResult && _lastWords.trim().toLowerCase().contains('جيد') || _lastWords.trim().toLowerCase().contains('جميل')){
                                  setState(() {
                                    _lastWords = 'ماذا فعلت به';
                                  });
                                  return _speak('ماذا فعلت به');
                                }
                                else if(_lastWords.trim().toLowerCase().contains('قرأت') || _lastWords.trim().toLowerCase().contains('تعلمت') || _lastWords.trim().contains('لعبت') || _lastWords.trim().toLowerCase().contains('قصة') || _lastWords.trim().toLowerCase().contains('قرات')){
                                  var username = context.read<AuthStatusBloc>().userInformation!.username;
                                  var translated = await GoogleTranslator().translate(username,from: 'en',to: 'ar');

                                  print(translated);

                                  setState(() {
                                    _lastWords = 'رائع احسنت ${translated.text}';
                                  });
                                  return await _speak('رائع احسنت ${translated.text}');
                                }else{
                                  if(val.finalResult){
                                    List<QueryDocumentSnapshot> matches = commands
                                        .where((element) => element.get('prompt-ar').toString().trim().toLowerCase().contains(_lastWords) || element.get('prompt-ar').toString().trim().toLowerCase() == _lastWords)
                                        .toList();

                                    if(matches.isEmpty){
                                      return await _speak("لم افهم ماذا قلت");
                                    }else{
                                      return await _speak(matches.first.get('answer-ar'));
                                    }
                                  }
                                }
                                return;
                              }

                            },
                        );
                      }

                    },
                    child: Image.asset(
                      "assets/lamp.png",
                      height: 100,
                    )),

                SizedBox(height: 48.0,),
                Container(
                  alignment: Alignment.center,
                  height: 80,
                  margin: EdgeInsets.only(top:12.0,left:12.0,right:12.0),
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: ThemeHelper.autismColor,
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: AutoSizeText(_lastWords,style: ThemeHelper.headingText(context)?.copyWith(
                    fontSize: 30
                  ),maxLines: 1,),
                ),
                Container(
                  height: 90,
                  margin: EdgeInsets.all(12.0),
                  padding: EdgeInsets.all(12.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ThemeHelper.autismColor,
                    borderRadius: BorderRadius.circular(12.0)
                  ),

                  child: Column(
                    children: [
                      Expanded(child: AutoSizeText('friend_desc_1'.tr(),style: TextStyle(fontSize: 30),maxLines: 1,)),
                      SizedBox(height: 8.0,),
                      Expanded(child: AutoSizeText('friend_desc_2'.tr(),style: TextStyle(fontSize: 30),maxLines: 1,))
                    ],
                  ),
                ),
               Padding(
                 padding: const EdgeInsets.all(12.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     ElevatedButton(
                       style: ElevatedButton.styleFrom(
                           backgroundColor: Color(0xffe3ce82)
                       ),
                       onPressed: (){
                         setState(() {
                           _selectedFriend = 'zain';
                         });
                       },
                       child: Text('zain',style: TextStyle(
                           color: Colors.black,
                           fontSize: 24
                       ),),
                     ),
                     ElevatedButton(
                       style: ElevatedButton.styleFrom(
                           backgroundColor: Color(0xffe3ce82)
                       ),
                       onPressed: (){
                         setState(() {
                           _selectedFriend = 'other';
                         });
                       },
                       child: Text('baker',style: TextStyle(
                           color: Colors.black,
                           fontSize: 24
                       ),),
                     )
                   ],
                 ),
               )
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: TextButton(
              onPressed: () async{
                FlutterTts tts = FlutterTts();
                tts.speak('change_language_dialog'.tr(args: [context.read<AuthStatusBloc>().userInformation!.username.toString()]));
                await showChangeLanguageDialog(
                  context: context
                );

                setState(() {});
              },
              child: AutoSizeText('change_language'.tr(),style: TextStyle(
                  fontSize: 26,color: Color(0xff5f8891)),maxLines: 1,),
            ),
          )
        ],
      )
    );
  }

  void _handleAlan() async{
    if(await AlanVoice.isActive()){
      AlanVoice.deactivate();
    }
  }

}
