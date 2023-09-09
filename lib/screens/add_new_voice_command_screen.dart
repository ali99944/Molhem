import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddVoiceCommandScreen extends StatefulWidget {
  @override
  _AddVoiceCommandScreenState createState() => _AddVoiceCommandScreenState();
}

class _AddVoiceCommandScreenState extends State<AddVoiceCommandScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _prompt;
  String? _answer;
  String? _promptAr;
  String? _answerAr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_new_command').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'prompt_in_arabic'.tr(),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'enter_prompt'.tr();
                  }
                  return null;
                },
                onSaved: (value) {
                  _promptAr = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'answer_in_arabic'.tr(),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'enter_answer'.tr();
                  }
                  return null;
                },
                onSaved: (value) {
                  _answerAr = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'prompt_in_english'.tr(),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                if (value!.isEmpty) {
                  return 'enter_prompt'.tr();
                }
                return null;
                },
                onSaved: (value) {
                  _prompt = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'answer_in_english'.tr(),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'enter_answer'.tr();
                  }
                  return null;
                },
                onSaved: (value) {
                  _answer = value!;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    FirebaseFirestore firestore = FirebaseFirestore.instance;
                    String? id = context.read<AuthStatusBloc>().id;

                    await firestore
                        .collection('users')
                        .doc(id)
                        .collection('child-voice-commands')
                        .add({ 'prompt': _prompt,'answer':_answer,'prompt-ar':_promptAr,'answer-ar':_answerAr });


                    Navigator.pop(context);
                  }
                },
                style: ThemeHelper.fullSizePrimaryButtonStyle(context).copyWith(
                  minimumSize: MaterialStatePropertyAll(Size(double.infinity,50))
                ),
                child: Text('add_command',style: ThemeHelper.headingText(context)?.copyWith(
                  fontSize: 28
                ),).tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}