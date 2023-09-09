import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/screens/videos_list.dart';
import 'package:Molhem/widgets/video_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/helpers/theme_helper.dart';


class VideosCategories extends StatelessWidget {
  const VideosCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          height: 120,
          padding: EdgeInsets.all(8.0),
          color: Color(0xffaa6a6a),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Container(
                  height: 40,
                  child: Text('video_categories',style: TextStyle(fontSize: 28),).tr()),
              Expanded(child: AutoSizeText('future_videos'.tr(),style: ThemeHelper.headingText(context)?.copyWith(fontSize: 24,fontWeight: FontWeight.normal),maxLines: 1,)),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(color: Color(0xffaa6a6a),),
          Container(
            padding: EdgeInsets.all(12.0),
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(context.read<AuthStatusBloc>().id)
                        .collection('child-videos')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: AutoSizeText('swr'.tr(),style: TextStyle(
                            fontSize: 32
                          ),maxLines: 1,),
                        );
                      }

                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      QuerySnapshot data = snapshot.data!;
                      List<QueryDocumentSnapshot> videos = data.docs;

                      if(videos.isEmpty){
                        return Container(
                          alignment: Alignment.center,
                          height: 580,
                          child: AutoSizeText('no_items'.tr(),style: ThemeHelper.headingText(context)?.copyWith(
                              fontSize: 28
                          ),),
                        );
                      }


                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot video = videos[index];

                          return VideoCategory(
                            name: context.locale.languageCode == 'en' ? video['category'] : video['category-ar'],
                            categoryId: video.id,image:video['image']
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
