import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/helpers/theme_helper.dart';

class WantComponentHolder extends StatelessWidget {
  final String name;
  final Widget? destination;

  final String image;

  const WantComponentHolder({
    Key? key,
    required this.name,
    this.destination,
    required this.image
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
    width:double.infinity,
    padding: EdgeInsets.all(12.0),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16.0),
    color: Color(0xff95bdd4),
    boxShadow: <BoxShadow>[
    BoxShadow(
    offset: Offset(-3,3),
    color: Colors.grey,
    ),
    ]
    ),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Image(image: CachedNetworkImageProvider(image),height: 100,width: 100),
            Expanded(
              child: AutoSizeText(name,style: ThemeHelper.headingText(context)?.copyWith(
                fontSize: 26
              ),maxLines: 1,),
            )
          ],
        ),
      ),
    );
  }
}
