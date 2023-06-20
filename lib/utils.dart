import 'package:flutter/material.dart';

import 'common/widgets/darkmode_config/darkmode_config.dart';

// bool isDarkMode(BuildContext context) =>
//     MediaQuery.of(context).platformBrightness == Brightness.dark;
bool isDarkMode(BuildContext context) => darkModeConfig.value;
