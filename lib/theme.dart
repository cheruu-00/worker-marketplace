import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const pri = Color(0xFF12805C);
  static const priDark = Color(0xFF0B5D43);
  static const priSoft = Color(0xFFE3F4EC);
  static const acc = Color(0xFFF5A524);
  static const accSoft = Color(0xFFFFF3DC);
  static const accDark = Color(0xFF8A5A00);
  static const bg = Color(0xFFF5F7F5);
  static const card = Color(0xFFFFFFFF);
  static const ink = Color(0xFF14201B);
  static const mute = Color(0xFF66756D);
  static const line = Color(0xFFE3E9E5);
  static const mpesa = Color(0xFF00A651);
}

/// Inter text style. [lineHeight] is in logical pixels, like Figma.
TextStyle txt(double size, FontWeight weight, Color color, {double? lineHeight}) {
  return GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: lineHeight == null ? null : lineHeight / size,
  );
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.pri, primary: AppColors.pri),
    textTheme: GoogleFonts.interTextTheme(),
  );
}
