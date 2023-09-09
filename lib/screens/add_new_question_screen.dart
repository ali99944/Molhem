import 'dart:io';

import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../core/helpers/theme_helper.dart';
import '../core/utils/remove_image_background.dart';

class AddNewQuestionScreen extends StatefulWidget {
  @override
  _AddNewQuestionScreenState createState() => _AddNewQuestionScreenState();
}

class _AddNewQuestionScreenState extends State<AddNewQuestionScreen> {
  final _titleController = TextEditingController();
  final _titleArController = TextEditingController();
  final _hintController = TextEditingController();
  final _hintArController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _descriptionArController = TextEditingController();
  final _answerIndexController = TextEditingController();
  final _answer1Controller = TextEditingController();
  final _answer2Controller = TextEditingController();
  final _answer3Controller = TextEditingController();
  final _answer4Controller = TextEditingController();
  String? _selectedCategory;

  List<Map> _categories = [];

  bool _showImagePicker = false;

  Future<void> _loadCategories() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot data = await firestore
        .collection('users')
        .doc(context.read<AuthStatusBloc>().id)
        .collection('child-tests')
        .get();

    List<Map> cats = [];
    for (var element in data.docs) {
      cats.add({
        'id': element.id,
        'category': context.locale.languageCode == 'en'
            ? element.get('category')
            : element.get('category-ar')
      });
    }

    setState(() {
      _categories = cats;
    });
  }

  File? _imageFile;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('add_question').tr(),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['id'],
                  child: Text(category['category']),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'category'.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _titleArController,
              decoration: InputDecoration(
                labelText: 'title_in_arabic'.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'title_in_english'.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            CheckboxListTile(
              title: Text('add_image').tr(),
              value: _showImagePicker,
              onChanged: (bool? value) {
                setState(() {
                  _showImagePicker = value!;
                });
              },
            ),
            if (_showImagePicker)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('select_image').tr(),
                  ),
                  if (_imageFile != null) Image.file(_imageFile!),
                ],
              ),
            SizedBox(height: 16.0),
            TextField(
              controller: _hintArController,
              decoration: InputDecoration(
                labelText: 'hint_in_arabic'.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _hintController,
              decoration: InputDecoration(
                labelText: 'hint_in_english'.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionArController,
              decoration: InputDecoration(
                labelText: 'description_in_arabic'.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'description_in_english'.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _answerIndexController,
              decoration: InputDecoration(
                labelText: 'answer_index'.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text('answers', style: Theme.of(context).textTheme.headline6).tr(),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _answer1Controller,
                    decoration: InputDecoration(
                      labelText: 'answer_no'.tr(args: ['1']),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: _answer2Controller,
                    decoration: InputDecoration(
                      labelText: 'answer_no'.tr(args: ['2']),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _answer3Controller,
                    decoration: InputDecoration(
                      labelText: 'answer_no'.tr(args: ['3']),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: _answer4Controller,
                    decoration: InputDecoration(
                      labelText: 'answer_no'.tr(args: ['4']),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String? imageUrl;

                if (_imageFile != null) {
                  // Upload image to Firebase Storage
                  final imageRef = _storage
                      .ref()
                      .child('question_images/${DateTime.now()}.png');
                  File removedBackgroundImage =
                      await removeBackground(_imageFile!);
                  final uploadTask = imageRef.putFile(removedBackgroundImage);
                  final snapshot = await uploadTask.whenComplete(() {});
                  imageUrl = await snapshot.ref.getDownloadURL();
                }
                FirebaseFirestore firestore = FirebaseFirestore.instance;
                Map<String, dynamic> question = {
                  'question': _titleController.text,
                  'hint': _hintController.text,
                  'description': _descriptionController.text,
                  'question-ar': _titleArController.text,
                  'hint-ar': _hintArController.text,
                  'description-ar': _descriptionArController.text,
                  'answer': int.parse(_answerIndexController.text) - 1,
                  'image': imageUrl,
                  'choices': [
                    _answer1Controller.text,
                    _answer2Controller.text,
                    _answer3Controller.text,
                    _answer4Controller.text
                  ]
                };

                await firestore
                    .collection('users')
                    .doc(context.read<AuthStatusBloc>().id)
                    .collection('child-tests')
                    .doc(_selectedCategory)
                    .collection('questions')
                    .add(question);

                Navigator.pop(context);
              },
              style: ThemeHelper.fullSizePrimaryButtonStyle(context).copyWith(
                  minimumSize:
                      MaterialStatePropertyAll(Size(double.infinity, 60))),
              child: Text(
                'add',
                style: ThemeHelper.headingText(context)?.copyWith(fontSize: 30),
              ).tr(),
            ),
          ],
        ),
      ),
    );
  }
}
