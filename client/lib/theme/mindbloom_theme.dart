import 'package:flutter/material.dart';

/// MindBloom color system — matched to the approved "Recommended for You" mockup.
class MBColors {
  // Core brand
  static const Color darkGreen = Color(0xFF0E4A3A); // headings, buttons, navbar
  static const Color deepGreen = Color(
    0xFF16624F,
  ); // gradients / pressed states
  static const Color background = Color(
    0xFFEFF5F1,
  ); // light mint page background
  static const Color card = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF0E4A3A);
  static const Color textSecondary = Color(0xFF5B6B64);

  // Icon tiles (pastel square backgrounds + icon colors)
  static const Color meditationTile = Color(0xFFDDEEDF);
  static const Color meditationIcon = Color(0xFF2E7D4F);

  static const Color breathingTile = Color(0xFFDBEAFB);
  static const Color breathingIcon = Color(0xFF3B82F6);

  static const Color journalTile = Color(0xFFFDEEC9);
  static const Color journalIcon = Color(0xFFE5A63B);

  static const Color audioTile = Color(0xFFE4DEFA);
  static const Color audioIcon = Color(0xFF7C5CE0);

  static const Color mindfeedTile = Color(0xFFD8F0EC);
  static const Color mindfeedIcon = Color(0xFF0F9B8E);
}

class MBTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: MBColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: MBColors.darkGreen,
      primary: MBColors.darkGreen,
    ),
    fontFamily: 'Poppins', // optional: add Poppins for the rounded look
  );
}
