import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/screens/xo_game.dart';
import 'package:Molhem/widgets/child_drawer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/helpers/theme_helper.dart';
import '../core/utils/store_history.dart';

class Play extends StatelessWidget {
  const Play({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ChildDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          height: 120,
          padding: EdgeInsets.all(8.0),
          color: Color(0xfff5cfa4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Container(height:40,child: Text('choose_game',style: TextStyle(fontSize: 28),).tr()),
              Expanded(
                child: Text('choose_game_desc',style: ThemeHelper.headingText(context)?.copyWith(
                  fontSize: 24
                ),).tr(),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(      color: Color(0xfff5cfa4),),
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    GestureDetector(
                      onTap: () async{
                        await storeHistory(
                            context: context,
                            degree: 'good',
                            action: 'played x-o game'
                        ).then((_){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => XOGame()));
                        });
                      },
                      child: Container(
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Color(0xfffbecdb),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(-3, 3),
                                  color: Colors.grey,blurRadius: 2),
                              BoxShadow(
                                  offset: Offset(3,0),
                                  color: Colors.grey,
                                  blurRadius: 2
                              )
                            ]),
                        child: AutoSizeText(
                          'xo'.tr(),
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff52451d)
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () async{
                        await storeHistory(
                          context: context,
                          degree: 'good',
                          action: 'played x-o game'
                        ).then((_){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => XOGame()));
                        });
                      },
                      child: Container(
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Color(0xfffbecdb),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(-3, 3),
                                  color: Colors.grey,blurRadius: 2),
                              BoxShadow(
                                offset: Offset(3,0),
                                color: Colors.grey,
                                blurRadius: 2
                              )
                            ]),
                        child: AutoSizeText(
                          'puzzle'.tr(),
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff52451d)
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async{
                        await storeHistory(
                            context: context,
                            degree: 'good',
                            action: 'played Match game'
                        ).then((_){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => XOGame()));
                        });
                      },
                      child: Container(
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Color(0xfffbecdb),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(-3, 3),
                                  color: Colors.grey,blurRadius: 2),
                              BoxShadow(
                                  offset: Offset(3,0),
                                  color: Colors.grey,
                                  blurRadius: 2
                              )
                            ]),
                        child: AutoSizeText(
                          'match'.tr(),
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff52451d)
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async{
                        await storeHistory(
                            context: context,
                            degree: 'good',
                            action: 'played x-o game'
                        ).then((_){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => XOGame()));
                        });
                      },
                      child: Container(
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Color(0xfffbecdb),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(-3, 3),
                                  color: Colors.grey,blurRadius: 2),
                              BoxShadow(
                                  offset: Offset(3,0),
                                  color: Colors.grey,
                                  blurRadius: 2
                              )
                            ]),
                        child: AutoSizeText(
                          'video'.tr(),
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff52451d)
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async{
                        await storeHistory(
                            context: context,
                            degree: 'good',
                            action: 'played x-o game'
                        ).then((_){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => XOGame()));
                        });
                      },
                      child: Container(
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Color(0xfffbecdb),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(-3, 3),
                                  color: Colors.grey,blurRadius: 2),
                              BoxShadow(
                                  offset: Offset(3,0),
                                  color: Colors.grey,
                                  blurRadius: 2
                              )
                            ]),
                        child: AutoSizeText(
                          'memory'.tr(),
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff52451d)
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async{
                        await storeHistory(
                            context: context,
                            degree: 'good',
                            action: 'played x-o game'
                        ).then((_){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => XOGame()));
                        });
                      },
                      child: Container(
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Color(0xfffbecdb),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(-3, 3),
                                  color: Colors.grey,blurRadius: 2),
                              BoxShadow(
                                  offset: Offset(3,0),
                                  color: Colors.grey,
                                  blurRadius: 2
                              )
                            ]),
                        child: AutoSizeText(
                          'mario'.tr(),
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff52451d)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
