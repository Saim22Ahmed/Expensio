import 'dart:async';
import 'dart:developer';

import 'dart:math' as mi;
import 'dart:ui';

import 'package:expense_tracker/components/expense_card.dart';
import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/colorGenerator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpenseDetails extends ConsumerStatefulWidget {
  const ExpenseDetails({super.key});

  @override
  ExpenseDetailsState createState() => ExpenseDetailsState();
}

class ExpenseDetailsState extends ConsumerState<ExpenseDetails> {
  Future<double>? _getCurrentMonthTotal;
  List<Expense>? _currentMonthExpense;

  int? touchIndex;

  ColorGenerator colorGenerator = ColorGenerator();

  void refreshData() {
    _getCurrentMonthTotal =
        ref.read(expenseProvider.notifier).getCurrentMonthTotal();

    _currentMonthExpense =
        ref.read(expenseProvider.notifier).getCurrentMonthExpenses();
  }

  FutureBuilder<double> CurrentMonthTotal() {
    return FutureBuilder<double>(
        future: _getCurrentMonthTotal,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text(
              '${snapshot.data!.toStringAsFixed(2)}',
              style: TextStyle(
                  fontFamily: GoogleFonts.righteous().fontFamily,
                  fontSize: 20.sp),
            );
          } else {
            return Center(
                child: Transform.scale(
              scale: 0.2,
              child: const CircularProgressIndicator(
                color: themecolor,
              ),
            ));
          }
        });
  }

  Expense getHighestExpense() {
    List<Expense> currentMonthExpense = _currentMonthExpense!;

    currentMonthExpense.sort((a, b) => b.amount.compareTo(a.amount));

    final highest = currentMonthExpense.first;

    return highest;
  }

  Expense getLeastExpense() {
    List<Expense> currentMonthExpense = _currentMonthExpense!;

    currentMonthExpense.sort((a, b) => b.amount.compareTo(a.amount));

    final least = currentMonthExpense.last;

    return least;
  }

  @override
  void initState() {
    // TODO: implement initState
    refreshData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                  '${ref.watch(expenseProvider).getCurrentMonthName()} EXPENSES',
                  style: TextStyle(
                    fontFamily: GoogleFonts.righteous().fontFamily,
                    fontSize: 26.sp,
                  )),
            ),

            20.verticalSpace,
            //Future Builder

            SizedBox(
              height: 300.h,
              child: FutureBuilder<double>(
                  future: _getCurrentMonthTotal,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      double currentMonthTotal = snapshot.data ?? 0.0;

                      List<Expense> currentMonthExpense = _currentMonthExpense!;
                      getHighestExpense();

                      // Calculate total expense amount for the current month
                      double totalExpenseAmount = currentMonthExpense.fold(
                          0,
                          (previousValue, element) =>
                              previousValue + element.amount);

                      // highgest expense
                      if (currentMonthExpense.isNotEmpty) {
                        Expense highestExpense = currentMonthExpense.reduce(
                            (value, element) => value.amount > element.amount
                                ? value
                                : element);

                        // Set the provider

                        log('highestExpense : ' +
                            highestExpense.name +
                            ' : ' +
                            highestExpense.amount.toString());
                      }

                      List<PieChartSectionData> pieChartSections =
                          currentMonthExpense.map((expense) {
                        // Calculate percentage of total amount for each expense
                        double percentage =
                            (expense.amount / totalExpenseAmount) * 100;

                        // Check if the current expense is being touched

                        log('touchIndex 2:' + touchIndex.toString());

                        return PieChartSectionData(
                            badgeWidget:
                                _buildBadgeWidget(expense.name, themecolor),
                            badgePositionPercentageOffset: 0.98,
                            titlePositionPercentageOffset: 0.65,
                            value: percentage,
                            title: '${percentage.toStringAsFixed(2)}%',
                            titleStyle: TextStyle(
                                fontFamily: GoogleFonts.righteous().fontFamily,
                                fontSize: 16.sp,
                                color: Colors.white),
                            color: colorGenerator.getNextColor(),
                            radius: 120);
                      }).toList();

                      return PieChart(
                          swapAnimationDuration: Duration(milliseconds: 750),
                          swapAnimationCurve: Curves.fastOutSlowIn,
                          PieChartData(
                              startDegreeOffset: 0,
                              sections: pieChartSections,
                              sectionsSpace: 10,
                              centerSpaceRadius: 0,
                              pieTouchData: PieTouchData(
                                enabled: true,
                                touchCallback:
                                    (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection ==
                                            null) {
                                      touchIndex = -1;
                                      return;
                                    } else {
                                      touchIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                      log('touchIndex:' +
                                          touchIndex.toString());
                                    }
                                  });

                                  // touched section radious increase
                                },
                              )));
                    } else {
                      return Center(
                          child: Transform.scale(
                        scale: 0.2,
                        child: const CircularProgressIndicator(
                          color: themecolor,
                        ),
                      ));
                    }
                  }),
            ),

            30.verticalSpace,

            //Total Expense
            ExpenseCard(
              title: 'Total Expense',
              amount: CurrentMonthTotal(),
            ),

            // Most Expensive Expense
            ExpenseCard(
              title: 'Most Expensive',
              amount: Text(
                '${getHighestExpense().name} (${getHighestExpense().amount})',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
            // Most Expensive Expense
            ExpenseCard(
              title: 'Least Expensive',
              amount: Text(
                '${getLeastExpense().name} (${getLeastExpense().amount})',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeWidget(String expenseName, Color color) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 6)
        ],
      ),
      child: Text(
        expenseName,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
