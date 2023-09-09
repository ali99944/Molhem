
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/core/utils/UpperFirstLetter.dart';
import 'package:Molhem/screens/add_new_voice_command_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart' show BuildContextEasyLocalizationExtension, StringTranslateExtension, TextTranslateExtension, tr;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class VoiceCommandsList extends StatelessWidget {
  const VoiceCommandsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Container(
          padding: EdgeInsets.all(8.0),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddVoiceCommandScreen())
                    );
                  },
                  child: Text('add_new_command',style: TextStyle(
                      fontSize: 26,
                      color: ThemeHelper.blueAlter
                  ),).tr(),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(context.read<AuthStatusBloc>().id).collection('child-voice-commands').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if(snapshot.hasError){
                    return Center(
                      child: Text('swr').tr(),
                    );
                  }

                  if(!snapshot.hasData){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<QueryDocumentSnapshot> commands = snapshot.data!.docs;

                  if(commands.isEmpty){
                    return Container(
                      height: 500,
                      child: Center(
                        child: AutoSizeText('no_items'.tr(),maxLines: 1,style: ThemeHelper.headingText(context)?.copyWith(
                          fontSize: 30
                        ),),
                      ),
                    );
                  }


                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: commands.length,
                    itemBuilder: (context,index){
                      return Container(
                        width: double.infinity,
                        height: 140,
                        child: Stack(
                          children: [
                            Directionality(
                              textDirection:TextDirection.ltr,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8.0),
                                height: 140,
                                width:double.infinity,
                                padding: EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Color(0xff7ea5ad),
                                  borderRadius: BorderRadius.circular(12.0)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(upperFirstLetter(context.locale.languageCode == 'en' ? commands[index]['prompt'] : commands[index]['prompt-ar']),style: ThemeHelper.headingText(context)?.copyWith(
                                      fontSize: 28
                                    ),),
                                    Text(upperFirstLetter(context.locale.languageCode == 'en' ? commands[index]['answer'] : commands[index]['answer-ar']),style: ThemeHelper.headingText(context)?.copyWith(
                                      fontSize: 24
                                    ),),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              right:8.0,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap:() async{
                                    String id = context.read<AuthStatusBloc>().id!;
                                    FirebaseFirestore firestore = FirebaseFirestore.instance;
                                    await firestore.collection('users')
                                        .doc(id)
                                        .collection('child-voice-commands')
                                        .doc(commands[index].id)
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
                              ),
                            )

                          ],
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
