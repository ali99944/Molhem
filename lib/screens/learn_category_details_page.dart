import 'dart:math';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ionicons/ionicons.dart';

import '../core/utils/UpperFirstLetter.dart';
import '../core/utils/show_feedback_motivation.dart';
import '../data/models/animal.dart';

class LearnCategoryDetailsScreen extends StatefulWidget {
  LearnCategoryDetailsScreen({required this.categoryInformation});
  final CategoryInformation categoryInformation;

  @override
  State<LearnCategoryDetailsScreen> createState() => _LearnCategoryDetailsScreenState();
}

class _LearnCategoryDetailsScreenState extends State<LearnCategoryDetailsScreen> {
  // final VoidCallback onPressed;

  final FlutterTts flutterTts = FlutterTts();
  late stt.SpeechToText _speechToText;
  String _lastWords="say_something".tr();

  bool _startAnimation = false;

  String _recognized = '';

  double _conf = 0.0;


  Future<void> _stopListening() async {
    await _speechToText.stop();
  }

  bool isArabicOnly(String text) {
    RegExp arabicRegex = RegExp(r'^[\u0600-\u06FF\s-]*$');
    return arabicRegex.hasMatch(text);
  }

  bool isEnglishOnly(String text) {
    RegExp englishRegex = RegExp(r'^[a-zA-Z\s-]*$');
    return englishRegex.hasMatch(text);
  }



  @override
  void initState() {
    _speechToText = stt.SpeechToText();
    flutterTts.setStartHandler(() {
      print('started');
    });

    flutterTts.setCompletionHandler(() {
      print('completed');
    });

    super.initState();
  }

  Future _speak(String text) async {
    await flutterTts.setLanguage(widget.categoryInformation.nameAr == widget.categoryInformation.name ? (isArabicOnly(widget.categoryInformation.name) ? 'ar' : 'en'): context.locale.languageCode);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.5);
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    _speechToText.cancel();
    if(_speechToText.isListening) _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !widget.categoryInformation.images.isNotEmpty ? PreferredSize(
        preferredSize: Size.fromHeight(105),
        child: Container(
          color:  Color(0xffa7914e),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Text('hi_message',style: TextStyle(
                  fontSize: 30
              ),).tr(args: [upperFirstLetter(context.read<AuthStatusBloc>().userInformation!.username)]),
              Text('listen_and_speak',style: ThemeHelper.headingText(context)?.copyWith(
                  fontSize: 24
              ),).tr()
            ],
          ),
        ),
      ) : null,

      body: Stack(
        children: [
          widget.categoryInformation.images.isNotEmpty ? Container(
            color: Colors.white,

          ) : Container(color: Color(0xffa7914e),),

          Container(
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    color: widget.categoryInformation.images.isNotEmpty ?  Color(0xffa7914e) : null,

                    decoration: !widget.categoryInformation.images.isNotEmpty ? BoxDecoration(
                      color: widget.categoryInformation.images.isNotEmpty ?  Color(0xffa7914e) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ) : null,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        children: [
                          if(widget.categoryInformation.images.isEmpty)
                          Container(
                            width:double.infinity,
                            alignment: Alignment.center,
                            height: 140,
                            padding:EdgeInsets.all(8.0),
                            decoration:BoxDecoration(
                                color:Colors.black12,
                                borderRadius: BorderRadius.circular(8.0)
                            ),
                            child: AutoSizeText(_recognized,style:ThemeHelper.headingText(context)),
                          ),
                          SizedBox(height: 8.0,),
                          if(widget.categoryInformation.images.isEmpty)
                          Text(_conf.toStringAsFixed(2),style: TextStyle(
                              fontSize: 20
                          ),),
                          Hero(
                            tag: widget.categoryInformation.iconImage,
                            child: CachedNetworkImage(
                              imageUrl: widget.categoryInformation.iconImage,
                              height: 200,
                              width: 200,
                            ),
                          ),
                          // AutoSizeText(upperFirstLetter(widget.categoryInformation.description.isEmpty ? (widget.categoryInformation.images.isEmpty ? (context.locale.languageCode == 'en' ? widget.categoryInformation.name : widget.categoryInformation.nameAr) : '') : widget.categoryInformation.description),maxLines:1,style: TextStyle(
                          //   color: widget.categoryInformation.images.isNotEmpty ? Color(0xfff1ecdd) : Color(0xff7ea5ad),
                          //   fontWeight: FontWeight.bold,
                          //   fontSize: 32
                          // ),),
                          // SizedBox(height: 12.0,),
                          Align(
                            alignment: Alignment.center,
                            child: AutoSizeText('${context.locale.languageCode == 'en' ? widget.categoryInformation.name : widget.categoryInformation.nameAr}',style: TextStyle(
                              color: Color(0xff4d6d7e),
                              fontSize: 28
                            ),maxLines: 1,),
                          ),
                          SizedBox(height: 4.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () async{
                                    await _speak(context.locale.languageCode == 'en' ? widget.categoryInformation.name.trim() : widget.categoryInformation.nameAr.trim());
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xff9dc7df),
                                    radius: 30,
                                    child: Icon(Ionicons.headset,size: 35,),
                                  )
                              ),
                              SizedBox(width: 20,),
                              GestureDetector(
                                  onTap: () async{
                                    bool available = await _speechToText.initialize(
                                      onStatus: (val) => print('onStatus: $val'),
                                      onError: (val) => print('onError: $val'),
                                    );

                                    if(available){
                                      _speechToText.listen(
                                          localeId: context.locale.languageCode,
                                          onResult: (val) async {
                                            var flutterTts = FlutterTts();
                                            _lastWords=(val.recognizedWords.toString().toLowerCase());
                                            setState(() {
                                              _recognized = _lastWords;
                                              if(val.hasConfidenceRating){
                                                _conf = val.confidence;
                                              }else{
                                                _conf = 0.0;
                                              }
                                            });
                                            if(_lastWords.toLowerCase() == widget.categoryInformation.name.trim()){
                                              setState(() {
                                                _startAnimation = true;
                                              });
                                              await showFeedbackMotivation(
                                                context: context,
                                                message:'well_done_spell'.tr(args:[upperFirstLetter(context.read<AuthStatusBloc>().userInformation!.username)]),
                                                  imageAssetPath: 'assets/bakar.png'
                                              );
                                            }
                                          }
                                      );
                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xff9dc7df),
                                    radius: 30,
                                    child: Icon(Ionicons.mic,size: 35,),
                                  )
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                if(widget.categoryInformation.images.isNotEmpty)
                CarouselSlider(
                  items: widget.categoryInformation.images.map((e){
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(e),
                          fit: BoxFit.cover
                        )
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    aspectRatio: 5/4
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
