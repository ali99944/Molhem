import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/data/models/want_component.dart';
import 'package:Molhem/widgets/wave_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/utils/UpperFirstLetter.dart';
import '../core/utils/store_history.dart';
import '../widgets/want_component_holder.dart';
import 'child_audio_session.dart';

class WantItemsScreen extends StatefulWidget {
  const WantItemsScreen({super.key});

  @override
  State<WantItemsScreen> createState() => _WantItemsScreenState();
}

class _WantItemsScreenState extends State<WantItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                child: Text('want_list',style: TextStyle(
                  fontSize: 30
                ),).tr(),
              ),
              Expanded(
                child: Text('want_message',style: ThemeHelper.headingText(context)?.copyWith(
                  fontSize: 24
                ),).tr(),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(color: Color(0xff7ea5ad),),
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
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(context.read<AuthStatusBloc>().id)
                        .collection('child-want')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('swr'.tr()),
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
                          child: AutoSizeText('no_items'.tr(),style: ThemeHelper.headingText(context)?.copyWith(
                            fontSize: 28
                          ),),
                        );
                      }

                      List<WantComponent> wantComponents = docs
                          .map((doc) => WantComponent.fromFirestore(doc,context))
                          .toList();

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: wantComponents.length,
                        itemBuilder: (context, index) {
                          WantComponent component = wantComponents[index];
                          return GestureDetector(
                            onTap: () async{
                              await storeHistory(
                                  action: 'i want ${component.name}',
                                  degree: component.degree,
                                context: context
                              ).then((value){
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => ChildAudioSession(text: context.locale.languageCode == 'en' ? "I Want ${component.name}" : 'أنا أريد ${component.nameAr}',image: component.image,))
                                );
                              });
                            },
                            child: WantComponentHolder(
                              name: upperFirstLetter(context.locale.languageCode == 'en' ? component.name : component.nameAr),
                              image: component.image,
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
