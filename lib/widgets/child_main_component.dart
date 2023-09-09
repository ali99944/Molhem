import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/helpers/theme_helper.dart';

class ChildMainComponent extends StatelessWidget {
  final String name;
  final String assetPath;
  final Widget destination;
  final Color color;
  final Color backgroundColor;
  const ChildMainComponent({
    Key? key,
    required this.name,
    required this.assetPath,
    required this.destination,
    required this.color,
    required this.backgroundColor
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => destination,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: backgroundColor,
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(0,2),
              color: Colors.grey,
            )
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex:2,child: Image.asset(assetPath,color: color,height: 60,width: 60,)),
            Expanded(flex:1,child: AutoSizeText(name.toLowerCase().tr(),style: TextStyle(fontSize: 26),maxLines: 1,))
          ],
        ),
      ),
    );
  }
}
