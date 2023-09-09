import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth_status_bloc/auth_status_bloc.dart';

Future<void> showChangeLanguageDialog({
  required BuildContext context,
}) async{
  await showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 14,
          contentPadding: EdgeInsets.all(0),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
            ),
            height: 500,
            width: 320,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/Helper2.png'),
                  AutoSizeText('change_language_dialog'.tr(args: [context.read<AuthStatusBloc>().userInformation!.username.toString()]),style: ThemeHelper.headingText(context)?.copyWith(
                      fontSize: 30
                  ),maxLines: 1,),
                  SizedBox(height: 12.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async{
                          await context.setLocale(Locale('en',''));
                          Navigator.pop(context);
                          // Perform any necessary actions for changing the language
                        },
                        child: Text('english',style: ThemeHelper.headingText(context)?.copyWith(
                            fontSize: 28
                        ),).tr(),
                      ),
                      SizedBox(width: 16.0,),
                      GestureDetector(
                        onTap: () async{
                          await context.setLocale(Locale('ar',''));
                          Navigator.pop(context);
                          // Perform any necessary actions for changing the language
                        },
                        child: Text('arabic',style: ThemeHelper.headingText(context)?.copyWith(
                            fontSize: 28
                        ),).tr(),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }
  );
}