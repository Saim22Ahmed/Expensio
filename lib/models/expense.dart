import 'package:isar/isar.dart';

// will generate isar file
part 'expense.g.dart';

@Collection()
class Expense {
  Id id = Isar.autoIncrement;
  final String name;
  final double amount;
  final DateTime data;

  Expense({required this.name, required this.amount, required this.data});
}
