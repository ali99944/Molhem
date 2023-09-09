import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

import '../core/helpers/theme_helper.dart';

class AddMusicScreen extends StatefulWidget {
  @override
  _AddMusicScreenState createState() => _AddMusicScreenState();
}

class _AddMusicScreenState extends State<AddMusicScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameArController = TextEditingController();
  final _sourceController = TextEditingController();

  bool _uploadFromDevice = false;
  File? _musicFile;
  bool _isUploading = false;
  String _url = '';

  @override
  void dispose() {
    _nameController.dispose();
    _sourceController.dispose();
    super.dispose();
  }

  Future<void> _pickMusic() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      setState(() {
        _musicFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadMusic() async {
    if (_musicFile == null) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('music/${DateTime.now()}-${_musicFile!.path}');

      final UploadTask uploadTask = storageRef.putFile(_musicFile!);

      final TaskSnapshot downloadUrl = await uploadTask;
      final String url = await downloadUrl.ref.getDownloadURL();
      _url = url;

      setState(() {
        _isUploading = false;
        _sourceController.text = url;
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> _storeMusic() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String ref = (await FirebaseFirestore.instance.collection('users').get())
        .docs
        .where((element) =>
            element['uid'] == FirebaseAuth.instance.currentUser!.uid)
        .first
        .id;

    if (_uploadFromDevice) {
      firestore
          .collection('users')
          .doc(ref)
          .collection('child-music')
          .add({'name': _nameController.text,'name-ar':_nameArController.text, 'source': _url});
    } else {
      String name = _nameController.text;
      String source = _sourceController.text;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(ref)
          .collection('child-music')
          .add({'name': name, 'source': source,'name-ar':_nameArController.text});
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await _storeMusic().then((value){
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_music').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameArController,
                decoration: InputDecoration(
                  labelText: 'title_in_arabic'.tr(),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'enter_music_name'.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'title_in_english'.tr(),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'enter_music_name'.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Checkbox(
                    value: _uploadFromDevice,
                    onChanged: (bool? value) {
                      setState(() {
                        _uploadFromDevice = value!;
                      });
                    },
                  ),
                  Text('upload_music_from_device').tr(),
                ],
              ),
              SizedBox(height: 16.0),
              _uploadFromDevice
                  ? SizedBox(
                height: 100,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _pickMusic,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeHelper.blueAlter
                            ),
                            child: Text('choose_music_file',style: ThemeHelper.headingText(context)?.copyWith(
                              fontSize: 20
                            ),).tr(),
                          ),
                          _isUploading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _uploadMusic,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeHelper.blueAlter
                            ),
                                  child: Text('upload_music_file',style: ThemeHelper.headingText(context)?.copyWith(
                                    fontSize: 20
                                  ),).tr(),
                                ),
                        ],
                      ),
                  )
                  : TextFormField(
                      controller: _sourceController,
                      decoration: InputDecoration(
                        labelText: 'source'.tr(),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'enter_music_source'.tr();
                        }
                        return null;
                      },
                    ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ThemeHelper.fullSizePrimaryButtonStyle(context).copyWith(
                  minimumSize: MaterialStatePropertyAll<Size>(Size(double.infinity,50))
                ),
                child: Text('submit',style: ThemeHelper.headingText(context)?.copyWith(
                  fontSize: 26
                ),).tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
