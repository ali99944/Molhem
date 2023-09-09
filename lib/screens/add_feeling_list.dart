import 'dart:io';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/core/utils/remove_image_background.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension, TextTranslateExtension, tr;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddFeelingScreen extends StatefulWidget {
  const AddFeelingScreen({Key? key}) : super(key: key);

  @override
  _AddFeelingScreenState createState() => _AddFeelingScreenState();
}

class _AddFeelingScreenState extends State<AddFeelingScreen> {
  final contentController = TextEditingController();
  final arabicContentController = TextEditingController();
  final imageUrlController = TextEditingController();

  bool _isImageFromUrl = true;
  String? _imageUrl;
  File? _image;

  final picker = ImagePicker();

  String _selectedDegree = 'good'; // Default selected degree value
  List<String> _degreeOptions = ['good', 'bad']; // Available degree options

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
    arabicContentController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add_feeling').tr(),
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
              controller: arabicContentController,
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
                  child: Text(value).tr(),
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
                const Text('add_image_from_url').tr(),
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
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: _image != null
                              ? BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            ),
                          )
                              : BoxDecoration(
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Rest of the code...
                      ],
                    ),
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
                              fontSize: 24
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
                          child: AutoSizeText('choose_from_gallery'.tr(),maxLines: 1,style: TextStyle(
                              fontSize: 24
                          ),),
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
                style: ThemeHelper.fullSizePrimaryButtonStyle(context).copyWith(
                    minimumSize: MaterialStatePropertyAll(Size(double.infinity,60))
                ),
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
                        .collection('child-feelings')
                        .add({
                      'content': contentController.text,
                      'content-ar': arabicContentController.text,
                      'image': _imageUrl,
                      'degree': _selectedDegree
                    });
                  } else {
                    final Reference storageRef = FirebaseStorage.instance
                        .ref()
                        .child('feelings/${DateTime.now()}.jpg');

                    final removedBackgroundImage = await removeBackground(_image!);
                    final UploadTask uploadTask = storageRef.putFile(removedBackgroundImage);

                    final TaskSnapshot downloadUrl = (await uploadTask);
                    final String url = await downloadUrl.ref.getDownloadURL();

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(ref)
                        .collection('child-feelings')
                        .add({
                      'content': contentController.text,
                      'content-ar': arabicContentController.text,
                      'image': url,
                      'degree': _selectedDegree
                    });
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