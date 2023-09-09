import 'package:flutter/material.dart';

showMessage({
  required BuildContext context,
  required String message
}){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 4),
      dismissDirection: DismissDirection.horizontal,
    )
  );
}