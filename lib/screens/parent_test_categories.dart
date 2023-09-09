import 'package:auto_size_text/auto_size_text.dart';
import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:Molhem/screens/add_new_test_category_screen.dart';
import 'package:Molhem/screens/test_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_status_bloc/auth_status_bloc.dart';
import '../core/utils/UpperFirstLetter.dart';
import '../widgets/wave_background.dart';
import 'add_new_question_screen.dart';

class ParentTestCategories extends StatelessWidget {
  const ParentTestCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          'choose_category'.tr(),
          style: TextStyle(
            fontSize: 30,
          ),
          maxLines: 1,
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddNewTestCategoryScreen()));
                },
                child: Text('add_category',style: TextStyle(
                    fontSize: 26,
                    color: ThemeHelper.blueAlter
                ),).tr(),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddNewQuestionScreen()));
                },
                child: Text('add_question',style: TextStyle(
                    fontSize: 26,
                    color: ThemeHelper.blueAlter
                ),).tr(),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(context.read<AuthStatusBloc>().id)
                    .collection('child-tests')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('swr').tr(),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          Text('loading_categories').tr()
                        ],
                      ),
                    );
                  }

                  QuerySnapshot data = snapshot.data!;
                  List<QueryDocumentSnapshot> tests = data.docs;

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
                              builder: (context) => TestScreen(testId: test.id,category: test['category'])));
                        },
                        child: Container(
                          height: 150,
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: ThemeHelper.blueAlter,
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
                            style: ThemeHelper.headingText(context)?.copyWith(
                              fontSize: 40
                            ),
                            maxLines: 1,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
