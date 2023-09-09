import 'dart:io';

import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/core/utils/remove_image_background.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension, TextTranslateExtension, tr;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddShortStoryScreen extends StatefulWidget {
  @override
  _AddShortStoryScreenState createState() => _AddShortStoryScreenState();
}

class _AddShortStoryScreenState extends State<AddShortStoryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _titleArController = TextEditingController();
  final List<Pair> _pairs = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _titleArController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  File? _mainImage;

  bool _isImageUploaded = false;

  void _addPair() {
    setState(() {
      _pairs.add(Pair());
    });
  }

  Future<String?> _uploadImageToFirebaseStorage(File image) async {
    try {
      final firebase_storage.Reference storageRef =
      firebase_storage.FirebaseStorage.instance.ref().child('images');
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final uploadTask = storageRef.child('image_$timestamp').putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  void _submitStory() async {
    final title = _titleController.text;
    final imagePaths = <Map>[];

    for (final pair in _pairs) {
      final imagePath = await _uploadImageToFirebaseStorage(pair.image!);
      if (imagePath != null) {
        imagePaths.add({
          'text': pair.text,
          'text-ar':pair.textAr,
          'image': imagePath
        });
      }
    }
    File removedBackgroundImage = await removeBackground(_mainImage!);
    final uploadedMainImageUrl = await _uploadImageToFirebaseStorage(removedBackgroundImage);

    // Push imagePaths to Firestore
    FirebaseFirestore.instance.collection('users').doc(context.read<AuthStatusBloc>().id).collection('child-short-stories').add({
      'title': title,
      'title-ar':_titleArController.text,
      'mainImage': uploadedMainImageUrl,
      'imagePaths': imagePaths,
    }).then((_){
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_short_story').tr(),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleArController,
                decoration: InputDecoration(
                  labelText: 'title_in_arabic'.tr(),
                  border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 16,),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                    labelText: 'title_in_english'.tr(),
                    border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () async {
                  final imageFile = await _imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (imageFile != null) {
                    setState(() {
                      _mainImage = File(imageFile.path);
                      _isImageUploaded = true;
                    });
                  }
                },
                child: Container(
                  height: 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _isImageUploaded ? Colors.transparent : Colors.black12, // Set non-transparent color when image is not uploaded
                    borderRadius: BorderRadius.circular(12.0),
                    image: _isImageUploaded ? DecorationImage(
                      image: FileImage(_mainImage!),
                      fit: BoxFit.contain,
                    ) : null,
                  ),
                  alignment: Alignment.center,
                  child: _isImageUploaded ? null : Text(
                    'pick_main_image',
                    style: ThemeHelper.headingText(context)?.copyWith(
                      fontSize: 30,
                    ),
                  ).tr(),
                ),
              ),
              SizedBox(height: 16,),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Text(
                      'story_images',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),

                    GestureDetector(
                      onTap: _addPair,
                      child: Icon(Icons.add,size: 40,color: ThemeHelper.headingText(context)?.color,),
                    )
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _pairs.length,
                itemBuilder: (context, index) {
                  final pair = _pairs[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () async {
                            final imageFile = await _imagePicker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (imageFile != null) {
                              setState(() {
                                pair.image = File(imageFile.path);
                              });
                            }
                          },
                          child: pair.image != null
                              ? Container(
                              child: Image.file(pair.image!))
                              : Container(
                            height: 128,
                            color: Colors.black12,
                            child: Icon(Icons.add,size: 40,color: ThemeHelper.headingText(context)?.color,),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'text_in_arabic'.tr(),
                                border: OutlineInputBorder()
                              ),
                              onChanged: (value) {
                                pair.textAr = value;
                              },
                            ),
                            SizedBox(height: 8.0,),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'text_in_english'.tr(),
                                border: OutlineInputBorder()
                              ),
                              onChanged: (value) {
                                pair.text = value;
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ThemeHelper.fullSizePrimaryButtonStyle(context).copyWith(
                    minimumSize: MaterialStatePropertyAll(Size(double.infinity,50))
                ),
                onPressed: _submitStory,
                child: Text('add',style: ThemeHelper.headingText(context)?.copyWith(
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

class Pair {
  File? image;
  String? text;
  String? textAr;
}