import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showFeedbackMotivation({
  required BuildContext context,
  required String message,
  required String imageAssetPath
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
                  Image.asset(imageAssetPath),
                  AutoSizeText(message,style: ThemeHelper.headingText(context)?.copyWith(
                    fontSize: 30
                  ),maxLines: 1,),
                  SizedBox(height: 12.0,),
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                    ),
                    child: Text(
                      'lets_go',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff7ea5ad),
                      ),
                    ).tr(),
                  ),
                ],
              ),
            ),
          ),
        );
      }
  );
}