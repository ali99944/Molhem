import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/screens/music_player_screen.dart';
import 'package:Molhem/widgets/wave_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/helpers/theme_helper.dart';
import '../widgets/music_component.dart';

class Music extends StatelessWidget {
  const Music({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          height: 120,
          padding: EdgeInsets.all(8.0),
          color:  Color(0xff8088a9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Container(height:40,child: Text('start_listening',style: TextStyle(fontSize: 28),).tr()),
              Expanded(
                child: Text('good_music',style: ThemeHelper.headingText(context)?.copyWith(
                  fontSize: 24
                ),).tr(),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(color: Color(0xff8088a9),),
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Container(
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(context.read<AuthStatusBloc>().id)
                          .collection('child-music')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: AutoSizeText('swr'.tr(),style: TextStyle(
                              fontSize: 32
                            ),),
                          );
                        }

                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        QuerySnapshot data = snapshot.data!;
                        List<QueryDocumentSnapshot> music = data.docs;

                        if(music.isEmpty){
                          return Container(
                            alignment: Alignment.center,
                            height: 580,
                            child: AutoSizeText('no_items'.tr(),style: ThemeHelper.headingText(context)?.copyWith(
                                fontSize: 28
                            ),),
                          );
                        }


                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: music.length,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot song = music[index];

                            return MusicComponent(
                              name: context.locale.languageCode == 'en' ? song['name'] : song['name-ar'],
                              musicSource: song['source'],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
