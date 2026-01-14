import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  //primary
  static const Color primary = Color(0xFF3D5CFF);
  // primaryText
  static const Color primaryText = Colors.black;
  static Color contentText = Colors.black.withValues(alpha: 0.6);

  static const Color danger = Colors.redAccent;
  static const Color secondaryText = Color.from(
    alpha: 0.7,
    red: 0,
    green: 0,
    blue: 0,
  );
  static const Color success = Color.fromARGB(255, 0, 255, 115);

  static const Color trueColor = Color.fromARGB(255, 0, 217, 98);

  static const Color fail = Colors.redAccent;

  static const Color primaryHighlight = Color(0xFF8B55F2);

  static const navBg = Color(0xFF2A2A2A);

  static Color placeholder = Colors.black.withValues(alpha: 0.4);
  static Color light = Color(0xFFFFFFFF);
  static Color bg900 = Color(0xFF111215);
  static Color bg700 = Color(0xFF2E3038);
  static Color bg500 = Color(0xFFE3E4E8);
  static Color borderColor = Colors.black.withValues(alpha: 0.1);
}
