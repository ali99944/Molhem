import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/data/models/story.dart';
import 'package:Molhem/screens/add_new_story_screen.dart';
import 'package:Molhem/screens/story_details.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/helpers/theme_helper.dart';

class ParentStoriesList extends StatelessWidget {
  const ParentStoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.autismColor,
      appBar: AppBar(
        title: Text('choose_story').tr(),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddNewStoryScreen()));
                  },
                  child: Text('add_story',style: TextStyle(
                    fontSize: 30,
                    color: ThemeHelper.blueAlter
                  ),).tr(),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(context.read<AuthStatusBloc>().id)
                    .collection('child-stories')
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
                  List<QueryDocumentSnapshot> stories = data.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot storyDocument = stories[index];
                      Story story = Story.fromFirestore(storyDocument);
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: ()async{
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => StoryDetails(story: story))
                              );
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
                          ),

                      Positioned(
                            top: 12,
                            left: 12,
                            child: GestureDetector(
                              onTap:() async{
                                String id = context.read<AuthStatusBloc>().id!;
                                FirebaseFirestore firestore = FirebaseFirestore.instance;
                                await firestore.collection('users')
                                    .doc(id)
                                    .collection('child-stories')
                                    .doc(storyDocument.id)
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
