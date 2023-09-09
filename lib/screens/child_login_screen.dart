import 'dart:async';

import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/services/user_services.dart';
import 'package:Molhem/wrappers/authentication_wrapper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Molhem/screens/child_home_screen.dart';

import '../blocs/login_bloc/login_bloc.dart';
import '../data/entities/user_auth_credentials.dart';

class ChildLoginScreen extends StatefulWidget {
  static const String route = '/childLogin';
  ChildLoginScreen({super.key});

  @override
  State<ChildLoginScreen> createState() => _ChildLoginScreenState();
}

class _ChildLoginScreenState extends State<ChildLoginScreen>{
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _sessionTime = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
          Container(
            width: size.width.w,
            height: size.height.h,
            padding: const EdgeInsets.symmetric(horizontal: 30, ),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 150,),
                    SizedBox(
                      height: 40,
                      child: AutoSizeText(
                          "login_child".tr(),
                          style: ThemeHelper.headingText(context)?.copyWith(
                            fontSize: 26
                          ),maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 16,),
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'email'.tr(),
                          hintText: 'enter_your_email'.tr(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff7ea5ad),
                                  width: 3
                              )
                          ),
                          labelStyle: TextStyle(
                              color: Color(0xff7ea5ad)
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email,  color: Color(0xff7ea5ad)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter_your_email'.tr();
                          }
                          if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'enter_valid_Email'.tr();
                          }
                          return null;
                        },
                        onSaved: (value) {
                          // Save the email
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: _password,
                        keyboardType: TextInputType.name,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                            labelText: "password".tr(),
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
                            prefixIcon: Icon(Icons.person,color: Color(0xff7ea5ad),),
                            suffix: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              child: Icon(_isPasswordVisible? Icons.visibility_off : Icons.visibility),
                            )
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter_your_password'.tr();
                          }
                          return null;
                        },
                        onSaved: (value) {
                          // Save the username
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: _sessionTime,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "session_time".tr(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff7ea5ad),
                                  width: 3
                              )
                          ),
                          labelStyle: TextStyle(
                              color: Color(0xff7ea5ad)
                          ),
                          hintText: 'session_instruction'.tr(),
                          prefixIcon: Icon(Icons.history,color: Color(0xff7ea5ad),),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 50.sp,
                      child: ElevatedButton(
                        onPressed: ()async {
                          UserAuthCredentials userAuthCredentials = UserAuthCredentials(
                              email: _email.text,
                              password: _password.text
                          );

                          context.read<LoginBloc>().add(
                              LoginButtonPressed(
                                  userAuthCredentials: userAuthCredentials,
                                  role: 'child'
                              )
                          );

                          Timer(Duration(minutes: int.parse(_sessionTime.text)),()async{
                            await FirebaseAuth.instance.signOut();
                          });
                        },
                        style: ThemeHelper.fullSizePrimaryButtonStyle(context),
                        child: Text('login',style: TextStyle(
                          fontSize: 22.sp
                        ),).tr(),
                      ),
                    ),
                  ]),
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
