import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/pages/expenseDetails_page.dart';
import 'package:expense_tracker/pages/home_page.dart';
import 'package:expense_tracker/pages/splash_scree.dart';
import 'package:expense_tracker/provider/theme_provider.dart';
import 'package:expense_tracker/theme/dark_theme.dart';
import 'package:expense_tracker/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:isar/isar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ExpenseDatabase.initiliazeDB();
  Animate.restartOnHotReload = true;
  runApp(ProviderScope(child: const MyApp()));
  // Animate.restartOnHotReload = true;
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(412, 892),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        theme: ref.watch(themeProvider).themeData,
        // darkTheme: darkTheme,
        home: SplashScreen(),
      ),
    );
  }
}
