import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChildMainComponentWithImage extends StatelessWidget {
  final String name;
  final String iconUrl;
  final Widget? destination;
  final Color color;
  const ChildMainComponentWithImage({
    Key? key,
    required this.name,
    required this.iconUrl,
    this.destination,
    required this.color
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: destination != null ? (){
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => destination!,
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
      } : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Color(0xff95bdd4),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(-3,3),
                  color: Colors.grey,
              )
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: iconUrl,
              height: 100,
              width: 100,
            ),
            SizedBox(height: 8.0,),
            Expanded(
              child: AutoSizeText(name,style: ThemeHelper.headingText(context)?.copyWith(
                fontSize: 28
              ),maxLines: 1,),
            )
          ],
        ),
      ),
    );
  }
}
