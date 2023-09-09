import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/screens/edit_profile_screen.dart';
import 'package:Molhem/screens/language_settings.dart';
import 'package:Molhem/screens/profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ParentScreen extends StatelessWidget {
  const ParentScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Container(
        padding: const EdgeInsets.all(8.0),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 25,),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)
                ),
                leading: Icon(Icons.person),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfileScreen())
                  );
                },
                title: Text('edit_profile',style: TextStyle(
                    fontSize: 28
                ),).tr(),
                trailing: Icon(Icons.chevron_right,size: 40,),
                tileColor: Color(0xff7ea5ad),
                textColor: Colors.white,
                iconColor: Colors.white,
              ),
              SizedBox(height: 8.0,),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)
                ),
                leading: Icon(Icons.language),
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LanguageSettings())
                  );
                },
                title: Text('change_language',style: TextStyle(
                  fontSize: 28
                ),).tr(),
                trailing: Icon(Icons.chevron_right,size: 40,),
                tileColor: Color(0xff7ea5ad),
                textColor: Colors.white,
                iconColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}