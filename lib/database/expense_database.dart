import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

final expenseProvider = ChangeNotifierProvider<ExpenseDatabase>(
  (ref) => ExpenseDatabase(),
);

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Expense> _allExpenses = [];

  // setting up

  //intiliaze DB
  static Future<void> initiliazeDB() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  //getters

  List<Expense> get allExpenses => _allExpenses;

  /* operations */

  // -Create expense

  Future<void> createExpense(Expense expense) async {
    await isar.writeTxn(() => isar.expenses.put(expense));

    // read expense
    getAllExpenses();
  }

  // -Read expense

  Future<void> getAllExpenses() async {
    // fetch all the expenses from db
    List<Expense> fetchExpenses = await isar.expenses.where().findAll();

    //  send to local expense list
    _allExpenses.clear();
    _allExpenses.addAll(fetchExpenses);

    //update ui
    notifyListeners();
  }

  //-Update expense

  Future<void> updateExpense(int id, Expense expense) async {
    expense.id = id;

    await isar.writeTxn(() => isar.expenses.put(expense));

    await getAllExpenses();
  }

  // -Delete expense
  Future<void> deleteExpense(int id) async {
    await isar.writeTxn(() => isar.expenses.delete(id));
    await getAllExpenses();
  }

  /* helper */

  //total monthle expenses
  Future<Map<String, double>> totalMonthlyExpenses() async {
    // read expenses
    await getAllExpenses();

    Map<String, double> monthlyExpenses = {};

    // loop through each expense
    for (var expense in _allExpenses) {
      // get month and year
      String yearMonth = "${expense.data.year}-${expense.data.month}";

      if (!monthlyExpenses.containsKey(yearMonth)) {
        monthlyExpenses[yearMonth] = 0;
      }

      monthlyExpenses[yearMonth] = monthlyExpenses[yearMonth]! + expense.amount;
    }

    return monthlyExpenses;
  }

  // start month

  int getStartMonth() {
    if (_allExpenses.isEmpty) {
      return DateTime.now().month;
    }

    //sort expenses
    _allExpenses.sort(
      (a, b) => a.data.compareTo(b.data),
    );
    return _allExpenses.first.data.month;
  }

  //start year

  int getStartYear() {
    if (_allExpenses.isEmpty) {
      return DateTime.now().year;
    }

    //sort expenses
    _allExpenses.sort(
      (a, b) => a.data.compareTo(b.data),
    );
    return _allExpenses.first.data.year;
  }

  // Number of months since the first month
  int calculateMonthCount(
      int startYear, startMonth, currentYear, currentMonth) {
    int monthCount =
        (currentYear - startYear) * 12 + currentMonth - startMonth + 1;
    return monthCount;
  }

  List<Expense> getCurrentMonthExpenses() {
    List<Expense> currentMonthExpenses = allExpenses.where(
      (expense) {
        return expense.data.month == DateTime.now().month &&
            expense.data.year == DateTime.now().year;
      },
    ).toList();
    return currentMonthExpenses;
  }

  Future<double> getCurrentMonthTotal() async {
    await getAllExpenses();

    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;

    List<Expense> currentMonthExpense = getCurrentMonthExpenses();

    double total =
        currentMonthExpense.fold(0, (sum, element) => sum + element.amount);

    return total;
  }

  String getCurrentMonthName() {
    DateTime now = DateTime.now();
    List<String> months = [
      "JANUARY",
      "FEBRUARY",
      "MARCH",
      "APRIL",
      "MAY",
      "JUNE",
      "JULY",
      "AUGUST",
      "SEPTEMBER",
      "OCTOBER",
      "NOVEMBER",
      "DECEMBER"
    ];
    return months[now.month - 1];
  }

  // get current year name
  String getCurrentYearName() {
    return DateTime.now().year.toString();
  }
}
