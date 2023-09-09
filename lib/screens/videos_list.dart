import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/screens/video_screen.dart';
import 'package:Molhem/screens/youtue_video_screen.dart';
import 'package:Molhem/widgets/video_component.dart';
import 'package:Molhem/widgets/wave_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/helpers/theme_helper.dart';

class VideosList extends StatelessWidget {
  final String categoryId;
  const VideosList({Key? key,required this.categoryId}) : super(key: key);

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
              Container(height:40,child: Text('pick_video',style: TextStyle(fontSize: 28),).tr()),
              Expanded(child: AutoSizeText('future_new_videos'.tr(),style: ThemeHelper.headingText(context)?.copyWith(fontSize: 24),maxLines: 1,)),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(color: Color(0xffaa6a6a),),
          Container(
            padding: const EdgeInsets.all(12.0),
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
                    stream: FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(context.read<AuthStatusBloc>().id)
                        .collection('child-videos')
                        .doc(categoryId)
                        .collection('sources')
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if(snapshot.hasError){
                        return Center(
                          child: AutoSizeText('something went wrong',style: TextStyle(
                            fontSize: 32
                          ),),
                        );
                      }

                      if(!snapshot.hasData){
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
                        itemBuilder: (context,index){
                          QueryDocumentSnapshot video = videos[index];
                          return VideoComponent(name: context.locale.languageCode == 'en' ? video['name'] : video['name-ar'], videoSource: video['source'],
                              sourceType: video['sourceType'],);
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
