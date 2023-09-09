import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Molhem/screens/child_home_screen.dart';
import 'package:Molhem/screens/profile.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'dart:math';
import 'package:Molhem/screens/parent_settings.dart';
import 'avatar.dart';
import 'avatar_screen.dart';

class AvatarScreen extends StatefulWidget {
  AvatarScreen({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AvatarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCED0CC),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 25,
            ),
            FluttermojiCircleAvatar(
              backgroundColor: ThemeHelper.blueAlter,
              radius: 120,
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "lets_go",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
                textAlign: TextAlign.center,
              ).tr(),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.home,size: 40,),
              label: const Text(
                "return_home",
                style: TextStyle(
                  fontSize: 30
                ),
              ).tr(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff7ea5ad),
                  minimumSize: Size(double.infinity - 40,40),
                  padding: EdgeInsets.all(8.0)
              ),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChildHomeScreen())),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit,size: 40,),
              label: const Text(
                "edit",
                style: TextStyle(
                  fontSize: 30
                ),
              ).tr(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff7ea5ad),
                minimumSize: Size(double.infinity - 40,40),
                padding: EdgeInsets.all(8.0)
              ),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewPage())),
            ),
            // Row(
            //   children: [
            //     const Spacer(flex: 2),
            //     Expanded(
            //       flex: 3,
            //       child: Container(
            //         color: const Color(0xFF9BB491),
            //         height: 35,
            //         child: ElevatedButton.icon(
            //           icon: const Icon(Icons.edit),
            //           label: const Text("Edit"),
            //           style: ElevatedButton.styleFrom(
            //             foregroundColor: Colors.black,
            //             backgroundColor: Color(0xFF9BB491), //elevation of button
            //             shape: RoundedRectangleBorder(
            //                 //to set border radius to button
            //                 borderRadius: BorderRadius.circular(40)),
            //             //content padding inside button
            //           ),
            //           onPressed: () => Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => const NewPage())),
            //         ),
            //       ),
            //     ),
            //     const Spacer(flex: 2),
            //   ],
            // ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
