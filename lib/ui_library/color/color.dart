// color/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF007ACC);
  static const Color secondaryColor = Color(0xFFFFA500);
  static const Color backgroundColor = Color(0xFFF5F5F5);

  // Warna gradien
  static const Color gradientStart = Color(0xFF007ACC);
  static const Color gradientEnd = Color(0xFF00D4FF);
  LinearGradient gradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [Colors.blue, Colors.red],
);
  // Warna teks
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Warna aksen
  static const Color accentColor1 = Color(0xFFFF5A5F);
  static const Color accentColor2 = Color(0xFF4CAF50);
  static const Color accentColor3 = Color(0xFF673AB7);

  // Warna status
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
}
