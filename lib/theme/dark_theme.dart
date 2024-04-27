import 'package:expense_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: GoogleFonts.josefinSans().fontFamily,
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all(Colors.grey[600]!.withOpacity(0.5)),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      minimumSize: MaterialStateProperty.all(Size(100, 50)),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    splashColor: Colors.white,
    backgroundColor: themecolor,
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.grey[900]!,
    onPrimaryContainer: Color(0xff00B4D8),
    onPrimary: Color(0xff00B4D8),
    secondary: Colors.grey[800]!,
    tertiary: Colors.grey[800]!,
    onTertiary: Colors.grey[200]!,
    onSecondary: Color(0xff00B4D8),
    inversePrimary: Colors.grey[200]!,
    onInverseSurface: Colors.grey[200]!,
    onBackground: Color(0xff00B4D8),
  ),
  hintColor: Colors.grey[600],
  shadowColor: Colors.grey[400],
  splashColor: Colors.grey[900],
);


// Color(0xffF72585),