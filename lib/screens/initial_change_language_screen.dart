// import 'package:Molhem/screens/welcome_screen.dart';
// import 'package:Molhem/screens/welcome_screen_navigator.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class LanguageSelectionScreen extends StatefulWidget {
//   @override
//   _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
// }
//
// class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
//   String? selectedLanguage;
//
//
//
//   Future<bool> checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//
//     return isLoggedIn;
//   }
//
//   void decideLanguageChoice() async{
//     bool loginStatus = await checkLoginStatus();
//
//     if(loginStatus){
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => WelcomeScreenNavigator())
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Choose Language'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Language selection options, e.g., buttons or dropdown
//             ElevatedButton(
//               onPressed: () {
//                 // Set the selected language
//                 setLanguage('en'); // Example: English
//               },
//               child: Text('english').tr(),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Set the selected language
//                 setLanguage('ar'); // Example: French
//               },
//               child: Text('arabic').tr(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void setLanguage(String languageCode) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('language', languageCode);
//
//     await context.setLocale(Locale(languageCode));
//
//     // Navigate to the welcome screen or the appropriate next screen
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => WelcomeScreenNavigator()),
//     );
//   }
// }