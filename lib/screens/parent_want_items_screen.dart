import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/core/utils/UpperFirstLetter.dart';
import 'package:Molhem/data/models/want_component.dart';
import 'package:Molhem/screens/add_want_screen.dart';
import 'package:Molhem/widgets/parent_drawer.dart';
import 'package:Molhem/widgets/wave_background.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../widgets/want_component_holder.dart';
import 'child_audio_session.dart';

class ParentWantItemsScreen extends StatelessWidget {
  const ParentWantItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ParentDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddWantScreen())
                    );
                  },
                  child: Text('add_want',style: TextStyle(
                      fontSize: 26,
                      color: ThemeHelper.blueAlter
                  ),).tr(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').doc(context.read<AuthStatusBloc>().id).collection('child-want').snapshots(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if(snapshot.hasError){
                    return Center(
                      child: Text('something went wrong'),
                    );
                  }

                  if(!snapshot.hasData){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  QuerySnapshot data = snapshot.data!;
                  List<QueryDocumentSnapshot> docs = data.docs;
                  List<WantComponent> wantComponents = docs.map((doc) => WantComponent.fromFirestore(doc,context)).toList();

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing:12.0
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: wantComponents.length,
                    itemBuilder: (context,index){
                      WantComponent component = wantComponents[index];
                      return Stack(
                        children: [
                          Container(
                            width:double.infinity,
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Color(0xff7ea5ad),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    offset: Offset(-2,2),
                                    color: Colors.grey,
                                  ),
                                ]
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image(image: CachedNetworkImageProvider(component.image),height: 100,width: 100,),
                                SizedBox(height: 8.0,),
                                AutoSizeText(upperFirstLetter(context.locale.languageCode == 'en' ? component.name : component.nameAr),style: ThemeHelper.headingText(context)?.copyWith(fontSize: 26,),maxLines: 1,)
                              ],
                            ),
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
                                    .collection('child-want')
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
                  );
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
