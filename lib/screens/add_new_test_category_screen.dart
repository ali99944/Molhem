import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension, TextTranslateExtension, tr;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/helpers/theme_helper.dart';

class AddNewTestCategoryScreen extends StatefulWidget {
  @override
  _AddNewTestCategoryScreenState createState() => _AddNewTestCategoryScreenState();
}

class _AddNewTestCategoryScreenState extends State<AddNewTestCategoryScreen> {
  final _categoryController = TextEditingController();
  final _categoryArController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_test_category').tr(),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              textDirection: TextDirection.rtl,
              controller: _categoryArController,
              decoration: InputDecoration(
                labelText: 'category_in_arabic'.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'category_in_english'.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async{
                await FirebaseFirestore
                    .instance
                    .collection('users')
                    .doc(context.read<AuthStatusBloc>().id)
                    .collection('child-tests')
                    .add({ 'category': _categoryController.text,'category-ar':_categoryArController.text })
                    .then((value){
                      Navigator.pop(context);
                    });
              },
              child: Text('add',style: ThemeHelper.headingText(context)?.copyWith(
                fontSize: 26
              ),).tr(),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                backgroundColor: ThemeHelper.blueAlter
              ),
            ),
          ],
        ),
      ),
    );
  }
}