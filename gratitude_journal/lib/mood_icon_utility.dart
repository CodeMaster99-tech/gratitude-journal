// lib/mood_icon_utility.dart
import 'package:flutter/material.dart';

class MoodIconUtility {
  static IconData getMoodIcon(int rating) {
    switch (rating) {
      case 5: return Icons.sentiment_very_satisfied;
      case 4: return Icons.sentiment_satisfied;
      case 3: return Icons.sentiment_neutral;
      case 2: return Icons.sentiment_dissatisfied;
      case 1: return Icons.sentiment_very_dissatisfied;
      default: return Icons.sentiment_satisfied;
    }
  }

  static Color getMoodColor(int rating) {
    switch (rating) {
      case 5: return Colors.green;
      case 4: return Colors.lightGreen;
      case 3: return Colors.yellow.shade800;
      case 2: return Colors.orange;
      case 1: return Colors.red;
      default: return Colors.lightGreen;
    }
  }

  static Widget buildMoodIcon(int rating, {double size = 36}) {
    return Icon(getMoodIcon(rating), color: getMoodColor(rating), size: size);
  }
}