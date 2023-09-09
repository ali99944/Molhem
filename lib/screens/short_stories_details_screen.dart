import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../core/helpers/theme_helper.dart';

class ShortStoryDetailsScreen extends StatelessWidget {
  final String title;
  final String mainImage;
  final List<dynamic> imagePaths;

  ShortStoryDetailsScreen({required this.title, required this.imagePaths, required this.mainImage});

  @override
  Widget build(BuildContext context) {
    print(imagePaths);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 320,
            color: Color(0xffeaf7fa),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text('go_back',style: TextStyle(fontSize: 24,color: ThemeHelper.blueAlter),).tr(),
                    ),
                  ),
                ),
                Image.network(
                  mainImage,
                  fit: BoxFit.cover,
                ),

                Container(
                  padding: EdgeInsets.all(8.0),
                  height: 40,
                  child: AutoSizeText(
                    title,
                    style: TextStyle(
                      fontSize: 28.0,
                      color: ThemeHelper.blueAlter,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.0),
          CarouselSlider(
            options: CarouselOptions(
              height: 400,
              padEnds: false,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
            ),
            items: imagePaths.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            decoration:BoxDecoration(
                              borderRadius:BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(-3,3),
                                  blurRadius: 2
                                ),
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(3,0),
                                    blurRadius: 2
                                ),
                              ]
                            ),
                            child: CachedNetworkImage(
                              imageUrl:item['image'],
                              fit: BoxFit.cover,
                              height: 180,
                              width:double.infinity
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SingleChildScrollView(
                            child: Container(
                              child: AutoSizeText(context.locale.languageCode == 'en' ? item['text']: item['text-ar'],style: TextStyle(
                                fontSize: 22
                              ),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}