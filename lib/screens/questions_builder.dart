import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_status_bloc/auth_status_bloc.dart';
import '../core/helpers/theme_helper.dart';
import '../core/utils/UpperFirstLetter.dart';
import '../core/utils/show_feedback_motivation.dart';
import '../core/utils/store_history.dart';
import '../core/utils/store_score.dart';
import '../data/models/question.dart';
import '../widgets/encouragment_widget.dart';

class QuestionScreen extends StatefulWidget {
  final List<Question> questions;
  final String? category;

  QuestionScreen({required this.questions,  this.category});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentIndex = 0;
  int _secondsLeft = 60;
  int _score = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsLeft--;
      });
      if (_secondsLeft == 0) {
        _timer?.cancel();
        _handleAfterTimerIsOut();
      }
    });
  }

  void _handleAfterTimerIsOut() async{
    await storeHistory(action: 'finished ${widget.category} test with timeout', degree: 'bad',context: context);
    await storeScore(context:context,category: widget.category!,score: _score);

    await showFeedbackMotivation(
      imageAssetPath: 'assets/sad.png',
      message: 'test_time_out'.tr(args: [upperFirstLetter(context.read<AuthStatusBloc>().userInformation!.username)]),
      context: context
    ).then((_){
      _showResultsScreen();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  void _submitAnswer(int answerIndex) async{
    if (answerIndex == widget.questions[_currentIndex].answer) {
      setState(() {
        _score++;
      });
    }
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _secondsLeft = 60;
      });
    } else {
      _timer?.cancel();
     _handleFinishTestFunction();
    }
  }

  void _showResultsScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => ResultsScreen(score: _score, totalQuestions: widget.questions.length),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AutoSizeText(
                context.locale.languageCode == 'en'? widget.questions[_currentIndex].question : widget.questions[_currentIndex].questionAr,
              style: TextStyle(
                fontSize: 24,

              ),
            ),
            SizedBox(height: 30.0),
            if (widget.questions[_currentIndex].image != null)
              Image.network(widget.questions[_currentIndex].image!),
            SizedBox(height: 30.0),
            Column(

              children: [
                ...(context.locale.languageCode == 'en' ? widget.questions[_currentIndex].choices : widget.questions[_currentIndex].choicesAr).map((choice){
                  return GestureDetector(
                    onTap: () => _submitAnswer((context.locale.languageCode == 'en' ? widget.questions[_currentIndex].choices : widget.questions[_currentIndex].choicesAr).indexOf(choice)),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      height: 60,
                      alignment: Alignment.center,
                      child: Text(choice,style: TextStyle(fontSize: 28,color: ThemeHelper.foreground,fontWeight: FontWeight.normal),),
                      decoration: BoxDecoration(
                        color: ThemeHelper.background,
                        borderRadius: BorderRadius.circular(12.0)
                      ),

                    ),
                  );
                }),
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerRight,
                  child:
                  Text('time_left'.tr(args: [_secondsLeft.toString()]),style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),),
                ),
                SizedBox(height: 30.0),
                Row(
                  children: [
                    ...List.generate(5, (index){
                      return AnimatedContainer(
                        margin: EdgeInsets.only(right: 8.0),
                        duration: Duration(seconds: 1),
                        child: CircleAvatar(
                          minRadius: 20,
                          backgroundColor: _currentIndex < index? Color(
                              0xffffabb7) : Color(0xff9bb491)
                        ),
                      );
                    })
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleFinishTestFunction() async{
    await storeScore(
        context: context,
        category: widget.category!,
        score: _score
    );
    await storeHistory(
        degree: 'good',
        action: 'finished ${widget.category} test',
        context: context
    );
    await showFeedbackMotivation(
        imageAssetPath: 'assets/bakar.png',
        message: 'finish_test_motivation'.tr(args: [upperFirstLetter(context.read<AuthStatusBloc>().userInformation!.username),widget.category.toString()]),
        context: context
    ).then((_){
      _showResultsScreen();
    });

  }
}

class ResultsScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  ResultsScreen({required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  ThemeHelper.autismColor,
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText('score_message'.tr(args: [score.toString(),totalQuestions.toString()]),style: TextStyle(
              fontSize: 32
            ),),
            AutoSizeText('do_better'.tr(args: [upperFirstLetter(context.read<AuthStatusBloc>().userInformation!.username)]),style: TextStyle(
                fontSize: 26
            ),maxLines: 1,),
            SizedBox(height: 16.0),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeHelper.background
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('try_again',style: TextStyle(fontSize: 24,color: ThemeHelper.foreground,fontWeight: FontWeight.normal),).tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}