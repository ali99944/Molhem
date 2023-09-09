import 'package:Molhem/screens/language_settings.dart';
import 'package:Molhem/screens/tracking_child_activities_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/screens/control_session_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../widgets/parent_drawer.dart';
import 'analyza_and_watch_screen.dart';
import 'app_data_control_session.dart';
import 'child_history.dart';
import 'child_notifications.dart';
import 'child_score_screen.dart';
import 'parent_test_categories.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({Key? key}) : super(key: key);

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> with SingleTickerProviderStateMixin{
  int _selectedIndex = 0;
  List<Widget> bottomNavigationWidgets = <Widget>[
    AnalyzeAndWatchScreen(),
    AppDataControlSession(),
    ControlSessionScreen(),
    TrackingChildActivitiesScreen(),
    LanguageSettings()
  ];

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      backgroundColor: Colors.black12,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(104),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(height: 20,),
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'parent_welcome_message',
                      style: ThemeHelper.headingText(context)?.copyWith(
                          fontSize: 30
                      ),
                    ).tr(),
                    GestureDetector(
                      onTap: (){
                        _scaffoldState.currentState!.openDrawer();
                      },
                      child: Icon(Icons.menu_open,size: 40,color: ThemeHelper.blueAlter,),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: ParentDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: ThemeHelper.blueAlter,
        currentIndex: _selectedIndex,
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics,size: 30,),
              label: 'analysis'.tr()
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.data_object,size: 30,),
              label: 'controll'.tr()
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics,size: 30,),
              label: 'session'.tr()
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.watch_later,size: 30,),
              label: 'tracking'.tr()
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.language,size: 30,),
              label: 'language'.tr()
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: bottomNavigationWidgets[_selectedIndex],
      ),
    );
  }
}