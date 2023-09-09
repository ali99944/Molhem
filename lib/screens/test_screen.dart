import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/data/models/question.dart';
import 'package:Molhem/screens/questions_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestScreen extends StatefulWidget {
  final String testId;
  String? category;
  TestScreen({Key? key, required this.testId, this.category}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          height: 120,
          padding: EdgeInsets.all(8.0),
          color:  Color(0xffa08086),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Container(height:40,child: Text('test_name',style: TextStyle(fontSize: 28,),).tr(args: [widget.category.toString()])),
              Expanded(child: Text('answer_questions',style: ThemeHelper.headingText(context)?.copyWith(fontSize: 24),).tr())
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(color: Color(0xffa08086)),
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: FutureBuilder(
              future: FirebaseFirestore
                  .instance
                  .collection('users')
                  .doc(context.read<AuthStatusBloc>().id)
                  .collection('child-tests')
                  .doc(widget.testId)
                  .collection('questions')
                  .limit(5)
                  .get(),
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if(!snapshot.hasData){
                  return Center(
                    child: AutoSizeText('no_questions'.tr(),style: TextStyle(
                      fontSize: 32
                    ),maxLines: 1,),
                  );
                }

                if(snapshot.hasError){
                  return Center(
                    child: AutoSizeText('swr'.tr(),style: TextStyle(
                      fontSize: 32
                    ),maxLines: 1,),
                  );
                }
                List<Question> questions = snapshot.data!.docs.map((doc){
                  return Question.fromFirestore(doc.data() as Map);
                }).toList();
                return QuestionScreen(questions: questions,category: widget.category);
              },
            ),
          ),
        ],
      ),
    );
  }
}
