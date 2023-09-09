import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/core/routes/authentication_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreenNavigator extends StatefulWidget {
  const WelcomeScreenNavigator({Key? key}) : super(key: key);

  @override
  State<WelcomeScreenNavigator> createState() => _WelcomeScreenNavigatorState();
}

class _WelcomeScreenNavigatorState extends State<WelcomeScreenNavigator> {
  final GlobalKey<NavigatorState> _nestedNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{

        if (_nestedNavigatorKey.currentState!.canPop()) {
          _nestedNavigatorKey.currentState!.pop();
          return false;
        } else {
          bool willPopup = await showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                    content: AutoSizeText("exit_message".tr()),
                    actions: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context,false);
                        },
                        child: Text('cancel',style: TextStyle(color: Colors.grey),).tr(),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.red),
                        ),
                        onPressed: () {
                          Navigator.pop(context,true);
                        },
                        child: Text('exit',style: TextStyle(color: Colors.white),).tr(),
                      ),
                    ]);
              }
          );

          if(willPopup){
            SystemNavigator.pop();
            return true;
          }else{
            return false;
          }
        }
      },
      child: Navigator(
        key: _nestedNavigatorKey,
        onGenerateRoute: AuthenticationRoute.generatedRoute,
        initialRoute: '/',
      ),
    );
  }


}
