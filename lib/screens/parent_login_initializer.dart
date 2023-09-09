import 'package:Molhem/screens/parent_home_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/core/utils/show_message.dart';
import 'package:Molhem/screens/child_login_screen.dart';
import 'package:Molhem/screens/parent_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/login_bloc/login_bloc.dart';


class ParentLoginInitializer extends StatefulWidget {
  static const String login = '/';
  const ParentLoginInitializer({super.key});

  @override
  State<ParentLoginInitializer> createState() => _ParentLoginInitializerState();
}

class _ParentLoginInitializerState extends State<ParentLoginInitializer> {

  final GlobalKey<NavigatorState> _nestedNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc()..add(ResetLoginInitial()),
      child: Scaffold(
        body: BlocConsumer<LoginBloc,LoginState>(
          listener: (context,state){
            if(state is LoginFailure){
              showMessage(context: context, message: state.message);
            }
          },

          builder: (context,state){
            if(state is LoginLoading){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/hand.png'),
                    SizedBox(height: 16,),
                    CircularProgressIndicator(
                      backgroundColor: Color(0xff7ea5ad),
                      strokeWidth: 6,
                    )
                  ],
                ),
              );
            }
            else if(state is LoginInitial){
              return ParentLoginScreen();
            }
            else if(state is LoginSuccess){
              return ParentHomeScreen();
            }else{
              return Center(
                child: Column(
                  children: const [
                    CircularProgressIndicator(),
                    Text('something unknown in login')
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}