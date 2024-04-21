import 'package:expense_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyListTile extends StatelessWidget {
  MyListTile(
      {super.key,
      required this.title,
      required this.trailing,
      required this.onDeletePressed,
      required this.onEditPressed});

  final String title;
  final String trailing;
  final Function(BuildContext)? onDeletePressed;
  final Function(BuildContext)? onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: StretchMotion(), children: [
        //edit
        SlidableAction(
          onPressed: onEditPressed,
          backgroundColor: Colors.transparent,
          foregroundColor: themecolor,
          icon: Icons.edit,
          // label: 'Edit',
        ),
        // edit
        SlidableAction(
          onPressed: onDeletePressed,
          backgroundColor: Colors.transparent,
          foregroundColor: themecolor,
          icon: Icons.delete,
          // label: 'Delete',
        ),
      ]),
      child: ListTile(
        title: Text(title),
        trailing: Text(trailing),
      ),
    );
  }
}
