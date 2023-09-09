
import 'package:Molhem/screens/child_home_screen.dart';
import 'package:Molhem/screens/feel_items_list.dart';
import 'package:Molhem/screens/learning_topics.dart';
import 'package:Molhem/screens/music.dart';
import 'package:Molhem/screens/stories.dart';
import 'package:Molhem/screens/test_categories.dart';
import 'package:Molhem/screens/want_items_screen.dart';
import 'package:flutter/material.dart';

import '../../screens/unknown_route_screen.dart';
import '../../screens/videos_categories.dart';

class ChildHomeRoute{
  static Route generatedRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (context) => ChildHomeScreen());

      case '/music':
        return MaterialPageRoute(builder: (context) => Music());

      case '/videos':
        return MaterialPageRoute(builder: (context) => VideosCategories());

      case '/want':
        return MaterialPageRoute(builder: (context) => WantItemsScreen());

      case '/feel':
        return MaterialPageRoute(builder: (context) => FeelItemsList());

      case '/learn':
        return MaterialPageRoute(builder: (context) => LearningTopics());

      case '/test':
        return MaterialPageRoute(builder: (context) => TestCategories());

      case '/stories':
        return MaterialPageRoute(builder: (context) => Stories());





      default:
        return MaterialPageRoute(builder: (context) => UnknownRouteScreen());
    }
  }
}