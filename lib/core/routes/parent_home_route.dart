
import 'package:Molhem/screens/child_home_screen.dart';
import 'package:Molhem/screens/parent_home_screen.dart';
import 'package:flutter/material.dart';

import '../../screens/unknown_route_screen.dart';

class ParentHomeRoute{
  static Route generatedRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (context) => ParentHomeScreen());


      default:
        return MaterialPageRoute(builder: (context) => UnknownRouteScreen());
    }
  }
}