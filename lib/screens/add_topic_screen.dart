import 'dart:io';

import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/utils/remove_image_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../core/helpers/theme_helper.dart';

class AddTopicScreen extends StatefulWidget {
  @override
  _AddTopicScreenState createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AddTopicScreen> {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  File? _image;
  bool _useUrlImage = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  void dispose() {
    _topicController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_topic').tr(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'topic'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _topicController,
              decoration: InputDecoration(
                hintText: 'enter_topic'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'image',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ).tr(),
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _useUrlImage,
                  fillColor: MaterialStatePropertyAll(ThemeHelper.blueAlter),
                  checkColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      _useUrlImage = value!;
                    });
                  },
                ),
                Text('use_url_image').tr(),
              ],
            ),
            _useUrlImage ? _buildImageUrlField() : _buildImagePicker(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ThemeHelper.fullSizePrimaryButtonStyle(context).copyWith(
                  minimumSize: MaterialStatePropertyAll<Size>(Size(double.infinity,50))
                ),
                onPressed: _submit,
                child: Text('submit',style: ThemeHelper.headingText(context)?.copyWith(
                  fontSize: 30
                ),).tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () => _showImagePicker(context),
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
          image: _image != null
              ? DecorationImage(
            image: FileImage(_image!),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: _image == null
            ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
            : null,
      ),
    );
  }

  Widget _buildImageUrlField() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        TextField(
        controller: _imageUrlController,
          decoration: InputDecoration(
            hintText: 'enter_url_image'.tr(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
          ),
        ),
          SizedBox(height: 10),
          if (_imageUrlController.text.isNotEmpty)
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(_imageUrlController.text),
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
    );
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('take_photo').tr(),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('choose_from_gallery').tr(),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit() async {
    final topic = _topicController.text.trim();

    if (topic.isEmpty) {
      return;
    }

    String imageUrl;
    if (_useUrlImage) {
      imageUrl = _imageUrlController.text.trim();
    } else {
      final Reference storageRef =
      FirebaseStorage.instance.ref().child('wants/${DateTime.now()}.jpg');
      File removedBackgroundImage = await removeBackground(_image!);
      final UploadTask uploadTask = storageRef.putFile(removedBackgroundImage);

      final TaskSnapshot downloadUrl = await uploadTask;
      imageUrl = await downloadUrl.ref.getDownloadURL();
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(context.read<AuthStatusBloc>().id)
        .collection('child-learning')
        .add({'category': _topicController.text, 'iconImage': imageUrl})
        .then((value) => Navigator.pop(context));
  }
}