import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/screens/register_screen.dart';
import 'package:Molhem/wrappers/authentication_wrapper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/register_bloc/register_bloc.dart';
import '../core/utils/show_message.dart';

class SignupInitializer extends StatefulWidget {
  static const String register = '/register';

  const SignupInitializer({super.key});

  @override
  State<SignupInitializer> createState() => _SignupInitializerState();
}

class _SignupInitializerState extends State<SignupInitializer> {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc()..add(ResetRegisterInitial()),
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            Navigator.pop(context);
          } else if (state is RegisterFailure) {
            showMessage(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is RegisterInitial) {
            return RegisterScreen();
          } else if (state is RegisterLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is RegisterSuccess) {
            return Container();
          }else if(state is GettingEverythingReady){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(strokeWidth: 8,color:ThemeHelper.blueAlter,),
                SizedBox(height: 12,),
                AutoSizeText("getting_ready".tr(),style: ThemeHelper.headingText(context),maxLines: 1,)
              ],
            );
          } else if(state is RegisterFailure){
            return Center(
              child: Text(state.message,style: TextStyle(),),
            );
          }else{
            return const Center(
              child: Text(
                'state is not implemented',
                style: TextStyle(fontSize: 30),
              ),
            );
          }
        },
      ),
    );
  }
}