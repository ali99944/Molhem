import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('faq').tr(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'faq_title',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            SizedBox(height: 16.0),
            Text(
              'question1',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            SizedBox(height: 8.0),
            Text(
              'answer1',
            ).tr(),
            SizedBox(height: 16.0),
            Text(
              'question2',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            SizedBox(height: 8.0),
            Text(
              'answer2',
            ).tr(),
            SizedBox(height: 16.0),
            AutoSizeText(
              'question3'.tr(),
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text('answer3',
            ).tr(),
            SizedBox(height: 16.0),
            Text(
              'question4',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            SizedBox(height: 8.0),
            Text(
              'answer',
            ).tr(),
          ],
        ),
      ),
    );
  }
}