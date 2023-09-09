import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/screens/add_music_screen.dart';
import 'package:Molhem/screens/music_player_screen.dart';
import 'package:Molhem/widgets/wave_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../core/helpers/theme_helper.dart';
import '../widgets/music_component.dart';
import '../widgets/paernt_music_component.dart';

class ParentMusicList extends StatelessWidget {
  const ParentMusicList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
        EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddMusicScreen())
                    );
                  },
                  child: Text('add_music',style: TextStyle(
                      fontSize: 26,
                      color: ThemeHelper.blueAlter
                  ),).tr(),
                ),
              ),
              SizedBox(height: 20,),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(context.read<AuthStatusBloc>().id)
                    .collection('child-music')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                    snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('swr').tr(
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  QuerySnapshot data = snapshot.data!;
                  List<QueryDocumentSnapshot> music = data.docs;

                  return GridView.builder(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: music.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot song = music[index];

                      return Stack(
                        children: [
                          Container(
                            width:double.infinity,
                            height:double.infinity,
                              child: ParentMusicComponent(name: context.locale.languageCode == 'en' ? song['name'] : song['name-ar'], musicSource: song['source'])),
                          Positioned(
                            bottom: 16,
                            left: 12,
                            child: GestureDetector(
                              onTap:() async{
                                String id = context.read<AuthStatusBloc>().id!;
                                FirebaseFirestore firestore = FirebaseFirestore.instance;
                                await firestore.collection('users')
                                    .doc(id)
                                    .collection('child-music')
                                    .doc(song.id)
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
