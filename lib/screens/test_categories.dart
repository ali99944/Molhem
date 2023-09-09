import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/screens/test_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/auth_status_bloc/auth_status_bloc.dart';
import '../core/utils/UpperFirstLetter.dart';
import '../widgets/wave_background.dart';

class TestCategories extends StatelessWidget {
  const TestCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: Container(
          padding: EdgeInsets.all(8.0),
          height: 130,
          color: Color(0xffa08086),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              AutoSizeText(
                'test_choose_category'.tr(),
                style: TextStyle(
                  fontSize: 30,
                ),
                maxLines: 1,
              ),
              Expanded(
                child: AutoSizeText(
                  'test_category_desc'.tr(args: [upperFirstLetter(context.read<AuthStatusBloc>().userInformation!.username)]),
                  style: ThemeHelper.headingText(context)?.copyWith(
                    fontSize: 24
                  ),
                  maxLines: 1,
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(color: Color(0xffa08086),),
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(context.read<AuthStatusBloc>().id)
                        .collection('child-tests')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: AutoSizeText('swr'.tr(),style: TextStyle(
                            fontSize: 32
                          ),maxLines: 1,),
                        );
                      }

                      if (!snapshot.hasData) {
                        return Center(
                          child: Column(
                            children: [CircularProgressIndicator(), Text('loading').tr()],
                          ),
                        );
                      }

                      QuerySnapshot data = snapshot.data!;
                      List<QueryDocumentSnapshot> tests = data.docs;

                      if(tests.isEmpty){
                        return Container(
                          alignment: Alignment.center,
                          height: 580,
                          child: AutoSizeText('no_items'.tr(),style: ThemeHelper.headingText(context)?.copyWith(
                              fontSize: 28
                          ),),
                        );
                      }


                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: tests.length,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot test = tests[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TestScreen(testId: test.id,category: context.locale.languageCode == 'en' ? test['category'] : test['category-ar'])));
                            },
                            child: Container(
                              height: 150,
                              padding: EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ThemeHelper.background,
                                  borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(-3,3),
                                    color: Colors.grey,
                                    blurRadius: 2
                                  )
                                ]
                              ),
                              child: AutoSizeText(
                                upperFirstLetter(context.locale.languageCode == 'en' ? test['category'] : test['category-ar']),
                                style: TextStyle(fontSize: 40,color: ThemeHelper.foreground),
                                maxLines: 1,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
