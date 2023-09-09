import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/helpers/theme_helper.dart';
import '../data/models/story.dart';

class StoryDetails extends StatelessWidget {
  final Story story;
  const StoryDetails({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 240,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    story.image,
                    errorListener: (){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('image_load_failure').tr(),duration: Duration(seconds: 3),)
                      );
                    }
                  ),

                  fit: BoxFit.cover
                )
              ),
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      context.locale.languageCode == 'en' ? story.title : story.titleAr,
                      maxLines: 1,
                      style: TextStyle(fontSize: 32,color: ThemeHelper.foreground,fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 12.0,),
                  AutoSizeText(
                    context.locale.languageCode == 'en' ? story.content : story.contentAr,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: AutoSizeText('published_by'.tr(args: [story.author]),style: TextStyle(
                      color: ThemeHelper.foreground,
                      fontSize: 24
                    ),maxLines: 1,),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
