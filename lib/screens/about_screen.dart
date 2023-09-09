import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('about').tr(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                'about_welcome_message',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ).tr(),
              SizedBox(height: 16.0),
              Text(
                'unique_child_autism',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ).tr(),
              SizedBox(height: 16.0),
              Text(
                'learn_section',
                style: TextStyle(fontSize: 18.0),
              ).tr(),
              SizedBox(height: 16.0),
              Text(
                'express_thoughts',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ).tr(),
              SizedBox(height: 16.0),
              Text(
                'cognitive_games',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ).tr(),
              SizedBox(height: 16.0),
              Text(
                'child_safety',
                style: TextStyle(fontSize: 18.0),
              ).tr(),
              SizedBox(height: 16.0),
              Text(
                'team_experts',
                style: TextStyle(fontSize: 18.0),
              ).tr(),
            ],
          ),
        ),
      ),
    );
  }
}
