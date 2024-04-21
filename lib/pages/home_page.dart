import 'package:expense_tracker/components/MyListTile.dart';
import 'package:expense_tracker/components/myTextField.dart';
import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/helper/helper.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    ref.read(expenseProvider.notifier).getAllExpenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => addExpense(context),
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: ref.watch(expenseProvider).allExpenses.length,
            itemBuilder: (context, index) {
              // individual expense
              Expense expense = ref.watch(expenseProvider).allExpenses[index];

              return MyListTile(
                title: expense.name,
                trailing: formatAmount(expense.amount),
                onEditPressed: (context) => editExpense(expense),
                onDeletePressed: (context) => deleteExpense(expense),
              );
            }),
      ),
    );
  }

  cancelButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
          _expenseNameController.clear();
          _expenseAmountController.clear();
        },
        child: Text('CANCEL',
            style: TextStyle(color: themecolor, fontWeight: FontWeight.bold)));
  }

  saveExpense(BuildContext context) {
    return TextButton(
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
    return TextButton(
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

          _expenseAmountController.clear();
          _expenseNameController.clear();
        },
        child: Text('SAVE',
            style: TextStyle(color: themecolor, fontWeight: FontWeight.bold)));
  }

  deleteButton(context, expense) {
    return TextButton(
        onPressed: () async {
          Navigator.pop(context);

          await ref.read(expenseProvider.notifier).deleteExpense(expense.id);
        },
        child: Text("DELETE",
            style: TextStyle(color: themecolor, fontWeight: FontWeight.bold)));
  }
}
