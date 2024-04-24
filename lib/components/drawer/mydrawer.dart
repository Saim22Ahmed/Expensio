import 'dart:ui';

import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/provider/theme_provider.dart';
import 'package:expense_tracker/theme/dark_theme.dart';
import 'package:flutter/material.dart';
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
      child: Column(
        children: [
          // header
          Theme(
            data: Theme.of(context).copyWith(
                dividerTheme: DividerThemeData(color: Colors.transparent)),
            child: DrawerHeader(
                child: Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 60.sp,
            )),
          ),

          Text(
            'Stats',
            style: TextStyle(fontSize: 20.sp, color: Colors.white),
          ),

          Text(
            'Dark Mode',
            style: TextStyle(fontSize: 20.sp, color: Colors.white),
          ),

          // switch
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return Switch(
                  inactiveTrackColor: Theme.of(context).colorScheme.onTertiary,
                  activeTrackColor: Theme.of(context).colorScheme.tertiary,
                  value: ref.watch(themeProvider).themeData == darkTheme,
                  onChanged: (value) {
                    Navigator.pop(context);
                    ref.watch(themeProvider).toggleTheme();
                  });
            },
          ),
        ],
      ),
    );
  }
}
