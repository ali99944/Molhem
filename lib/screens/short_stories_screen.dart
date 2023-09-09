import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_status_bloc/auth_status_bloc.dart';
import '../core/helpers/theme_helper.dart';
import 'add_short_story_screen.dart';
import 'short_stories_details_screen.dart';

class ShortStoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          height: 120,
          padding: EdgeInsets.all(8.0),
          color:  Color(0xff7ea5ad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Container(height:40,child: Text('pick_story',style: TextStyle(fontSize: 28),).tr()),
              Expanded(child: AutoSizeText('pick_story_desc'.tr(),style: ThemeHelper.headingText(context)?.copyWith(fontSize: 24),maxLines: 1,)),
            ],
          ),
        ),
      ),

      body: Stack(
        children: [
          Container(color: Color(0xff7ea5ad),),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(context.read<AuthStatusBloc>().id)
                        .collection('child-short-stories')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final stories = snapshot.data!.docs;

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
                        itemBuilder: (context, index) {
                          final story = stories[index].data() as Map<String, dynamic>;
                          final title = context.locale.languageCode == 'en' ? story['title'] : story['title-ar'];
                          final image = story['mainImage'];
                          final List<dynamic> imagePaths = story['imagePaths'];

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => ShortStoryDetailsScreen(title: title,mainImage:image, imagePaths: imagePaths,))
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Color(0xffeaf7fa),
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5,
                                    offset: Offset(3, 3),
                                  ),
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5,
                                    offset: Offset(-3, 0),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Image.network(
                                    image,
                                    fit: BoxFit.cover,
                                    height: 200,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: AutoSizeText(
                                      title,
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff7ea5ad)
                                      ),
                                      maxLines: 1,
                                    ),
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
        ],
      ),
    );
  }
}