import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/screens/video_screen.dart';
import 'package:Molhem/screens/youtue_video_screen.dart';
import 'package:Molhem/widgets/video_component.dart';
import 'package:Molhem/widgets/wave_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'add_new_video_source.dart';

class ParentVideosList extends StatelessWidget {
  final String categoryId;
  const ParentVideosList({Key? key,required this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddNewVideoSource(categoryId: categoryId))
                    );
                  },
                  child: Text('add_video',style: TextStyle(
                    color: ThemeHelper.blueAlter,
                    fontSize: 30
                  ),).tr()
                ),
              ),
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
                      child: Text('swr').tr(),
                    );
                  }

                  if(!snapshot.hasData){
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
                    itemBuilder: (context,index){
                      QueryDocumentSnapshot video = videos[index];
                      return Stack(
                        children: [
                          VideoComponent(name: context.locale.languageCode == 'en' ? video['name'] : video['name-ar'], videoSource: video['source'],
                            sourceType: video['sourceType'],),

                          Positioned(
                            top: 8,
                            left: 12,
                            child: GestureDetector(
                              onTap:() async{
                                String id = context.read<AuthStatusBloc>().id!;
                                FirebaseFirestore firestore = FirebaseFirestore.instance;
                                await firestore.collection('users')
                                    .doc(id)
                                    .collection('child-videos')
                                    .doc(categoryId)
                                    .collection('sources')
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
