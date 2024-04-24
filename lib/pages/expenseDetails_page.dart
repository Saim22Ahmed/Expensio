import 'dart:developer';
import 'dart:math' as mi;
import 'dart:ui';

import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpenseDetails extends ConsumerStatefulWidget {
  const ExpenseDetails({super.key});

  @override
  ExpenseDetailsState createState() => ExpenseDetailsState();
}

class ExpenseDetailsState extends ConsumerState<ExpenseDetails> {
  List<Color> myColorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow
  ];

  List<Color> generateDifferentRandomColors(int count) {
    List<Color> result = [];
    mi.Random random = mi.Random();

    // Generate a list of random colors from Colors.primaries
    while (result.length < count) {
      Color newColor =
          Colors.primaries[random.nextInt(myColorList.length)].withOpacity(1.0);
      // Check if the new color is different from the existing ones
      bool isDifferent = true;
      for (Color existingColor in result) {
        if (newColor.value == existingColor.value) {
          isDifferent = false;
          break;
        }
      }
      // If the new color is different, add it to the result list
      if (isDifferent) {
        result.add(newColor);
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          List<Expense> currentMonthExpense =
              ref.watch(expenseProvider).getCurrentMonthExpenses();

          log(currentMonthExpense[0].name.toString());
          log(currentMonthExpense[1].name.toString());
          log(currentMonthExpense[2].name.toString());
          // log(currentMonthExpense[3].name.toString());

          // Calculate total expense amount for the current month
          double totalExpenseAmount = currentMonthExpense.fold(
              0, (previousValue, element) => previousValue + element.amount);

          log(totalExpenseAmount.toString());

          List<PieChartSectionData> pieChartSections =
              currentMonthExpense.map((expense) {
            // Calculate percentage of total amount for each expense
            double percentage = (expense.amount / totalExpenseAmount) * 100;

            return PieChartSectionData(
              color: generateDifferentRandomColors(
                  10)[0], // You can define a function to get random colors
              value: percentage,
              title: '${expense.amount}',
              radius: 100.0,
            );
          }).toList();

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
            ),
            body: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                    '${ref.watch(expenseProvider).getCurrentMonthName()} EXPENSES',
                    style: TextStyle(
                      fontFamily: GoogleFonts.righteous().fontFamily,
                      fontSize: 26.sp,
                    )),
                10.verticalSpace,
                SizedBox(
                  height: 300.h,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            return;
                          }
                        },
                      ),
                      sections: pieChartSections,
                      sectionsSpace: 10,
                      centerSpaceRadius: double.infinity,
                    ),
                  ).animate().shimmer(duration: const Duration(seconds: 2)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
