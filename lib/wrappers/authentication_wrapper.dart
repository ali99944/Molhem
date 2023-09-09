import 'package:Molhem/screens/welcome_screen_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/auth_status_bloc/auth_status_bloc.dart';
import '../screens/child_home_screen_navigator.dart';
import '../screens/parent_home_screen.dart';
import '../screens/parent_home_screen_navigator.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';


class AuthenticationWrapper extends StatefulWidget {

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthStatusBloc,AuthStatusState>(
        builder: (context,state){
          if(state is UserLoggedInState){
            if(state.loggedAs == 'child'){
              return const ChildHomeScreenNavigator();
            }else if(state.loggedAs == 'parent'){
              return const ParentHomeScreenNavigator();
            }

            return Container(
              child: WelcomeScreenNavigator(),
            );
          }
          else if(state is UserNotLoggedInState){
            return WelcomeScreenNavigator();
          }else if(state is AuthStatusInitial){
            return const SplashScreen();
          }else{
            return Container(
              alignment: Alignment.center,
              child: Text('state is not implemented'),
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
