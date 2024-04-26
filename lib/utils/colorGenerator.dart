import 'package:expense_tracker/constants.dart';
import 'package:flutter/material.dart';

class ColorGenerator {
  int _currentIndex = 0;

  Color getNextColor() {
    List<Color> allColors = [
      themecolor,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.red,
      Colors.brown,
      Colors.cyan,
      Colors.indigo,
      Colors.amber,
      Colors.pink,
      Colors.lightGreen,
      Colors.lime,
    ];

    // Get the next color
    Color nextColor = allColors[_currentIndex];

    // Increment the index for the next call
    _currentIndex = (_currentIndex + 1) % allColors.length;

    return nextColor;
  }
}
