import 'dart:io';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/core/utils/remove_image_background.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension, TextTranslateExtension, tr;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddWantScreen extends StatefulWidget {
  const AddWantScreen({Key? key}) : super(key: key);

  @override
  _AddWantScreenState createState() => _AddWantScreenState();
}

class _AddWantScreenState extends State<AddWantScreen> {
  final contentController = TextEditingController();
  final imageUrlController = TextEditingController();
  String _selectedDegree = 'good';
  List<String> _degreeOptions = ['good', 'bad'];

  bool _isImageFromUrl = true;
  String? _imageUrl;
  File? _image;

  final picker = ImagePicker();

  TextEditingController arContentController = TextEditingController();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    contentController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add_want').tr(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Directionality(
              textDirection: TextDirection.ltr,
              child: TextField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: 'content_in_english'.tr(),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: arContentController,
              decoration: InputDecoration(
                labelText: 'content_in_arabic'.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedDegree,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDegree = newValue!;
                });
              },
              items: _degreeOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isImageFromUrl,
                  onChanged: (value) {
                    setState(() {
                      _isImageFromUrl = value ?? true;
                      if (!_isImageFromUrl) {
                        _imageUrl = null;
                      }
                    });
                  },
                ),
                const Text('add_from_url').tr(),
              ],
            ),
            if (_isImageFromUrl)
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(
                  labelText: 'image_url'.tr(),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _imageUrl = value.isNotEmpty ? value : null;
                  });
                },
              )
            else
              Column(
                children: [
                  if (_image != null)
                    Image.file(_image!)
                  else
                    const Placeholder(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _getImage(ImageSource.camera);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeHelper.blueAlter
                          ),
                          child: const Text('take_photo',style: TextStyle(
                            fontSize: 20
                          ),).tr(),
                        ),
                      ),
                      SizedBox(width: 8.0,),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _getImage(ImageSource.gallery);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeHelper.blueAlter
                          ),
                          child: AutoSizeText('choose_from_gallery'.tr(),style: TextStyle(
                            fontSize: 20
                          ),maxLines: 1,),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ThemeHelper.fullSizePrimaryButtonStyle(context),
                onPressed: () async {
                  String ref =
                      (await FirebaseFirestore.instance.collection('users').get())
                          .docs
                          .where((element) =>
                              element['uid'] ==
                              FirebaseAuth.instance.currentUser!.uid)
                          .first
                          .id;
                  if (_isImageFromUrl) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(ref)
                        .collection('child-want')
                        .add({
                      'content': contentController.text,
                      'content-ar':arContentController.text,
                      'image': _imageUrl,
                      'degree': _selectedDegree
                    });
                  } else {
                    final Reference storageRef = FirebaseStorage.instance
                        .ref()
                        .child('wants/${DateTime.now()}.jpg');

                    File removedBackgroundImage = await removeBackground(_image!);

                    final UploadTask uploadTask = storageRef.putFile(removedBackgroundImage);

                    final TaskSnapshot downloadUrl = (await uploadTask);
                    final String url = await downloadUrl.ref.getDownloadURL();
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(ref)
                        .collection('child-want')
                        .add({'content': contentController.text, 'image': url,'degree': _selectedDegree});

                    Navigator.pop(context);
                  }
                },
                child: const Text('save').tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
