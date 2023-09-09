import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../core/helpers/theme_helper.dart';
import '../widgets/child_activities_chart_bar.dart';

class AnalyzeAndWatchScreen extends StatefulWidget {
  const AnalyzeAndWatchScreen({Key? key}) : super(key: key);

  @override
  State<AnalyzeAndWatchScreen> createState() => _AnalyzeAndWatchScreenState();
}

class _AnalyzeAndWatchScreenState extends State<AnalyzeAndWatchScreen> with SingleTickerProviderStateMixin{
  double _ratio = 0.0;

  bool _isInitialScore = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    loadValue();
  }

  late AnimationController _animationController;
  late Animation<double> _animation;

  Stream scoreUpdates() async*{
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;


  }

  void loadValue() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QueryDocumentSnapshot snapshot = (await firestore.collection('users').get()).docs.where((element) => element['uid'] == uid).first;

    QuerySnapshot collection = await firestore.collection('users').doc(snapshot.id).collection('child-scores').get();
    List<DocumentSnapshot> docs = collection.docs;
    if(docs.isEmpty){
      setState(() {
        _isInitialScore = true;
      });
    }

    int sum = docs.map<int>((doc) => doc['score'] as int).reduce((value, element) => value + element);
    int total = docs.map<int>((doc) => doc['max'] as int).reduce((value, element) => value + element);

    _animation = Tween<double>(begin: 0.0, end: sum/total)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    await _animationController.forward();
    setState(() {
      _ratio = _animation.value;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200.sp,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Color(0xff7ea5ad),
          ),
          child: _isInitialScore ? AutoSizeText('no_scores'.tr(),maxLines:1,style: ThemeHelper.headingText(context)?.copyWith(
            fontSize: 30
          ),) : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText('total_score'.tr(),style: ThemeHelper.headingText(context)?.copyWith(
                      fontSize: 30
                  ),maxLines: 1,),
                ),
              ),
              Expanded(
                flex: 1,
                child: CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 10.0,
                  percent: _ratio,
                  center: Text(
                    "${(_ratio * 100).toStringAsFixed(0)}%",
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  progressColor: _selectColor(_ratio * 100),
                  animation: true,
                  animateFromLastPercent: true,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0,),
        Expanded(
            child: ChildActivitiesChartBar()
        ),


      ],
    );
  }

  Color? _selectColor(double d) {
    if(d <= 20){
      return Colors.redAccent;
    }else if(d > 20 && d < 50){
      return Colors.amber;
    }else if(d >= 50){
      return Colors.green;
    }

    return null;
  }
}
