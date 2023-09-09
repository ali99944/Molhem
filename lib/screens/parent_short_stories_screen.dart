import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_status_bloc/auth_status_bloc.dart';
import 'add_short_story_screen.dart';
import 'short_stories_details_screen.dart';

class ParentShortStoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('parent_short_stories').tr(),
      ),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: context.locale.languageCode == 'en' ? Alignment.centerLeft : Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddShortStoryScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'add_short_story',
                    style: TextStyle(
                      color: ThemeHelper.blueAlter,
                      fontSize: 28
                    ),
                  ).tr(),
                ),
              ),
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

                  if (stories.isEmpty) {
                    return Center(child: Text('no_stories',style: ThemeHelper.headingText(context),).tr());
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      final story = stories[index].data() as Map<String, dynamic>;
                      final title = story['title'];
                      final image = story['mainImage'];
                      final List<dynamic> imagePaths = story['imagePaths'];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ShortStoryDetailsScreen(title: title,mainImage:image, imagePaths: imagePaths,))
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2,
                                offset: Offset(3, 3),
                              ),
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2,
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
                                Container(
                                  alignment: Alignment.center,
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  title,
                                  style: ThemeHelper.headingText(context)?.copyWith(
                                      color:Color(0xff7ea5ad),fontSize: 30
                                  ),
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
    );
  }
}