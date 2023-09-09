import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/utils/UpperFirstLetter.dart';
import '../core/utils/store_history.dart';
import '../data/models/feeling.dart';
import '../widgets/child_main_component.dart';
import '../widgets/child_main_component_with_image.dart';
import '../widgets/wave_background.dart';
import 'child_audio_session.dart';

class FeelItemsList extends StatefulWidget {
  const FeelItemsList({super.key});

  @override
  State<FeelItemsList> createState() => _FeelItemsListState();
}

class _FeelItemsListState extends State<FeelItemsList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          height: 120,
          color: Color(0xff7ea5ad),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Container(
                height: 40,
                child: Text(
                  'feelings_list',
                  style: TextStyle(
                      fontSize: 30
                  ),
                ).tr(),
              ),
              Expanded(
                child: Text(
                  'feelings_message',
                  style: ThemeHelper.headingText(context)?.copyWith(
                      fontSize: 24
                  ),
                ).tr(),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(color: Color(0xff7ea5ad)),
          Container(
            padding: const EdgeInsets.all(12.0),
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(context.read<AuthStatusBloc>().id)
                        .collection('child-feelings')
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        QuerySnapshot data = snapshot.data!;
                        List<QueryDocumentSnapshot> feelings = data.docs;

                        if(feelings.isEmpty){
                          return Container(
                            alignment: Alignment.center,
                            height: 580,
                            child: AutoSizeText('no_items'.tr(),style: ThemeHelper.headingText(context)?.copyWith(
                                fontSize: 28
                            ),),
                          );
                        }



                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: feelings.length,
                          itemBuilder: (context, index) {
                            Feeling feeling = Feeling.fromSnapshot(feelings[index],context);
                            return GestureDetector(
                              onTap: () async {
                                await _storeHistory(
                                  action: 'feeling ${feeling.content}',
                                  degree: feeling.degree,
                                );

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChildAudioSession(
                                      text: context.locale.languageCode == 'en' ? "I Feel ${feeling.content}" : "أنا ${feeling.content}",
                                      image: feeling.image,
                                    ),
                                  ),
                                );
                              },
                              child: ChildMainComponentWithImage(
                                name: upperFirstLetter(feeling.content),
                                color: Colors.orange,
                                iconUrl: feeling.image,
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
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

  Future<void> _storeHistory({
    required String action,
    required String degree
  }) async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String? id = context.read<AuthStatusBloc>().id;

    await firestore
        .collection('users')
        .doc(id)
        .collection('child-history')
        .add({
      'action': action,
      'degree': degree,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
  }
}



