import 'dart:math';
import 'package:flutter/material.dart';

class BackgroundColors {
  BackgroundColors._();

  static const List<Color> colors = [
    Color.fromARGB(255, 52, 152, 219), // Soft Blue
    Color.fromARGB(255, 46, 204, 113), // Emerald Green
    Color.fromARGB(255, 231, 76, 60), // Sunset Orange
    Color.fromARGB(255, 155, 89, 182), // Royal Purple
    Color.fromARGB(255, 47, 79, 79), // Dark Slate Gray
    Color.fromARGB(255, 26, 188, 156), // Deep Teal
    Color.fromARGB(255, 192, 57, 43), // Crimson Red
    Color.fromARGB(255, 211, 84, 0), // Dark Orange
    Color.fromARGB(255, 44, 62, 80), // Navy Blue
    Color.fromARGB(255, 34, 139, 34), // Forest Green
  ];

  static Color get color {
    if (colors.isEmpty) {
      return Colors.brown;
    }
    final Random random = Random();
    return colors[random.nextInt(colors.length)];
  }
}
