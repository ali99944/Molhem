import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/screens/parent_video_category.dart';
import 'package:Molhem/screens/videos_list.dart';
import 'package:Molhem/widgets/video_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../core/helpers/theme_helper.dart';
import '../widgets/video_component.dart';
import '../widgets/wave_background.dart';
import 'add_new_video_category_screen.dart';

class ParentVideosCategories extends StatelessWidget {
  const ParentVideosCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText('choose_category'.tr(),
            style: TextStyle(fontSize: 26, color: Colors.white), maxLines: 1),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddNewVideoCategory()));
                  },
                  child: Text('add_category',style: TextStyle(
                      fontSize: 26,
                      color: ThemeHelper.blueAlter
                  ),).tr(),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(context.read<AuthStatusBloc>().id)
                    .collection('child-videos')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('swr').tr(),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  QuerySnapshot data = snapshot.data!;
                  List<QueryDocumentSnapshot> videos = data.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot video = videos[index];

                      return Stack(
                        children: [
                          ParentVideoCategory(
                          name: context.locale.languageCode == 'en' ? video['category'] : video['category-ar'],
                            categoryId: video.id,
                            image:video['image']
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: GestureDetector(
                              onTap:() async{
                                String id = context.read<AuthStatusBloc>().id!;
                                FirebaseFirestore firestore = FirebaseFirestore.instance;
                                await firestore.collection('users')
                                    .doc(id)
                                    .collection('child-videos')
                                    .doc(video.id)
                                    .delete();
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.red,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.red.withOpacity(0.7),
                                  child: Icon(Icons.cancel,color: Colors.white,),
                                ),
                              ),
                            ),
                          )

                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
