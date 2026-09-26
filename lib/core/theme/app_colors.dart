import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF0F172A); // Slate 900
  static const Color primaryLight = Color(0xFF334155); // Slate 700
  static const Color accent = Color(0xFF3B82F6); // Blue 500
  
  // Backgrounds
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50
  static const Color surfaceLight = Colors.white;
  static const Color backgroundDark = Color(0xFF0F172A); // Slate 900
  static const Color surfaceDark = Color(0xFF1E293B); // Slate 800

  // Text
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Status & semantic
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  
  static const Color statusDraft = Color(0xFF94A3B8); // Slate 400
  static const Color statusUpcoming = Color(0xFF3B82F6); // Blue 500
  static const Color statusDueSoon = Color(0xFFF59E0B); // Amber 500
  static const Color statusDue = Color(0xFFF97316); // Orange 500
  static const Color statusOverdue = Color(0xFFEF4444); // Red 500
  static const Color statusPaid = Color(0xFF10B981); // Emerald 500
}
