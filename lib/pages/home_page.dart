import 'dart:developer';

import 'package:expense_tracker/components/MyListTile.dart';
import 'package:expense_tracker/components/bar%20graph/bar_graph.dart';
import 'package:expense_tracker/components/drawer/mydrawer.dart';
import 'package:expense_tracker/components/myTextField.dart';
import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/helper/helper.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/provider/theme_provider.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';

class HomePage extends ConsumerStatefulWidget {
  HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final _expenseNameController = TextEditingController();

  final _expenseAmountController = TextEditingController();

// add Expense
  void addExpense(
    context,
  ) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              shape: BeveledRectangleBorder(),
              title: Text(
                'Add Expense',
                style:
                    TextStyle(fontFamily: GoogleFonts.righteous().fontFamily),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                // expense name

                children: [
                  MyTextFormField(
                    controller: _expenseNameController,
                    hintText: 'Expense name',
                    obscuretext: false,
                  ),
                  20.verticalSpace,
                  MyTextFormField(
                    controller: _expenseAmountController,
                    hintText: 'Expense amount',
                    obscuretext: false,
                    keyboardType: TextInputType.number,
                  ),
                ],

                // expense  amount
              ),
              actions: [
                cancelButton(context),
                saveExpense(context),
              ],
            ));
  }

  // Edit Expense
  void editExpense(Expense expense) {
    // existing values

    String expenseName = expense.name;
    String expenseAmount = expense.amount.toString();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              shape: BeveledRectangleBorder(),
              title: Text(
                'Edit Expense',
                style:
                    TextStyle(fontFamily: GoogleFonts.righteous().fontFamily),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                // expense name

                children: [
                  MyTextFormField(
                    controller: _expenseNameController,
                    hintText: expenseName,
                    obscuretext: false,
                  ),
                  20.verticalSpace,
                  MyTextFormField(
                    controller: _expenseAmountController,
                    hintText: expense.amount.toString(),
                    obscuretext: false,
                    keyboardType: TextInputType.number,
                  ),
                ],

                // expense  amount
              ),
              actions: [
                cancelButton(context),
                saveEditedExpense(context, expense),
              ],
            ));
  }

  void deleteExpense(Expense expense) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              shape: BeveledRectangleBorder(),
              title: Text(
                'Delete Expense',
                style:
                    TextStyle(fontFamily: GoogleFonts.righteous().fontFamily),
              ),
              content: Text('Are you sure you want to delete this expense?'),
              actions: [
                cancelButton(context),
                deleteButton(context, expense),
              ],
            ));
  }

  getStartMonth() {
    return ref.read(expenseProvider.notifier).getStartMonth();
  }

  getStartYear() {
    return ref.read(expenseProvider.notifier).getStartYear();
  }

  int getCurrentMonth() {
    return DateTime.now().month;
  }

  int getCurrentYear() {
    return DateTime.now().year;
  }

  int getMonthCount() {
    return ref.read(expenseProvider.notifier).calculateMonthCount(
        getStartYear(), getStartMonth(), getCurrentYear(), getCurrentMonth());
  }

  // bar graph future
  Future<Map<String, double>>? _monthlyTotalFuture;
  Future<double>? _currentMonthTotal;
  @override
  void initState() {
    // TODO: implement initState
    ref.read(expenseProvider.notifier).getAllExpenses();

    refreshData();

    log('init state called');
    super.initState();
  }

  void refreshData() {
    _monthlyTotalFuture =
        ref.read(expenseProvider.notifier).totalMonthlyExpenses();
    _currentMonthTotal =
        ref.read(expenseProvider.notifier).getCurrentMonthTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
      ref.watch(themeProvider).addListener(() {
        refreshData();
        // setState(() {});
      });
      return SafeArea(
        child: Scaffold(
            drawer: MyDrawer(),
            appBar: AppBar(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              onPressed: () => addExpense(context),
              child: Icon(Icons.add),
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    20.verticalSpace,

                    // BarGraph
                    SizedBox(
                      height: 250,
                      child: FutureBuilder(
                          future: _monthlyTotalFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Map<String, double> monthlyTotals =
                                  snapshot.data ?? {};

                              List<double> monthlySummary =
                                  List.generate(getMonthCount(), (index) {
                                int year = getStartYear() +
                                    (getStartMonth() + index - 1) ~/ 12;
                                int month =
                                    (getStartMonth() + index - 1) % 12 + 1;

                                // key

                                String key = "$year-$month";

                                return monthlyTotals[key] ?? 0.0;
                              });

                              return MyBarGraph(
                                  monthlySummary: monthlySummary,
                                  startMonth: getStartMonth());
                            } else {
                              return Center(
                                  child: const CircularProgressIndicator(
                                color: themecolor,
                              ));
                            }
                          }),
                    ),

                    20.verticalSpace,
                    // current month total
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${ref.watch(expenseProvider).getCurrentMonthName()} '${ref.watch(expenseProvider).getCurrentYearName()}",
                            style: TextStyle(
                                fontFamily: GoogleFonts.righteous().fontFamily,
                                fontSize: 20.sp),
                          ),
                          CurrentMonthTotal(),
                        ],
                      ),
                    ),
                    20.verticalSpace,
                    // expenses
                    Expanded(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: ref
                              .watch(expenseProvider)
                              .getCurrentMonthExpenses()
                              .length,
                          itemBuilder: (context, index) {
                            // log('currentMonthTotal' +
                            //     ref
                            //         .watch(expenseProvider)
                            //         .getCurrentMonthTotal()
                            //         .toString());
                            // reverse
                            int reverseIndex = ref
                                    .watch(expenseProvider)
                                    .getCurrentMonthExpenses()
                                    .length -
                                1 -
                                index;

                            // individual expense
                            Expense expense = ref
                                .watch(expenseProvider)
                                .getCurrentMonthExpenses()[reverseIndex];

                            return MyListTile(
                              title: expense.name,
                              trailing: formatAmount(expense.amount),
                              onEditPressed: (context) => editExpense(expense),
                              onDeletePressed: (context) =>
                                  deleteExpense(expense),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            )),
      );
    });
  }

  FutureBuilder<double> CurrentMonthTotal() {
    return FutureBuilder<double>(
        future: _currentMonthTotal,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text(
              '\$${snapshot.data!.toStringAsFixed(2)}',
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

  cancelButton(BuildContext context) {
    return MaterialButton(
        onPressed: () {
          Navigator.pop(context);
          _expenseNameController.clear();
          _expenseAmountController.clear();
        },
        child: Text('CANCEL',
            style: TextStyle(color: themecolor, fontWeight: FontWeight.bold)));
  }

  saveExpense(BuildContext context) {
    return MaterialButton(
        onPressed: () async {
          if (_expenseNameController.text.isEmpty ||
              _expenseAmountController.text.isEmpty) {
            return;
          }

          // create expense
          Expense expense = Expense(
              name: _expenseNameController.text,
              amount: double.parse(_expenseAmountController.text),
              data: DateTime.now());

          // save it in database

          await ref.read(expenseProvider.notifier).createExpense(expense);

          refreshData();

          Navigator.pop(context);
          Utils().MySnackBar(
              context, 'Expense added successfully', Colors.green[600]);
          _expenseAmountController.clear();
          _expenseNameController.clear();
        },
        child: Text('ADD',
            style: TextStyle(color: themecolor, fontWeight: FontWeight.bold)));
  }

  saveEditedExpense(BuildContext context, Expense expense) {
    return MaterialButton(
        onPressed: () async {
          if (_expenseNameController.text.isNotEmpty ||
              _expenseAmountController.text.isNotEmpty) {
            Navigator.pop(context);

            Expense updatedExpense = Expense(
                name: _expenseNameController.text.isNotEmpty
                    ? _expenseNameController.text
                    : expense.name,
                amount: double.parse(_expenseAmountController.text.isNotEmpty
                    ? _expenseAmountController.text
                    : expense.amount.toString()),
                data: DateTime.now());

            // old expense id
            int existingExpenseId = expense.id;

            // update it in database

            await ref
                .read(expenseProvider.notifier)
                .updateExpense(existingExpenseId, updatedExpense);
          }

          refreshData();

          _expenseAmountController.clear();
          _expenseNameController.clear();
        },
        child: Text('SAVE',
            style: TextStyle(color: themecolor, fontWeight: FontWeight.bold)));
  }

  deleteButton(context, expense) {
    return MaterialButton(
        onPressed: () async {
          Navigator.pop(context);

          await ref.read(expenseProvider.notifier).deleteExpense(expense.id);
          refreshData();
        },
        child: Text("DELETE",
            style: TextStyle(color: themecolor, fontWeight: FontWeight.bold)));
  }
}
