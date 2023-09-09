import 'package:Molhem/screens/child_login_initializer.dart';
import 'package:Molhem/screens/parent_login_initializer.dart';
import 'package:Molhem/screens/signup_initializer.dart';
import 'package:Molhem/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

import '../../screens/child_login_screen.dart';
import '../../screens/parent_login_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/unknown_route_screen.dart';

class AuthenticationRoute{
  static Route generatedRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (context) => WelcomeScreen());
      case ParentLoginScreen.route:
        return MaterialPageRoute(builder: (context) => ParentLoginInitializer());
      case ChildLoginScreen.route:
        return MaterialPageRoute(builder: (context) => ChildLoginInitializer());
      case RegisterScreen.route:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => SignupInitializer(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      default:
        return MaterialPageRoute(builder: (context) => UnknownRouteScreen());
    }
  }
}