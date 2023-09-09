import 'dart:io';

import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/core/utils/show_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension, TextTranslateExtension, tr;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddNewStoryScreen extends StatefulWidget {
  @override
  _AddNewStoryScreenState createState() => _AddNewStoryScreenState();
}

class _AddNewStoryScreenState extends State<AddNewStoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleArController = TextEditingController();
  final TextEditingController _contentArController = TextEditingController();
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().getImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void dispose() {
    _authorController.dispose();
    _titleController.dispose();
    _titleArController.dispose();
    _contentController.dispose();
    _contentArController.dispose();


    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_new_story').tr(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImagePreview(),
                SizedBox(height: 20),
                _buildImageButtonRow(),
                _buildTextField(
                  controller: _authorController,
                  hintText: 'author_name'.tr(),
                  label: '',
                ),
                _buildTextField(
                  controller: _titleArController,
                  hintText: 'عنوان القصة'.tr(),
                  label: '',
                ),
                _buildTextField(
                  controller: _contentArController,
                  hintText: 'محتزي القصة'.tr(),
                  maxLines: 10,
                  label: '',
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: _buildTextField(
                    controller: _titleController,
                    hintText: 'Story Title',
                    label: '',
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: _buildTextField(
                    controller: _contentController,
                    hintText: 'Story Content',
                    maxLines: 10,
                    label: '',
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      if (_image != null) {
                        final Reference storageRef =
                        FirebaseStorage.instance.ref().child('stories/${DateTime.now()}.jpg');

                        final UploadTask uploadTask = storageRef.putFile(_image!);

                        final TaskSnapshot downloadUrl = (await uploadTask);
                        final String url = await downloadUrl.ref.getDownloadURL();

                        Map<String,dynamic> story = {
                          'title': _titleController.text,
                          'content': _contentController.text,
                          'title-ar':_titleArController.text,
                          'content-ar':_contentArController.text,
                          'author': _authorController.text,
                          'image': url
                        };

                        await FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(context.read<AuthStatusBloc>().id)
                            .collection('child-stories')
                            .add(story);

                        Navigator.pop(context);
                      }else{
                        showMessage(context: context, message: 'upload_image'.tr());
                      }
                    }else{
                      showMessage(context: context, message: 'complete_form'.tr());
                    }
                  },
                  style: ThemeHelper.fullSizePrimaryButtonStyle(context).copyWith(
                    minimumSize: MaterialStatePropertyAll(Size(double.infinity,50))
                  ),
                  child: Text('add',style: TextStyle(
                    fontSize: 28
                  ),).tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: _image != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          _image!,
          fit: BoxFit.cover,
        ),
      )
          : Center(
        child: Text(
          'no_image_selected',
          style: ThemeHelper.headingText(context)?.copyWith(
            fontSize: 30,
          ),
        ).tr(),
      ),
    );
  }

  Widget _buildImageButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => _pickImage(ImageSource.gallery),
          icon: Icon(Icons.photo_library),
          label: Text('gallery',style: TextStyle(
            fontSize: 24
          ),).tr(),
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeHelper.blueAlter,
            padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0)
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _pickImage(ImageSource.camera),
          icon: Icon(Icons.camera_alt),
          style: ElevatedButton.styleFrom(
              backgroundColor: ThemeHelper.blueAlter,
              padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0)
          ),
          label: Text('camera',style: TextStyle(
            fontSize: 24
          ),).tr(),
        ),
      ],
    );
  }


  Widget _buildTextField({
    required String label,
    required String hintText,
    int? maxLines,

    TextEditingController? controller,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          maxLines: maxLines ?? 1,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

}