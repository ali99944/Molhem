import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/blocs/learn_bloc/learn_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/data/models/learn_category.dart';
import 'package:Molhem/screens/learn_category_details_page.dart';
import 'package:Molhem/widgets/encouragment_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/utils/UpperFirstLetter.dart';
import '../core/utils/show_feedback_motivation.dart';
import '../core/utils/store_history.dart';
import '../widgets/child_drawer.dart';

class LearningTopics extends StatefulWidget {
  @override
  _LearningTopicsState createState() => _LearningTopicsState();
}

class _LearningTopicsState extends State<LearningTopics> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _showNotification(context));
    return BlocProvider(
      create: (context) => LearnBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(190),
          child: Container(
            color: Color(0xfff1ecdd),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:12.0),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('go_back',style: TextStyle(
                      fontSize: 24,
                    color: ThemeHelper.blueAlter
                  ),).tr(),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  height: 100,
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(context.read<AuthStatusBloc>().id)
                        .collection('child-learning')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'swr',
                            style: TextStyle(fontSize: 30),
                          ).tr(),
                        );
                      }

                      if (!snapshot.hasData) {
                        return Center(
                            child: CircularProgressIndicator(),
                        );
                      }
                      QuerySnapshot data = snapshot.data!;
                      List<QueryDocumentSnapshot> docs = data.docs;


                      if(docs.isEmpty){
                        return Container(
                          alignment: Alignment.center,
                          height: 580,
                          child: AutoSizeText('no_learn_topics'.tr(),style: ThemeHelper.headingText(context)?.copyWith(
                              fontSize: 28
                          ),),
                        );
                      }


                      List<LearnCategory> categories = docs
                          .map((doc) => LearnCategory.fromSnapshot(doc))
                          .toList();



                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          LearnCategory category = categories[index];
                          QueryDocumentSnapshot topic = docs[index];

                          return GestureDetector(
                            onTap: () {
                              context.read<LearnBloc>().add(LoadTopicItems(
                                  topicId: topic.id,
                                  userId:
                                      context.read<AuthStatusBloc>().id!));
                            },
                            child: Container(
                              width: 100,
                                height: 100,
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(24.0)),
                                child: Image(
                                  image: CachedNetworkImageProvider(
                                    category.iconImage,
                                  ),
                                )),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 30.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0)),
              color: Colors.white),
          child:
              BlocBuilder<LearnBloc, LearnState>(builder: (context, state) {
            if (state is LearnInitial) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)
                  )
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(8.0),
                child: AutoSizeText(
                  'select_learn_notification'.tr(args: [upperFirstLetter(context.read<AuthStatusBloc>().userInformation!.username)]),
                  style: ThemeHelper.headingText(context)?.copyWith(
                    fontSize: 30
                  ),
                  maxLines: 1,
                ),

              );
            }
            else if (state is TopicItemsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopicItemsLoadFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      'swr'.tr(),
                      style: TextStyle(
                        fontSize: 32
                      ),
                      maxLines: 1,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: ThemeHelper.secondaryColor),
                      onPressed: () {
                        context.read<LearnBloc>().add(LoadTopicItems(
                            topicId: state.topicId,
                            userId: context.read<AuthStatusBloc>().id!));
                      },
                      child: AutoSizeText('try_again'.tr(),style: TextStyle(
                        fontSize: 32,
                        color: ThemeHelper.blueAlter
                      ),maxLines:1),
                    )
                  ],
                ),
              );
            } else if (state is TopicsAreEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sentiment_dissatisfied,
                      size: 100.0,
                      color: Colors.grey[500],
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'no_items',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                      ),
                    ).tr(),
                    SizedBox(height: 8.0),
                    Text(
                      'future_add',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ).tr(),
                  ],
                ),
              );
            }
            else if (state is TopicItemsLoadSuccess) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 5 / 4),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async{
                        await storeHistory(
                          context: context,
                          degree: 'good',
                          action: 'learned about ${state.items[index].name}'
                        ).then((_){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LearnCategoryDetailsScreen(
                                  categoryInformation: state.items[index])));
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 4.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            color: Color(0xfff1ecdd),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  offset: Offset(-2, 2),
                                  color: Colors.grey)
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Hero(
                                tag: state.items[index].iconImage,
                                child: CachedNetworkImage(
                                  imageUrl: state.items[index].iconImage,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              flex: 1,
                              child: AutoSizeText(
                                context.locale.languageCode == 'en' ? state.items[index].name : state.items[index].nameAr,
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Color(0xffa7914e),
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return Center(
              child: Text('not implemented yet'),
            );
          }),
        ),
      ),
    );
  }

  void _showNotification(BuildContext context) async{
    // await showDialog(
    //     context: context,
    //     builder: (context){
    //       return EncouragementDialog(
    //           message: 'select_learn_notification'.tr(args: [upperFirstLetter(context.read<AuthStatusBloc>().userInformation!.username)]),
    //           icon: Icons.info,
    //           onClose: (){
    //             Navigator.pop(context);
    //           }
    //       );
    //     }
    // );

    await showFeedbackMotivation(
        context: context,
      message: 'learn_today'.tr(args: [upperFirstLetter(context.read<AuthStatusBloc>().userInformation!.username)]),
      imageAssetPath: 'assets/Helper2.png'
    );
  }
}
