import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Molhem/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:Molhem/screens/child_login_screen.dart';
import 'package:lottie/lottie.dart';

import '../core/routes/authentication_route.dart';
import 'parent_login_screen.dart';


class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>{


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ThemeHelper.autismColor,
      body: Stack(
          children: [
            Positioned(
              top: -50,
              left: -100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color:  Color(0xff7ea5ad)
                ),
              ),
            ),Positioned(
              top: -100,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xff8088a9)
                ),
              ),
            ),
            Positioned(
              top: -220,
              left: 50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(300),
                    color: Color(0xffaa6a6a)
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              right: -100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xff7ea5ad)
                ),
              ),
            ),Positioned(
              bottom: -100,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xff8088a9)
                ),
              ),
            ),
            Positioned(
              bottom: -220,
              right: 0,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150),
                    color: Color(0xffaa6a6a)
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 12.sp),
              child: Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 150.sp),
                      SizedBox(
                        height: 50,
                        child: AutoSizeText(
                          "welcome_message".tr(),
                          style: ThemeHelper.headingText(context),


                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: 10.sp),
                      SizedBox(
                        height: 70,
                        child: AutoSizeText(
                          'app_description'.tr(),
                          style: ThemeHelper.sectionText(context)?.copyWith(
                            fontSize: 27,
                          ),
                        ),
                      ),
                      SizedBox(height: 60.sp),
                      SizedBox(
                        height: 60.sp,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ThemeHelper.fullSizePrimaryButtonStyle(context),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              ChildLoginScreen.route,
                            );
                          },
                          child: Text(
                            "child_login".tr(),
                            style: TextStyle(fontSize: 22.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.sp,
                      ),
                      SizedBox(
                        height: 60.sp,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ThemeHelper.fullSizePrimaryButtonStyle(context),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              ParentLoginScreen.route,
                            );
                          },
                          child: Text(
                            "parent_login",
                            style: TextStyle(fontSize: 22.sp),
                          ).tr(),
                        ),
                      ),
                      SizedBox(
                        height: 20.sp,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: TextButton(
                          style: ThemeHelper.textButtonTheme(context),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RegisterScreen.route,
                            );
                          },
                          child: AutoSizeText(
                            "no_email".tr(),
                            style: TextStyle(
                                fontSize: 18.sp,color:Color(0xff7ea5ad),fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 80,
              right: 35,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: ThemeHelper.blueAlter,
                  foregroundColor: Colors.white
                ),
                onPressed: () async{
                  if(context.locale.languageCode == 'en'){
                    context.setLocale(Locale('ar',''));
                  }else{
                    context.setLocale(Locale('en',''));
                  }


                  setState(() {});
                },
                icon: Icon(Icons.language,size: 20,),
                label: Text(context.locale.languageCode.toUpperCase(),style: TextStyle(
                  fontSize: 15
                ),),
              ),
            )

          ],
      ),
    );
  }
}