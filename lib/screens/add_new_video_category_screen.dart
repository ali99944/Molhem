import 'dart:io';

import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/core/utils/remove_image_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddNewVideoCategory extends StatefulWidget {
  @override
  _AddNewVideoCategoryState createState() => _AddNewVideoCategoryState();
}

class _AddNewVideoCategoryState extends State<AddNewVideoCategory> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _categoryArController = TextEditingController();
  File? _image;
  bool _removeBackgroundImage = false;

  Future<void> _getImage(ImageSource source) async {
    final pickedImage = await ImagePicker().getImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_new_video_category').tr(),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
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
            Row(
              children: [
                Checkbox(
                  value: _removeBackgroundImage,
                  checkColor: Colors.white,
                  fillColor: MaterialStatePropertyAll(ThemeHelper.blueAlter),
                  onChanged: (value) {
                    setState(() {
                      _removeBackgroundImage = value ?? false;
                    });
                  },
                ),
                Text('remove_background_image',style: TextStyle(
                  fontSize: 18
                ),).tr(),
              ],
            ),
            SizedBox(height: 16.0),
            if (_image == null)
              SizedBox(
                height: 50,
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(120,50),
                      backgroundColor: Colors.black12

                  ),
                  onPressed: () {
                    _getImage(ImageSource.gallery);
                  },
                  child: Text('add_image',style: ThemeHelper.headingText(context)?.copyWith(
                    fontSize: 26,
                  ),).tr(),
                ),
              ),
            if (_image != null) ...[
              Image.file(
                _image!,
                height: 200,
              ),
              SizedBox(height: 16.0),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _removeImage();
                  },
                  child: Text('remove_image').tr(),
                ),
              ),
            ],
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ThemeHelper.fullSizePrimaryButtonStyle(context).copyWith(
                minimumSize: MaterialStatePropertyAll(Size(double.infinity, 50)),
              ),
              onPressed: () async {
                if (_image == null) {
                  // Handle the case where no image is selected
                  return;
                }

                File? imageUrl = _image;

                if (_removeBackgroundImage) {
                  imageUrl = await removeBackground(_image!);
                }

                final storage = FirebaseStorage.instance;
                final storageRef = storage.ref();
                final imageId = const Uuid().v4(); // Generate a unique ID for the image
                final uploadRef = storageRef.child('images/$imageId.jpg');
                final uploadTask = uploadRef.putFile(imageUrl!);
                final snapshot = await uploadTask.whenComplete(() {});
                final url = await snapshot.ref.getDownloadURL();

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(context.read<AuthStatusBloc>().id)
                    .collection('child-videos')
                    .add({
                  'category': _categoryController.text,
                  'category-ar': _categoryArController.text,
                  'image': url,
                }).then((value) => Navigator.pop(context));
              },
              child: Text(
                'submit',style: ThemeHelper.headingText(context)?.copyWith(fontSize: 30),
              ).tr(),
            ),
          ],
        ),
      ),
    );
  }
}



