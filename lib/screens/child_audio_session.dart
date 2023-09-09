import 'package:alan_voice/alan_voice.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/widgets/wave_background.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';

import '../blocs/auth_status_bloc/auth_status_bloc.dart';
import '../core/helpers/theme_helper.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../widgets/encouragment_widget.dart';

class ChildAudioSession extends StatefulWidget {

  final String text;
  final String image;
  ChildAudioSession({
    Key? key,
    required this.text,
    required this.image
}) : super(key: key);

  @override
  State<ChildAudioSession> createState() => _ChildAudioSessionState();
}

class _ChildAudioSessionState extends State<ChildAudioSession> {
  final FlutterTts flutterTts = FlutterTts();
  late stt.SpeechToText _speechToText;
  String _lastWords="Say something";

  bool _startAnimation = false;

  String _recognized = '';

  double _conf = 0.0;


  Future<void> _stopListening() async {
    await _speechToText.stop();
  }


  void _handleAlan() async{
    if(await AlanVoice.isActive()){
      AlanVoice.deactivate();
    }
  }

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
  }

  Future _speak(String text) async {
    await flutterTts.setLanguage(context.locale.languageCode);
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

  Future _stop() async {
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(105),
        child: Container(
          color: Color(0xff7ea5ad),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Text('test_voice',style: ThemeHelper.headingText(context)?.copyWith(
                fontSize: 30
              ),).tr(),
              Text('listen_speak',style: ThemeHelper.headingText(context)?.copyWith(
                fontSize: 24
              ),).tr()
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(color:Color(0xff7ea5ad)),
          if (_startAnimation)
            Lottie.asset('assets/party.json'),
          Container(
            decoration: BoxDecoration(
              color: ThemeHelper.autismColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  Text(_conf.toStringAsFixed(2),style: TextStyle(
                    fontSize: 20
                  ),),
                  CachedNetworkImage(imageUrl: widget.image,width: 250,height: 250,),
                  AutoSizeText(widget.text,style: TextStyle(
                    fontSize: 32,
                  ),maxLines: 1,),
                  SizedBox(height: 12,),
            
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () async{
                            await _speak(widget.text.trim());
                          },
                          child: CircleAvatar(
                            backgroundColor: Color(0xff9dc7df),
                            radius: 40,
                            child: Icon(Ionicons.headset,size: 45,),
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

                                  listenFor: Duration(seconds: 6),

                                  onResult: (val) async {
                                    _lastWords=(val.recognizedWords.toString().toLowerCase());
                                    setState(() async {
                                      _recognized = _lastWords;
            
                                      if(val.hasConfidenceRating){
                                        _conf = val.confidence * 100;
                                      }else{
                                        _conf = 0.0;
                                      }


                                      if(
                                      _lastWords.trim().toLowerCase() == widget.text.toLowerCase().trim()
                                          || val.confidence * 100 > 80
                                      ){
                                        print('yes score > 80');
                                        _startAnimation = true;
                                        await showDialog(
                                        context: context,
                                        builder: (context){
                                          return EncouragementDialog(
                                            message: 'well_done'.tr(args: [context.read<AuthStatusBloc>().userInformation!.username.toString()]),
                                            icon: Icons.sentiment_satisfied,
                                            onClose: (){
                                              Navigator.pop(context);
                                            },
                                          );
                                        }
                                        );
                                      }
                                    });
            
                                    if(
                                    _lastWords.trim().toLowerCase() == widget.text.toLowerCase().trim()
                                    || val.confidence > 0.8
                                    ){
                                      print('yes score > 80');
                                      setState(() {
                                        _startAnimation = true;
                                      });
                                      await showDialog(
                                          context: context,
                                          builder: (context){
                                            return EncouragementDialog(
                                              message: 'well_done'.tr(args: [context.read<AuthStatusBloc>().userInformation!.username.toString()]),
                                              icon: Icons.sentiment_satisfied,
                                              onClose: (){
                                                Navigator.pop(context);
                                              },
                                            );
                                          }
                                      );
                                    }
                                  }
                              );
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: Color(0xff9dc7df),
                            radius: 40,
                            child: Icon(Ionicons.mic,size: 45,),
                          )
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
