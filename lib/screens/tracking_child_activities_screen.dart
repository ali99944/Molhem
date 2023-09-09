import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../core/helpers/theme_helper.dart';
import 'child_history.dart';
import 'child_score_screen.dart';

class TrackingChildActivitiesScreen extends StatefulWidget {
  @override
  _TrackingChildActivitiesScreenState createState() =>
      _TrackingChildActivitiesScreenState();
}

class _TrackingChildActivitiesScreenState
    extends State<TrackingChildActivitiesScreen> {
  int _currentTabIndex = 0;

  final List<Widget> _tabPages = [
    ChildHistoryScreen(),
    ChildScoreScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentTabIndex = 0;
                  });
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: _currentTabIndex == 0 ? ThemeHelper.blueAlter : Colors.black12,
                      borderRadius: BorderRadius.circular(8.0)
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'activities'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.0,),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentTabIndex = 1;
                  });
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: _currentTabIndex == 1 ? ThemeHelper.blueAlter : Colors.black12,
                      borderRadius: BorderRadius.circular(8.0)
                  ),                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'test_scores'.tr(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12,),
        Expanded(
          child: _tabPages[_currentTabIndex],
        ),
      ],
    );
  }
}