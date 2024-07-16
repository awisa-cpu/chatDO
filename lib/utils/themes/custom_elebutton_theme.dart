import 'package:flutter/material.dart';

class CusEleButtonTheme {
  static ElevatedButtonThemeData lightEleButtonTheme() =>
      ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        enableFeedback: false,
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlue,
        disabledForegroundColor: Colors.grey,
        disabledBackgroundColor: Colors.grey,
        side: const BorderSide(color: Colors.lightBlue),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ));
}
