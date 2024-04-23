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
    log('Bar Graph Screen');
    log('startMonth : ' + widget.startMonth.toString());
    int adjustedStartMonth = (widget.startMonth - 1) % 12;
    log('startMonth : ' + widget.startMonth.toString());
    log('adjustedStartMonth : ' + adjustedStartMonth.toString());
    // log(widget.monthlySummary.toString());
    barData = List.generate(widget.monthlySummary.length, (index) {
      int adjustedIndex = (index + adjustedStartMonth) % 12;
      return IndividualBar(x: adjustedIndex, y: widget.monthlySummary[index]);
    });
  }

  double calculateMaxValue() {
    double max = 500;

    widget.monthlySummary.sort();

    max = widget.monthlySummary.last * 1.05;

    if (max < 500) {
      return 500;
    }

    return max;
  }

  @override
  Widget build(BuildContext context) {
    double barWidth = 20;
    double spaceBetweenBars = 15;
    initializeBarData();
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: barWidth * barData.length +
              spaceBetweenBars * (barData.length - 1),
          child: BarChart(BarChartData(
            minY: 0,
            maxY: calculateMaxValue(),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
                show: true,
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                        color: themecolor,
                        backDrawRodData: BackgroundBarChartRodData(
                            toY: calculateMaxValue(),
                            show: true,
                            color: Theme.of(context).colorScheme.primary),
                      )
                    ]))
                .toList(),
            alignment: BarChartAlignment.center,
            groupsSpace: spaceBetweenBars,
          )),
        ),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  final style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12.sp,
  );

  String text;
  switch (value.toInt() % 12) {
    case 0:
      text = 'J';
      break;
    case 1:
      text = 'F';
      break;
    case 2:
      text = 'M';
      break;
    case 3:
      text = 'A';
      break;
    case 4:
      text = 'M';
      break;
    case 5:
      text = 'J';
      break;
    case 6:
      text = 'J';
      break;
    case 7:
      text = 'A';
      break;
    case 8:
      text = 'S';
      break;
    case 9:
      text = 'O';
      break;
    case 10:
      text = 'N';
      break;
    case 11:
      text = 'D';
      break;
    default:
      text = '';
      break;
  }

  return SideTitleWidget(
      child: Text(text, style: style), axisSide: meta.axisSide);
}
