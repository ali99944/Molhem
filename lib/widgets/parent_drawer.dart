import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/data/models/user_information.dart';
import 'package:Molhem/screens/edit_profile_screen.dart';
import 'package:Molhem/screens/faq.dart';
import 'package:Molhem/screens/parent_home_screen.dart';
import 'package:Molhem/screens/parent_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:provider/provider.dart';

import '../core/helpers/theme_helper.dart';
import '../core/utils/UpperFirstLetter.dart';
import '../screens/about_screen.dart';
import '../screens/profile.dart';
import '../screens/terms_screen.dart';

class ParentDrawer extends StatelessWidget {
  const ParentDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserInformation userInformation = context.read<AuthStatusBloc>().userInformation!;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: Color(0xff7ea5ad)
            ),
            accountName: Text(upperFirstLetter(userInformation.username),style: ThemeHelper.headingText(context)?.copyWith(
              fontSize: 30
            ),),
            accountEmail: Text(userInformation.email,style: ThemeHelper.headingText(context)?.copyWith(
                fontSize: 24
            )),
            currentAccountPicture: FluttermojiCircleAvatar(
              backgroundColor: Colors.blueGrey,
              // radius: 100,
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView(
              children: [
                ListTile(
                  style: ListTileStyle.drawer,
                  selected: true,
                  selectedColor: ThemeHelper.blueAlter,
                  onTap: () async{
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ParentHomeScreen())
                    );
                  },
                  leading: Icon(Icons.home,size: 30,),
                  title: Text('home',style: TextStyle(fontSize: 20),).tr(),
                ),
                ListTile(
                  style: ListTileStyle.drawer,
                  selected: true,
                  selectedColor: ThemeHelper.blueAlter,
                  onTap: () async{
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => profile())
                    );
                  },
                  leading: Icon(Icons.person,size: 30,),
                  title: Text('profile',style: TextStyle(fontSize: 20)).tr(),
                ),
                ListTile(
                  style: ListTileStyle.drawer,
                  selected: true,
                  selectedColor: ThemeHelper.blueAlter,
                  onTap: () async{
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EditProfileScreen())
                    );
                  },
                  leading: Icon(Icons.edit,size: 30,),
                  title: Text('edit_profile',style: TextStyle(fontSize: 20)).tr(),
                ),
                ListTile(
                  style: ListTileStyle.drawer,
                  selected: true,
                  selectedColor: ThemeHelper.blueAlter,
                  onTap: () async{
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AboutScreen())
                    );
                  },
                  leading: Icon(Icons.info,size: 30,),
                  title: Text('about',style: TextStyle(fontSize: 20)).tr(),
                ),
                ListTile(
                  style: ListTileStyle.drawer,
                  selected: true,
                  selectedColor: ThemeHelper.blueAlter,
                  onTap: () async{
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TermsScreen())
                    );
                  },
                  leading: Icon(Icons.copyright,size: 30,),
                  title: Text('terms_condition',style: TextStyle(fontSize: 20)).tr(),
                ),
                ListTile(
                  style: ListTileStyle.drawer,
                  selected: true,
                  selectedColor: ThemeHelper.blueAlter,
                  onTap: () async{
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => FaqScreen())
                    );
                  },
                  leading: Icon(Icons.question_answer,size: 30,),
                  title: Text('faq',style: TextStyle(fontSize: 20)).tr(),
                ),
                Divider(thickness: 2,),
                ListTile(
                  style: ListTileStyle.drawer,
                  selected: true,
                  selectedColor: Colors.red,
                  onTap: () async{
                    await FirebaseAuth.instance.signOut();
                  },
                  leading: Icon(Icons.logout,size: 30,),
                  title: Text('logout_message',style: TextStyle(fontSize: 20)).tr(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
