import 'dart:io';

import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

enum VideoSourceType { youtube, internet }

class AddNewVideoSource extends StatefulWidget {
  final String categoryId;
  const AddNewVideoSource({super.key,required this.categoryId});

  @override
  _AddNewVideoSourceState createState() => _AddNewVideoSourceState();
}

class _AddNewVideoSourceState extends State<AddNewVideoSource> {
  final _nameController = TextEditingController();
  final _sourceController = TextEditingController();
  String _selectedSourceType = 'youtube';
  bool _isLoadingFromDevice = false;
  File? _videoFile;
  String? _downloadURL;
  bool _isUploading = false;

  Future<void> _uploadFile() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final fileName = basename(_videoFile!.path);
      final firebaseStorageRef =
      FirebaseStorage.instance.ref().child('videos/$fileName');
      final uploadTask = firebaseStorageRef.putFile(_videoFile!);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadURL = await snapshot.ref.getDownloadURL();
      setState(() {
        _downloadURL = downloadURL;
      });
    } catch (error) {
      print('Error uploading file: $error');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('add_new_video').tr(),
          centerTitle: true,
        ),
        body: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'name_of_video'.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedSourceType,
              items: [
                DropdownMenuItem(
                  value: 'youtube',
                  child: Text('youtube').tr(),
                ),
                DropdownMenuItem(
                  value: 'internet',
                  child: Text('internet').tr(),
                ),
              ],
              onChanged: (value) {
                print(value);
                setState(() {
                  _selectedSourceType = value!;
                  _isLoadingFromDevice = value == VideoSourceType.internet;
                });
                print(value);
              },
              decoration: InputDecoration(
                labelText: 'source_type'.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            _selectedSourceType == 'youtube'
                ? TextField(
              controller: _sourceController,
              decoration: InputDecoration(
                labelText: 'youtube_video_link'.tr(),
                border: OutlineInputBorder(),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final pickedFile = await ImagePicker().getVideo(
                      source: ImageSource.gallery,
                    );
                    setState(() {
                      _videoFile = File(pickedFile!.path);
                    });
                  },
                  style: ThemeHelper.fullSizePrimaryButtonStyle(context).copyWith(
                    minimumSize: MaterialStatePropertyAll(Size(double.infinity,60))
                  ),
                  child: Text('select_video_file',style: ThemeHelper.headingText(context)?.copyWith(
                    fontSize: 28
                  ),),
                ),
                SizedBox(width: 16.0),
                if (_isUploading)
                  CircularProgressIndicator()
                else if (_videoFile != null)
                  ElevatedButton(
                    onPressed: () async {
                      await _uploadFile();
                    },
                    child: Text('upload_video').tr(),
                  ),
              ],
            ),
            if (_downloadURL != null) SizedBox(height: 16.0),
    if (_downloadURL != null)
    Text(
    'download_url'.tr(args: [_downloadURL.toString()]),
    style: TextStyle(fontWeight: FontWeight.bold),
    ),
    SizedBox(height:12.0),
                Spacer(),
                ElevatedButton(
                  onPressed: () async{
                    Map<String,dynamic> video = {
                      'name': _nameController.text,
                      'source': _isLoadingFromDevice ? _downloadURL : _sourceController.text,
                      'sourceType': _selectedSourceType == VideoSourceType.youtube ? 'youtube' : 'internet'
                    };

                    await FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(context.read<AuthStatusBloc>().id)
                        .collection('child-videos')
                        .doc(widget.categoryId)
                        .collection('sources')
                        .add(video).then(
                        (_) => Navigator.pop(context)
                    );
                  },
                  style: ThemeHelper.fullSizePrimaryButtonStyle(context)?.copyWith(
                    minimumSize: MaterialStatePropertyAll(Size(double.infinity,60))
                  ),
                  child: Text('submit').tr(),
                ),
              ],
            ),
        ),
    );
  }
}