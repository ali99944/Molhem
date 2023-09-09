import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/helpers/theme_helper.dart';

class ChildActivitiesChartBar extends StatefulWidget {
  const ChildActivitiesChartBar({Key? key}) : super(key: key);

  @override
  State<ChildActivitiesChartBar> createState() => _ChildActivitiesChartBarState();
}

class _ChildActivitiesChartBarState extends State<ChildActivitiesChartBar> {
  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      ThemeHelper.primaryColor,
      ThemeHelper.secondaryColor,
      // Colors.grey,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  Map<DateTime, List<Map<String, dynamic>>> groupMapsByDay(List<Map<String, dynamic>> maps) {
    return groupBy<Map<String, dynamic>, DateTime>(maps, (map) {
      // Extract the timestamp from the map and convert it to DateTime
      int timestamp = map['timestamp'];
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      // Extract the date part from the DateTime
      return DateTime(dateTime.year, dateTime.month, dateTime.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore
          .instance
          .collection('users')
          .doc(context.read<AuthStatusBloc>().id)
          .collection('child-history')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.hasError){
          return Center(
            child: Text(
              "couldn't load the chart",
              style: TextStyle(fontSize: 28),
            ),
          );
        }

        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<DocumentSnapshot> docs = snapshot.data!.docs;

        if(docs.isEmpty){
          return Container(
            alignment: Alignment.center,
            child: AutoSizeText('no_activities'.tr(),maxLines: 1,style: ThemeHelper.headingText(context)?.copyWith(
              fontSize: 30
            ),),
          );
        }

        List<Map<String,dynamic>> maps = docs.map((e){
          return {
            'action': e.get('action'),
            'timestamp': e.get('timestamp'),
            'degree': e.get('degree')
          };
        }).toList();
        Map<DateTime, List<Map<String, dynamic>>> groupedMaps = groupMapsByDay(maps);

        // Print the grouped maps
        groupedMaps.forEach((date, maps) {
          print('Date: ${date.day}');
          maps.forEach((map) {
            print('action: ${map['action']}, Timestamp: ${map['timestamp']}');
          });
          print('---');
        });

        return AspectRatio(
          aspectRatio: 4/3,
          child: BarChart(
            BarChartData(
                maxY: 200,
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    tooltipPadding: EdgeInsets.zero,
                    tooltipMargin: 8,
                    getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                        ) {
                      return BarTooltipItem(
                        rod.toY.round().toString(),
                        TextStyle(
                          color: ThemeHelper.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                barGroups: groupedMaps.entries.toList().sublist(0,7).map((map){
                  return BarChartGroupData(
                      groupVertically: true,
                      x: map.key.day % 7,
                      barRods: [
                        BarChartRodData(toY: map.value.length.toDouble(),gradient: _barsGradient)
                      ],
                      showingTooltipIndicators: [0]
                  );
                }).toList(),

                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text('Days'),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: getTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: Text('Activities'),
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                )
            ),
            swapAnimationDuration: Duration(milliseconds: 150), // Optional
            swapAnimationCurve: Curves.linear, // Optional
          ),
        );
      },
    );
  }



  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: ThemeHelper.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mn';
        break;
      case 1:
        text = 'Te';
        break;
      case 2:
        text = 'Wd';
        break;
      case 3:
        text = 'Tu';
        break;
      case 4:
        text = 'Fr';
        break;
      case 5:
        text = 'St';
        break;
      case 6:
        text = 'Sn';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

}
