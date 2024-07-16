import 'package:chatdo/utils/app_colors.dart';
import 'package:chatdo/utils/themes/custom_elebutton_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme() => ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
        textTheme: GoogleFonts.openSansTextTheme(),
        elevatedButtonTheme: CusEleButtonTheme.lightEleButtonTheme(),
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
              enableFeedback: false,
              textStyle: WidgetStatePropertyAll(
                  TextStyle(color: AppColors.appColorMain))),
        ),
      );
}
