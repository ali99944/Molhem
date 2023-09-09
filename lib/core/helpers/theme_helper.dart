import 'package:flutter/material.dart';

class ThemeHelper{
  static Color primaryColor = Color(0xff2ba0e3);
  static Color secondaryColor = Color(0xff2ba0e3);
  static Color accentColor = Color(0xFFCED0CC);
  static Color autismColor = Color(0xffeff1ed);
  static Color background = Color(0xfff1d4d4);
  static Color foreground = Color(0xffaa6a6a);
  static Color blueAlter = Color(0xff7ea5ad);
  static Color blackAlter = Color(0xffaa6a6a);
  static Color childMainComponentColor = Colors.white;
  static Color scaffoldColor = Colors.black12;
  //small change
  static ButtonStyle fullSizePrimaryButtonStyle(BuildContext context){
    return ElevatedButton.styleFrom(
      backgroundColor: Color(0xff7ea5ad),
      minimumSize: const Size(double.infinity, 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: buttonTextStyle(context)
    );
  }

  static ButtonStyle textButtonTheme(BuildContext context){
    return TextButton.styleFrom(
        textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
        )
    );
  }

  static ButtonStyle fullSizeSecondaryButtonStyle(BuildContext context){
    return ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        minimumSize: const Size(double.infinity, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: buttonTextStyle(context)
    );
  }

  static ButtonStyle normalPrimaryButtonStyle(BuildContext context){
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  static TextStyle buttonTextStyle(BuildContext context){
    return const TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.bold
    );
  }

  static TextStyle? headingText(BuildContext context){
    return Theme.of(context).textTheme.headlineLarge;
  }

  static TextStyle? sectionText(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .headlineMedium;
  }

    static Color getHistoryActionColor(String degree){
    switch(degree){
      case 'normal':
        return Colors.black54;
      case 'danger':
        return Color(0xa86b1313);
      case 'warning':
        return Color(0xF9CEC41B);
      case 'good':
        return Color(0xFF258C29);

      default:
        return Colors.black54;
    }
  }
}