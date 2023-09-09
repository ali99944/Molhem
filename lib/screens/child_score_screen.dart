import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/data/models/child_score.dart';
import 'package:Molhem/widgets/parent_drawer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../blocs/auth_status_bloc/auth_status_bloc.dart';

class ChildScoreScreen extends StatelessWidget {
  const ChildScoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String id = context.read<AuthStatusBloc>().id!;


    return Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(id)
              .collection('child-scores')
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

            if(data.docs.isEmpty){
              return Container(
                alignment: Alignment.center,
                child: AutoSizeText('no_tests'.tr(),style: ThemeHelper.headingText(context)?.copyWith(
                    fontSize: 30
                ),),
              );
            }

            List<ChildScore> scores = data.docs.map((doc){
              return ChildScore.fromFirestore(doc);
            }).toList();

            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: scores.length,
                    itemBuilder: (context, index) {
                      ChildScore score = scores[index];
                        DateFormat dateFormat = DateFormat('yyyy-MM-dd');
                        DateTime date = DateTime.fromMillisecondsSinceEpoch(score.timestamp);
                        String formated = dateFormat.format(date);

                      return Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.only(bottom: 8.0),
                            decoration: BoxDecoration(
                              color:Color(0xff7ea5ad),
                              borderRadius: BorderRadius.circular(8.0)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'p_test'.tr(args: [score.test]),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                  ),
                                ),
                                Text(
                                  'p_score'.tr(args: [score.score.toString()]),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                  ),
                                ),
                                Text(
                                  'p_mark'.tr(
                                    args: [score.max.toString()]
                                  ),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                  ),
                                ),
                                Text(
                                  'finish_date'.tr(args: [formated]),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                  ),
                                ),
                                Text(
                                  'percentage'.tr(args: ["${((score.score / score.max) * 100).toStringAsFixed(1)}%"]),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                  ),
                                ),
                              ],
                            ),
                          ),
                          context.locale.languageCode == 'en' ? Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap:() async{
                                String id = context.read<AuthStatusBloc>().id!;
                                FirebaseFirestore firestore = FirebaseFirestore.instance;
                                await firestore.collection('users')
                                    .doc(id)
                                    .collection('child-scores')
                                    .doc(data.docs[index].id)
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
                          ) : Positioned(
                            top: 8,
                            left: 8,
                            child: GestureDetector(
                              onTap:() async{
                                String id = context.read<AuthStatusBloc>().id!;
                                FirebaseFirestore firestore = FirebaseFirestore.instance;
                                await firestore.collection('users')
                                    .doc(id)
                                    .collection('child-scores')
                                    .doc(data.docs[index].id)
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
                  ),
                ],
              ),
            );
          },
        ));
  }
}
