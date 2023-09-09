import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/data/models/user_information.dart';
import 'package:Molhem/screens/child_home_screen.dart';
import 'package:Molhem/screens/parent_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:provider/provider.dart';

import '../core/helpers/theme_helper.dart';
import '../screens/avatar.dart';
import '../screens/friend.dart';

class ChildDrawer extends StatelessWidget {
  const ChildDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: ThemeHelper.primaryColor
            ),
              accountName: Text('john doe',style: TextStyle(fontSize: 26),),
              accountEmail: Text('johndoe@gmail.com',style: TextStyle(fontSize: 22),),
            currentAccountPicture: FluttermojiCircleAvatar(),
          ),
          Expanded(
            flex: 1,
            child: ListView(
              children: [
                ListTile(
                  onTap: () async{
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChildHomeScreen())
                    );
                  },
                  leading: Icon(Icons.home,size: 40),
                  title: Text('home',style: TextStyle(fontSize: 28),).tr(),
                ),
                ListTile(
                  onTap: () async{
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Friend())
                    );
                  },
                  leading: Icon(Icons.chat,size: 40,),
                  title: Text('friend',style: TextStyle(fontSize: 28),).tr(),
                ),
                ListTile(
                  onTap: () async{
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => avatar())
                    );
                  },
                  leading: Icon(Icons.account_circle,size: 40),
                  title: AutoSizeText('edit_avatar'.tr(),style: TextStyle(fontSize: 28),maxLines: 1,),
                ),
                ListTile(
                  onTap: () async{
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ParentScreen())
                    );
                  },
                  leading: Icon(Icons.settings,size: 40),
                  title: Text('settings',style: TextStyle(fontSize: 28),).tr(),
                ),
                Divider(),
                ListTile(
                  selected: true,
                  selectedColor: Colors.red,
                  onTap: () async{
                    await FirebaseAuth.instance.signOut();
                  },
                  leading: Icon(Icons.logout,size: 40,),
                  title: Text('logout_message',style: TextStyle(fontSize: 28),).tr(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
