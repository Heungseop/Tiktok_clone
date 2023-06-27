import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;

// bool isDarkMode(BuildContext context) => context.watch<DarkModeConfig>().isDark;

void showFirebaseError(BuildContext context, Object? error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    showCloseIcon: true,
    // duration: const Duration(seconds: 10),
    content:
        Text((error as FirebaseException).message ?? "Something wen't wrong."),
  ));
}
