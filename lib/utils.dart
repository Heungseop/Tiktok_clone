import 'package:flutter/material.dart';

bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;
    
// bool isDarkMode(BuildContext context) => context.watch<DarkModeConfig>().isDark;
