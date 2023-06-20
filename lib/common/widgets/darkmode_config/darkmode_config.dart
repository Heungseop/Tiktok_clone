import 'package:flutter/widgets.dart';

// final darkModeConfig = ValueNotifier(false);

class DarkModeConfig extends ChangeNotifier {
  bool isDark = false;

  void toggleIsDark() {
    isDark = !isDark;
    notifyListeners();
  }
}
