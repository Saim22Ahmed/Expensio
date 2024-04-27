import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themecolor.withOpacity(0.9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expensio',
              style: TextStyle(
                fontSize: 50.sp,
                fontFamily: GoogleFonts.righteous().fontFamily,
              ),
            ).animate().slideX(
                curve: Curves.fastOutSlowIn, duration: 600.milliseconds),
            Animate(
              delay: 500.milliseconds,
              effects: [FadeEffect(), SlideEffect()],
              child: Text(
                'Know where your money goes!',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: GoogleFonts.openSans().fontFamily,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
