import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  //primary
  static const Color primary = Color(0xFF40F492);
  // primaryText
  static const Color primaryText = Colors.white;
  static Color contentText = Colors.white.withValues(alpha: 0.6);

  static const Color danger = Colors.redAccent;
  static const Color secondaryText = Color.from(
    alpha: 0.7,
    red: 1,
    green: 1,
    blue: 1,
  );
  static const Color success = Color(0xFF40F492);
  static const Color fail = Colors.redAccent;

  static const primaryGradient = [Color(0xFFA61CB3), Color(0xFF8B55F2)];
  static const disabledGradient = [Color(0xFFC6C0C4), Color(0xFFC6C0C4)];
  static const disabledBtnBg = Color(0xFFC6C0C4);
  static const secondaryGradient = [Color(0x20FFFFFF), Color(0x60FFFFFF)];
  static const primaryInnerShadow = Color(0xFFCFB9FA);
  static const primaryBtnBg = Color(0xFF8B55F2);
  static const primaryDropShadow = Color(0xFF8B55F2);
  static const primaryBorder = Color(0xFFFFBAEF);

  static const Color primaryHighlight = Color(0xFF8B55F2);

  static const navBg = Color(0xFF2A2A2A);

  static const Color coinColor = Color(0xFFEFDE4A);

  static const Color coinInnerShadow = Color(0xFFCFB9FA);
  static const coinGradient = [Color(0xFF8B55F2), Color(0xFFF3EEFE)];
  static const coinBorder = Color(0xFFAE6BFF);
  static const featureProGradient = [Color(0xFF9F72F4), Color(0xFF40F492)];
  static const prevGradient = [Color(0xFFF29B0E), Color(0xFFFABD07)];
  static const outlineButton = Color(0xFF9F72F4);
  static const prevOutline = Color(0xFFFFA70E);

  static const textInputGlowing = Color(0xFF40F492);

  static Color placeholder = Color(0xFFFFFFFF).withValues(alpha: 0.4);
  static Color light = Color(0xFFFFFFFF);
  static Color bg900 = Color(0xFF111215);
  static Color bg700 = Color(0xFF2E3038);
  static Color bg500 = Color(0xFFE3E4E8);
  static Color borderColor = Colors.white.withValues(alpha: 0.1);

  static const primaryReject = [Color(0xFFEE5151), Color(0xFFE94343)];
  static const primaryUnderReview = [Color(0xFFFBBE07), Color(0xFFF29B0E)];
  static const linearColor = [Color(0xFF632BCD), Color(0xFF9F72F4), Color(0xFF13E573)];
}
