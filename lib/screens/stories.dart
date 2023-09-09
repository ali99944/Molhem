import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/data/models/story.dart';
import 'package:Molhem/screens/story_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/helpers/theme_helper.dart';
import '../core/utils/store_history.dart';


class Stories extends StatelessWidget {
  const Stories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          height: 120,
          padding: EdgeInsets.all(8.0),
          color:  ThemeHelper.blueAlter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Container(height:40,child: Text('pick_story',style: TextStyle(fontSize: 28),).tr()),
              Expanded(child: AutoSizeText('pick_story_desc'.tr(),style: ThemeHelper.headingText(context)?.copyWith(fontWeight: FontWeight.normal,fontSize: 24),maxLines: 1,)),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(color:  ThemeHelper.blueAlter,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(context.read<AuthStatusBloc>().id)
                          .collection('child-stories')
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
                        List<QueryDocumentSnapshot> stories = data.docs;

                        if(stories.isEmpty){
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
                          itemCount: stories.length,
                          itemBuilder: (context,index){
                            QueryDocumentSnapshot storyDocument = stories[index];
                            Story story = Story.fromFirestore(storyDocument);
                            return GestureDetector(
                              onTap: ()async{
                                await storeHistory(
                                  context: context,
                                  degree: 'good',
                                  action: 'viewed ${story.title} story'
                                ).then((_){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => StoryDetails(story: story))
                                  );
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 16.0,left: 8.0,right: 8.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:  Color(0xffeaf7fa),
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(-3,3),
                                      color: Colors.grey,
                                      blurRadius: 2
                                    ),
                                    BoxShadow(
                                        offset: Offset(3,0),
                                        color: Colors.grey,
                                        blurRadius: 2
                                    ),
                                  ]
                                ),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius:BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16)
                                      ),
                                      child: CachedNetworkImage(imageUrl: story.image,fit: BoxFit.cover,
                                        height: 200,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AutoSizeText(context.locale.languageCode == 'en' ? storyDocument['title'] : storyDocument['title-ar'],style: TextStyle(color:Color(0xff7ea5ad),fontSize: 30),maxLines: 1,),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
