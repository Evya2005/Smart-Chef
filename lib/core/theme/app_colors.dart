import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Warm editorial palette ──────────────────────────────────────────────
  static const Color cream = Color(0xFFFBF7F1);         // background
  static const Color surface = Color(0xFFFFFFFF);        // card / sheet
  static const Color sand = Color(0xFFF4ECE0);           // surface-2 (chips, tags)
  static const Color ink = Color(0xFF1F1B16);            // primary text
  static const Color ink2 = Color(0xFF6B6258);           // secondary text
  static const Color ink3 = Color(0xFFA39A8E);           // muted / hint
  static const Color terracotta = Color(0xFFB7461F);     // primary accent
  static const Color terracottaSoft = Color(0xFFF5DDD0); // accent container
  static const Color sage = Color(0xFF6B8159);           // active / cooking
  static const Color sageSoft = Color(0xFFE5EADF);       // sage container
  static const Color line = Color(0x141F1B16);           // divider light
  static const Color lineStrong = Color(0x241F1B16);     // divider medium

  // ── Semantic aliases ────────────────────────────────────────────────────
  static const Color primary = terracotta;
  static const Color primaryContainer = terracottaSoft;
  static const Color secondary = sage;
  static const Color secondaryContainer = sageSoft;
  static const Color background = cream;
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = ink;
  static const Color onSurface = ink;
  static const Color textSecondary = ink2;
  static const Color divider = line;

  // ── Functional / data-vis colors ────────────────────────────────────────
  static const Color starGold = Color(0xFFD9A441);         // star ratings
  static const Color nutritionProtein = Color(0xFF5B8DB8); // protein macro bar
  static const Color nutritionFat = Color(0xFFD4852A);     // fat macro bar
  static const Color nutritionCarbs = sage;                // carbs macro bar (reuse sage)

  // ── Legacy aliases (keep for code that hasn't been updated yet) ─────────
  static const Color tagBackground = sand;
  static const Color tagText = terracotta;
}
