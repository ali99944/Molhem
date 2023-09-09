import 'dart:io';

import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension, TextTranslateExtension, tr;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../core/utils/UpperFirstLetter.dart';
import '../core/utils/remove_image_background.dart';

class AddNewTopicItemScreen extends StatefulWidget {
  final String topicId;

  const AddNewTopicItemScreen({super.key,required this.topicId});
  @override
  _AddNewTopicItemScreenState createState() => _AddNewTopicItemScreenState();
}

class _AddNewTopicItemScreenState extends State<AddNewTopicItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameArController = TextEditingController();
  final TextEditingController _descriptionArController = TextEditingController();
  File? _iconImage;
  List<File> _images = [];

  Future<void> _pickIconImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _iconImage = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _pickMultipleImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    setState(() {
      _images = pickedFiles != null
          ? pickedFiles.map((file) => File(file.path)).toList()
          : [];
    });
  }

  Future<void> _submitForm() async {
    final CollectionReference itemsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(context.read<AuthStatusBloc>().id)
        .collection('child-learning')
        .doc(widget.topicId)
        .collection('items');

    final List<String> imageUrls = [];
    String iconImageUrl = '';
    // Upload icon image
    if (_iconImage != null) {
      final Reference iconStorageRef = FirebaseStorage.instance
          .ref()
          .child('learning/${DateTime.now()}_icon.jpg');
      File removedBackgroundImage = await removeBackground(_iconImage!);
      final UploadTask iconUploadTask = iconStorageRef.putFile(removedBackgroundImage);
      final TaskSnapshot iconDownloadUrl = await iconUploadTask;
      final String iconUrl = await iconDownloadUrl.ref.getDownloadURL();
      iconImageUrl = iconUrl;
    }

    // Upload multiple images
    for (var element in _images) {
      final Reference imageStorageRef = FirebaseStorage.instance
          .ref()
          .child('learning/${DateTime.now()}_${element.path.split('/').last}');
      final UploadTask imageUploadTask = imageStorageRef.putFile(element);
      final TaskSnapshot imageDownloadUrl = await imageUploadTask;
      final String imageUrl = await imageDownloadUrl.ref.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    final Map<String, dynamic> itemData = {
      'iconImage': iconImageUrl,
      'images': imageUrls,
      'name': _nameController.text,
      'description': _descriptionController.text,
      'name-ar':_nameArController.text,
      'description-ar':_descriptionArController.text
    };

    await itemsCollection.add(itemData).then((value) {
      Fluttertoast.showToast(
        msg: "Item added successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xff7ea5ad),
        textColor: Colors.white,
        fontSize: 24.0,
      );
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _nameArController.dispose();
    _descriptionArController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add_new_topic_item").tr(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              TextFormField(
                controller: _nameArController,
                decoration: InputDecoration(
                  labelText: 'name'.tr(),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter_name'.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionArController,
                decoration: InputDecoration(
                  labelText: 'description'.tr(),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter_description'.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Directionality(
                textDirection: TextDirection.ltr,
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Name';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Directionality(
                textDirection: TextDirection.ltr,
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Description';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Text('main_image',style: TextStyle(fontSize: 20),).tr(),
              GestureDetector(
                onTap: _pickIconImage,
                child: Container(
                  width: double.infinity,
                  height: 150.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: _iconImage != null
                        ? Image.file(_iconImage!)
                        : Icon(Icons.add_a_photo),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: _pickMultipleImages,
                child: Container(
                  width: double.infinity,
                  height: 150.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: _images.isNotEmpty
                        ? GridView.count(
                            crossAxisCount: 3,
                            children: _images.map((image) {
                              return Image.file(image);
                            }).toList(),
                          )
                        : Text('add_images').tr(),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('submit').tr(),
                  style: ThemeHelper.fullSizePrimaryButtonStyle(context)
                ),
              ),
              SizedBox(height: 12.0,)
            ],
          ),
        ),
      ),
    );
  }
}
