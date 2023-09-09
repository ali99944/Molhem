import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/widgets/parent_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart' show BuildContextEasyLocalizationExtension, StringTranslateExtension, TextTranslateExtension, tr;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import '../blocs/auth_status_bloc/auth_status_bloc.dart';
import '../data/models/child_history.dart';

class ChildHistoryScreen extends StatefulWidget {
  @override
  State<ChildHistoryScreen> createState() => _ChildHistoryScreenState();
}

class _ChildHistoryScreenState extends State<ChildHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    String id = context.read<AuthStatusBloc>().id!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .collection('child-history')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
          List<QueryDocumentSnapshot> histories = data.docs;

          if(histories.isEmpty){
            return Container(
              alignment: Alignment.center,
              child: AutoSizeText('no_activities'.tr(),style: ThemeHelper.headingText(context)?.copyWith(
                fontSize: 30
              ),),
            );
          }

          return ListView.builder(
            itemCount: histories.length,
            itemBuilder: (context, index) {
              ChildHistory history =
                  ChildHistory.fromFirestore(histories[index]);
              DateFormat dateFormat = DateFormat('yyyy-MM-dd');
              String formmated = dateFormat.format(
                  DateTime.fromMillisecondsSinceEpoch(history.timestamp));
              return Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: Slidable(
                  // Specify a key if the Slidable is dismissible.
                  key: const ValueKey(0),

                  // The start action pane is the one at the left or the top side.

                  // The end action pane is the one at the right or the bottom side.
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (x) async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(context.read<AuthStatusBloc>().id)
                              .collection('child-history')
                              .doc(histories[index].id)
                              .delete();
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'delete'.tr(),
                      ),
                    ],
                  ),

                  // The child of the Slidable is what the user sees when the
                  // component is not dragged.
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                      height: 100,
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color:
                            ThemeHelper.getHistoryActionColor(history.degree),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder(
                            future: GoogleTranslator().translate(history.action,to:context.locale.languageCode), builder: (BuildContext context, AsyncSnapshot<Translation> snapshot) {
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if(snapshot.data != null){
                                return Text(
                                  snapshot.data!.text,
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                );
                              }else{
                                return Text('swr').tr();
                              }
                            },
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              formmated,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
