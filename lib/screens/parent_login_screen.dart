import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/screens/child_home_screen.dart';
import 'package:Molhem/screens/parent_home_screen.dart';
import 'package:Molhem/screens/register_screen.dart';
import 'package:Molhem/screens/welcome_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Molhem/screens/child_login_screen.dart';

import '../blocs/login_bloc/login_bloc.dart';
import '../core/utils/get_device_token.dart';
import '../data/entities/user_auth_credentials.dart';
import '../services/user_services.dart';

class ParentLoginScreen extends StatefulWidget {
  static const String route = '/parentLogin';

  ParentLoginScreen({Key? key}) : super(key: key);

  @override
  State<ParentLoginScreen> createState() => _ParentLoginScreenState();
}

class _ParentLoginScreenState extends State<ParentLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

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
                      SizedBox(height: 120,),
                      SizedBox(
                        height: 40,
                        child: AutoSizeText(
                          "login_parent".tr(),
                          style: ThemeHelper.headingText(context)?.copyWith(
                            fontSize: 26
                          ),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: 30.sp),
                      Column(
                        children: [
                          SizedBox(
                            height: 60,
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff7ea5ad),
                                        width: 3
                                    )
                                ),
                                labelStyle: TextStyle(
                                    color: Color(0xff7ea5ad)
                                ),
                                labelText: 'email'.tr(),
                                hintText: 'enter_your_email'.tr(),
                                border: OutlineInputBorder(

                                ),

                                prefixIcon: Icon(Icons.email,color: Color(0xff7ea5ad),),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'enter_your_email'.tr();
                                }
                                if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                                  return 'enter_valid_email'.tr();
                                }
                                return null;
                              },
                              onSaved: (value) {
                                // Save the email
                              },
                            ),
                          ),
                          SizedBox(height: 20.sp),
                          SizedBox(
                            height: 60,
                            child: TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(

                                  labelText: 'password'.tr(),
                                  hintText: 'enter_your_password'.tr(),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff7ea5ad),
                                          width: 3
                                      )
                                  ),
                                  labelStyle: TextStyle(
                                      color: Color(0xff7ea5ad)
                                  ),
                                  prefixIcon: Icon(Icons.lock,color: Color(0xff7ea5ad),),
                                  suffix: GestureDetector(
                                    onTap: () {setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                    },
                                    child: Icon(
                                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'enter_your_password'.tr();
                                  }
                                  return null;
                                },
                                onSaved: (value) {
// Save the password
                                }),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.sp),
                      SizedBox(
                        height: 50.sp,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ThemeHelper.fullSizePrimaryButtonStyle(context),
                          onPressed: () async {
                            UserAuthCredentials userAuthCredentials = UserAuthCredentials(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            context.read<LoginBloc>().add(
                              LoginButtonPressed(
                                userAuthCredentials: userAuthCredentials,
                                role: 'parent',
                              ),
                            );
                          },
                          child: Text(
                            'login'.tr(),
                            style: TextStyle(fontSize: 18.sp),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.sp),
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
                          child: Text(
                            "no_email",
                            style: TextStyle(fontSize: 18.sp,color:Color(0xff7ea5ad),fontWeight: FontWeight.normal),
                          ).tr(),
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