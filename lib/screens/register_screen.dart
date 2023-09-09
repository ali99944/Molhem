import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../blocs/register_bloc/register_bloc.dart';
import '../core/helpers/theme_helper.dart';
import '../data/entities/user_auth_credentials.dart';
import '../data/models/user_information.dart';


class RegisterScreen extends StatefulWidget {
  static const String route = '/signup';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _username;
  late TextEditingController _email;
  late TextEditingController _phone;
  late TextEditingController _password;
  late TextEditingController _childPassword;

  bool _isChildSecured = true;
  bool _isParentSecured = true;

  @override
  void initState() {
    super.initState();
    _username = TextEditingController();
    _email = TextEditingController();
    _phone = TextEditingController();
    _password = TextEditingController();
    _childPassword = TextEditingController();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    _childPassword.dispose();
    super.dispose();
  }

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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 20.sp),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100.sp),
                SizedBox(
                  height: 40,
                  child: AutoSizeText(
                    'register'.tr(),
                    style: ThemeHelper.headingText(context),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 16,),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: _username,
                    keyboardType: TextInputType.name,
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
                      labelText: 'username'.tr(),
                      hintText: 'enter_your_username'.tr(),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.person,color: Color(0xff7ea5ad)
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter_your_username'.tr();
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // Save the username
                    },
                  ),
                ),
                SizedBox(height: 16.sp),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: _email,
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
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.email,color: Color(0xff7ea5ad)
                      ),
                    ),
                    validator: (value){
                      if (value!.isEmpty) {
                        return 'enter_your_email'.tr();
                      }
                      if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'enter_valid_email'.tr();
                      }
                      return null;
                    },
                    onSaved: (value) {
// Save the email
                    },
                  ),
                ),
                SizedBox(height: 16.sp),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: _password,
                    obscureText: _isParentSecured,
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
                      labelText: 'passwordParent'.tr(),
                      hintText: 'enter_parent_password'.tr(),
                      border: OutlineInputBorder(
                      ),
                      suffix: GestureDetector(
                        onTap: (){
                          setState(() {
                            _isParentSecured = !_isParentSecured;
                          });
                        },
                        child: Icon(_isParentSecured ? Icons.visibility_off : Icons.visibility),
                      ),
                      prefixIcon: Icon(
                          Icons.lock,color: Color(0xff7ea5ad)
                      ),
                    ),
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return 'enter_parent_password'.tr();
                        }
                        if (value.length < 8) {
                          return "password_is_short".tr();
                        }
                      }

                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (value) {
                      // Save the password
                    },
                  ),
                ),
                SizedBox(height: 16.sp),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: _childPassword,
                    obscureText: _isChildSecured,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xff7ea5ad),
                              width: 3
                          )
                      ),
                      suffix: GestureDetector(
                        onTap: (){
                          setState(() {
                            _isChildSecured = !_isChildSecured;
                          });
                        },
                        child: Icon(_isChildSecured ? Icons.visibility_off : Icons.visibility),
                      ),
                      labelStyle: TextStyle(
                          color: Color(0xff7ea5ad)
                      ),
                      labelText: 'passwordChild'.tr(),
                      hintText: 'enter_child_password'.tr(),
                      border: OutlineInputBorder(
                      ),
                      prefixIcon: Icon(
                          Icons.lock,color: Color(0xff7ea5ad)
                      ),
                    ),
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return 'enter_child_password'.tr();
                        }
                        if (value.length < 8) {
                          return "password_is_short".tr();
                        }
                      }

                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (value) {
                      // Save the password
                    },
                  ),
                ),
                SizedBox(height: 16.sp),
                SizedBox(
                  height: 80,
                  child: IntlPhoneField(
                    initialCountryCode: 'JO',
                    controller: _phone,

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
                      prefixIcon: Icon(
                        Icons.phone,color: Color(0xff7ea5ad)
                      ),
                      border: OutlineInputBorder(
                      ),
                      label: Text(
                        'phone_number'.tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      hintText: 'phone_number'.tr(),
                    ),
                  ),
                ),
                SizedBox(height: 16.sp),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      UserInformation userInformation = UserInformation(
                        username: _username.text,
                        email: _email.text,
                        phone: _phone.text,
                      );

                      UserAuthCredentials userAuthCredentials = UserAuthCredentials(
                        email: _email.text,
                        password: _password.text,
                      );

                      context.read<RegisterBloc>().add(
                          RegisterButtonPressed(
                          userInformation: userInformation,
                          userAuthCredentials: userAuthCredentials,
                        ),
                      );
                    },
                    style: ThemeHelper.fullSizePrimaryButtonStyle(context).copyWith(
                      padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.all(12.0))
                    ),
                    child: SizedBox(
                      height: 50,
                      child: AutoSizeText(
                        "register".tr(),
                        style: ThemeHelper.headingText(context)?.copyWith(
                            fontSize: 22.sp
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: ThemeHelper.textButtonTheme(context),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: AutoSizeText(
                      "already_have_account".tr(),
                      style: TextStyle(
                          fontSize: 18.sp,color:Color(0xff7ea5ad),fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
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