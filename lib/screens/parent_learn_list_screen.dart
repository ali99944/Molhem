import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/data/models/animal.dart';
import 'package:Molhem/screens/add_new_topic_item_screen.dart';
import 'package:Molhem/screens/learn_category_details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/helpers/theme_helper.dart';
import 'add_topic_screen.dart';

class ParentLearnListScreen extends StatelessWidget {
  final String categoryId;
  const ParentLearnListScreen({Key? key,required this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('topic_items').tr(),
      ),

      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore
                      .instance.collection('users')
                      .doc(context.read<AuthStatusBloc>().id)
                      .collection('child-learning')
                      .doc(categoryId)
                      .collection('items').snapshots(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if(snapshot.hasError){
                    return Center(
                      child: Text('swr',style: TextStyle(fontSize: 30),).tr(),
                    );
                  }

                  if(!snapshot.hasData){
                    return Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            Text('loading_topics').tr()
                          ],
                        )
                    );
                  }
                  QuerySnapshot data = snapshot.data!;
                  List<QueryDocumentSnapshot> docs = data.docs;

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => AddNewTopicItemScreen(topicId: categoryId))
                              );
                            },
                            child: Text('add_item',style: TextStyle(
                                fontSize: 26,
                                color: ThemeHelper.blueAlter
                            ),).tr(),
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.0,
                              mainAxisSpacing: 12.0,
                          ),
                          itemCount: docs.length,
                          itemBuilder: (context,index){

                            return Stack(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => LearnCategoryDetailsScreen(categoryInformation: CategoryInformation.fromFirestore(docs[index])))
                                    );
                                  },
                                  child: Container(
                                    height:double.infinity,
                                      width:double.infinity,
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color:Color(0xff7ea5ad),
                                          borderRadius: BorderRadius.circular(18.0)
                                      ),
                                      child: Image(
                                        image: CachedNetworkImageProvider(docs[index]['iconImage'],),
                                      )
                                  ),
                                  // child: Container(
                                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                                  //   alignment: Alignment.center,
                                  //   margin: EdgeInsets.only(top:8,left: 8,right: 8.0),
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.blueAccent,
                                  //       borderRadius: BorderRadius.circular(8.0)
                                  //   ),
                                  //   child: Text(topic['category'],style: TextStyle(fontSize: 18,color: Colors.white),),
                                  // ),
                                ),
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: GestureDetector(
                                    onTap:() async{
                                      String id = context.read<AuthStatusBloc>().id!;
                                      FirebaseFirestore firestore = FirebaseFirestore.instance;
                                      await firestore.collection('users')
                                          .doc(id)
                                          .collection('child-learning')
                                          .doc(categoryId)
                                          .collection('items')
                                          .doc(docs[index].id)
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
