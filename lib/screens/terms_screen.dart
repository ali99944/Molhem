import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('terms_condition').tr(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'introduction',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            SizedBox(height: 8.0),
            Text(
              'intro_text',
            ).tr(),
            SizedBox(height: 16.0),
            Text(
              'user_accounts',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            SizedBox(height: 8.0),
            Text(
              'user_accounts_text',
            ).tr(),
            SizedBox(height: 16.0),
            Text(
              'app_content',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            SizedBox(height: 8.0),
            Text(
              'app_content_text',
            ),
            SizedBox(height: 16.0),
            Text(
              'data_privacy',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            SizedBox(height: 8.0),
            Text(
              'data_privacy_text',
            ).tr(),
            SizedBox(height: 16.0),
            Text(
              'limitation_liability',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            SizedBox(height: 8.0),
            Text(
              'limitation_liability_text',
            ).tr(),
          ],
        ),
      ),
    );
  }
}