import 'dart:ui';

import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/pages/expenseDetails_page.dart';
import 'package:expense_tracker/pages/test.dart';
import 'package:expense_tracker/provider/theme_provider.dart';
import 'package:expense_tracker/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: themecolor,
      // backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // header
            Column(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                      dividerTheme:
                          DividerThemeData(color: Colors.transparent)),
                  child: DrawerHeader(
                      child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 60.sp,
                  )),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = Offset(1.0, 0.0);
                            var end = Offset.zero;
                            var curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ExpenseDetails(),
                        ));
                  },
                  child: Text(
                    'S T A T I S T I C S',
                    style: TextStyle(fontSize: 20.sp, color: Colors.white),
                  ),
                ),
              ],
            ),

            // switch
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 20.sp, color: Colors.white),
                ),
                10.horizontalSpace,
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    return Switch(
                        activeColor: themecolor,
                        inactiveTrackColor:
                            Theme.of(context).colorScheme.onTertiary,
                        activeTrackColor:
                            Theme.of(context).colorScheme.tertiary,
                        value: ref.watch(themeProvider).themeData == darkTheme,
                        onChanged: (value) {
                          Navigator.pop(context);
                          ref.watch(themeProvider).toggleTheme();
                        });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
