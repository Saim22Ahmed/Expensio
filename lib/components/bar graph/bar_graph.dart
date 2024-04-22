import 'dart:developer';

import 'package:expense_tracker/components/bar%20graph/individual_bar.dart';
import 'package:expense_tracker/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBarGraph extends StatefulWidget {
  const MyBarGraph(
      {super.key, required this.monthlySummary, required this.startMonth});

  final List<double> monthlySummary;
  final int startMonth;

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  List<IndividualBar> barData = [];

  void initializeBarData() {
    // log(widget.monthlySummary.toString());
    barData = List.generate(widget.monthlySummary.length,
        (index) => IndividualBar(x: index, y: widget.monthlySummary[index]));
  }

  @override
  Widget build(BuildContext context) {
    initializeBarData();
    return BarChart(BarChartData(
      minY: 0,
      maxY: 100,
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  reservedSize: 25.sp,
                  showTitles: true,
                  getTitlesWidget: getBottomTitles))),
      barGroups: barData
          .map((data) => BarChartGroupData(x: data.x, barRods: [
                BarChartRodData(
                    toY: data.y,
                    width: 20.sp,
                    borderRadius: BorderRadius.circular(5.r),
                    color: themecolor)
              ]))
          .toList(),
    ));
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  final style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12.sp,
  );

  String text;
  switch (value.toInt()) {
    case 0:
      text = 'JAN';
      break;
    case 1:
      text = 'FEB';
      break;
    case 2:
      text = 'MAR';
      break;
    case 3:
      text = 'APR';
      break;
    case 4:
      text = 'MAY';
      break;
    case 5:
      text = 'JUN';
      break;
    case 6:
      text = 'JUL';
      break;
    case 7:
      text = 'AUG';
      break;
    case 8:
      text = 'SEP';
      break;
    case 9:
      text = 'OCT';
      break;
    case 10:
      text = 'NOV';
      break;
    case 11:
      text = 'DEC';
      break;
    default:
      text = '';
      break;
  }

  return SideTitleWidget(
      child: Text(text, style: style), axisSide: meta.axisSide);
}
