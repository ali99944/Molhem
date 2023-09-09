import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../data/models/feeling.dart';
import '../widgets/child_main_component.dart';
import '../widgets/child_main_component_with_image.dart';
import '../widgets/wave_background.dart';
import 'add_feeling_list.dart';
import 'child_audio_session.dart';

class ParentFeelingsList extends StatelessWidget {
  const ParentFeelingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddFeelingScreen())
                    );
                  },
                  child: Text('add_feeling',style: TextStyle(
                    fontSize: 26,
                    color: ThemeHelper.blueAlter
                  ),).tr(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: StreamBuilder(
                  stream: FirebaseFirestore
                      .instance
                      .collection('users')
                      .doc(context.read<AuthStatusBloc>().id)
                      .collection('child-feelings')
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if(snapshot.hasData && !snapshot.hasError){
                      QuerySnapshot data = snapshot.data!;
                      List<QueryDocumentSnapshot> feelings = data.docs;

                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                        ),

                        itemCount: feelings.length,
                        itemBuilder: (context,index){
                          Feeling feeling = Feeling.fromSnapshot(feelings[index],context);
                          return Stack(
                            children: [
                              ChildMainComponentWithImage(
                                name: feeling.content,
                                color: Colors.orange,
                                iconUrl: feeling.image,
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
                                        .collection('child-feelings')
                                        .doc(feelings[index].id)
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
                    }else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



