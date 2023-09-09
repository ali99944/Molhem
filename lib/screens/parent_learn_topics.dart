import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/screens/add_topic_screen.dart';
import 'package:Molhem/screens/parent_learn_list_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/learn_bloc/learn_bloc.dart';
import '../data/models/learn_category.dart';

class ParentLearningTopics extends StatelessWidget {
  const ParentLearningTopics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('learning_topics').tr(),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore
              .instance
              .collection('users')
              .doc(context.read<AuthStatusBloc>().id)
              .collection('child-learning')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.hasError){
              return Center(
                child: Text('something went wrong',style: TextStyle(fontSize: 30),),
              );
            }

            if(!snapshot.hasData){
              return Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Text('loading topics')
                    ],
                  )
              );
            }
            QuerySnapshot data = snapshot.data!;
            List<QueryDocumentSnapshot> docs = data.docs;
            List<LearnCategory> categories = docs.map((doc) => LearnCategory.fromSnapshot(doc)).toList();

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => AddTopicScreen())
                            );
                          },
                          child: Text('add_topic',style: TextStyle(
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
                        itemCount: categories.length,
                        itemBuilder: (context,index){
                          LearnCategory category = categories[index];
                          QueryDocumentSnapshot topic = docs[index];

                          return Stack(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => ParentLearnListScreen(categoryId: topic.id))
                                  );
                                },
                                child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xff7ea5ad),
                                        borderRadius: BorderRadius.circular(18.0)
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: category.iconImage,
                                      errorWidget: (context,url,error){
                                        print(url);
                                        print(error);

                                        return Center(
                                          child: Text('broken image'),
                                        );
                                      },
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
                ),
              ),
            );
          },
        ),
      );
  }
}
