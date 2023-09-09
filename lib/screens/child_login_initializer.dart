import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/core/utils/show_message.dart';
import 'package:Molhem/screens/child_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/login_bloc/login_bloc.dart';
import 'child_home_screen.dart';


class ChildLoginInitializer extends StatefulWidget {
  static const String login = '/';
  const ChildLoginInitializer({super.key});

  @override
  State<ChildLoginInitializer> createState() => _ChildLoginInitializerState();
}

class _ChildLoginInitializerState extends State<ChildLoginInitializer> {

  final GlobalKey<NavigatorState> _nestedNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc()..add(ResetLoginInitial()),
      child: WillPopScope(
        onWillPop: () async{

          if (_nestedNavigatorKey.currentState!.canPop()) {
            _nestedNavigatorKey.currentState!.pop();
            return false;
          } else {
            bool willPopup = await showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                      content: AutoSizeText("are you sure you want to exit the app ?"),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context,false);
                          },
                          child: Text('Cancel',style: TextStyle(color: Colors.grey),),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Colors.red),
                          ),
                          onPressed: () {
                            Navigator.pop(context,true);
                          },
                          child: Text('exit',style: TextStyle(color: Colors.white),),
                        ),
                      ]);
                }
            );

            if(willPopup){
              if(Navigator.canPop(context)){
                return true;
              }else{
                SystemNavigator.pop();
                return false;
              }
            }else{
              return false;
            }
          }
        },
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
                return ChildLoginScreen();
              }
              else if(state is LoginSuccess){
                return ChildHomeScreen();
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
      ),
    );
  }
}