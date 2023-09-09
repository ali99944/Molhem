import 'dart:io';

import 'package:Molhem/data/models/user_information.dart';
import 'package:Molhem/screens/avatar_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:image_picker/image_picker.dart';

import 'avatar.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _ageController = TextEditingController();
  bool _isLoading = false;
  File? _selectedImage;

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('edit_profile',style: TextStyle(
          color: Colors.white,
          fontSize: 24
        ),).tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FluttermojiCircleAvatar(
                backgroundColor: ThemeHelper.blueAlter,
              ),
              SizedBox(height: 12.0,),
              TextButton(onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => avatar())
                );
              }, child: Text('change_picture',style: TextStyle(
                fontSize: 28,
                color: ThemeHelper.blueAlter
              ),).tr()),
              SizedBox(height: 32),

              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,color: ThemeHelper.blueAlter
                      )
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,color: ThemeHelper.blueAlter
                        )
                    ),
                    labelText: 'username'.tr(),
                    prefixIcon: Icon(Icons.text_fields)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "username_empty".tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.numbers),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3,color: ThemeHelper.blueAlter
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3,color: ThemeHelper.blueAlter
                      )
                  ),
                  labelText: 'age'.tr(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "age_empty".tr();
                  }
                  int age = int.parse(value);
                  if (age < 0) {
                    return 'valid_age'.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: ThemeHelper.fullSizePrimaryButtonStyle(context).copyWith(
                  minimumSize: MaterialStatePropertyAll(Size(double.infinity,50))
                ),
                onPressed: _isLoading ? null : _onSaveChangesPressed,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('save_changes').tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _onSaveChangesPressed() async {
    if (_formKey.currentState!.validate()) {



      // Save the user profile data in Firestore
      final Map<String,dynamic> user = {};

      if(_usernameController.text.isNotEmpty){
        user.addAll({
          'username':_usernameController.text
        });
      }

      if(_ageController.text.isNotEmpty){
        user.addAll({
          'age': int.parse(_ageController.text)
        });
      }
      await FirebaseFirestore.instance.collection('users').doc(
        context.read<AuthStatusBloc>().id
      ).update(user);


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('profile_update_notify'.tr())),
      );

      Navigator.pop(context);
    }
  }

  void _loadUserInformation() {
    UserInformation? userInformation = context.read<AuthStatusBloc>().userInformation;
    if(userInformation != null){
      _usernameController.text = userInformation.username;
      _ageController.text = userInformation.age == null ? '0' : userInformation.age.toString();
    }
  }
}