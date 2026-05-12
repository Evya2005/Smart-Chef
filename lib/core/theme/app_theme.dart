import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // ── Typography ─────────────────────────────────────────────────────────
  // Source Serif 4 for display/headline/title; Assistant for body/label/UI
  static TextTheme get _textTheme {
    final serif = GoogleFonts.sourceSerif4TextTheme();
    final sans = GoogleFonts.assistantTextTheme();
    return sans.copyWith(
      // Display & headline → serif
      displayLarge: serif.displayLarge,
      displayMedium: serif.displayMedium,
      displaySmall: serif.displaySmall,
      headlineLarge: serif.headlineLarge,
      headlineMedium: serif.headlineMedium,
      headlineSmall: serif.headlineSmall,
      titleLarge: serif.titleLarge,
      titleMedium: serif.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      // Body, label → sans (already set via sans base)
    );
  }

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.terracotta,
      onPrimary: Colors.white,
      primaryContainer: AppColors.terracottaSoft,
      onPrimaryContainer: AppColors.terracotta,
      secondary: AppColors.sage,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.sageSoft,
      onSecondaryContainer: AppColors.sage,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      surfaceContainerHighest: AppColors.sand,
      onSurfaceVariant: AppColors.ink2,
      outline: AppColors.lineStrong,
      outlineVariant: AppColors.line,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: const Color(0xFFFFDAD6),
      onErrorContainer: const Color(0xFF410002),
      shadow: const Color(0x1A1F1B16),
      scrim: const Color(0x991F1B16),
      inverseSurface: AppColors.ink,
      onInverseSurface: AppColors.cream,
      inversePrimary: AppColors.terracottaSoft,
    );

    final textTheme = _textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.sourceSerif4(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: AppColors.ink2),
        surfaceTintColor: Colors.transparent,
        shadowColor: AppColors.line,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.terracotta,
        foregroundColor: Colors.white,
        extendedTextStyle: GoogleFonts.assistant(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        shape: const StadiumBorder(),
        elevation: 4,
        highlightElevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lineStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lineStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.terracotta, width: 1.5),
        ),
        hintStyle: GoogleFonts.assistant(color: AppColors.ink3, fontSize: 15),
        labelStyle: GoogleFonts.assistant(color: AppColors.ink2),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.terracotta,
          foregroundColor: Colors.white,
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.assistant(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.terracotta,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.assistant(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.lineStrong),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.assistant(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.terracotta,
          textStyle: GoogleFonts.assistant(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.sand,
        selectedColor: AppColors.terracotta,
        labelStyle: GoogleFonts.assistant(
          color: AppColors.ink2,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: GoogleFonts.assistant(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.terracotta,
        unselectedItemColor: AppColors.ink3,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.assistant(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.assistant(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.terracottaSoft,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.terracotta);
          }
          return const IconThemeData(color: AppColors.ink3);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.assistant(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.terracotta,
            );
          }
          return GoogleFonts.assistant(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.ink3,
          );
        }),
        surfaceTintColor: Colors.transparent,
        shadowColor: AppColors.line,
        elevation: 2,
      ),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(AppColors.surface),
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.lineStrong),
          ),
        ),
        hintStyle: WidgetStatePropertyAll(
          GoogleFonts.assistant(color: AppColors.ink3, fontSize: 15),
        ),
        textStyle: WidgetStatePropertyAll(
          GoogleFonts.assistant(color: AppColors.ink, fontSize: 15),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 14),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.terracotta,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: GoogleFonts.assistant(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
