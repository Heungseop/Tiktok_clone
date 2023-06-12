import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;
  void _onNotificationsChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notifications = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          children: [
            SwitchListTile.adaptive(
              title: const Text("Enable notifications"),
              value: _notifications,
              onChanged: _onNotificationsChanged,
            ),
            // CupertinoSwitch(
            //     value: _notifications, onChanged: _onNotificationsChanged),
            // Switch(value: _notifications, onChanged: _onNotificationsChanged),
            // Checkbox(value: _notifications, onChanged: _onNotificationsChanged),
            CheckboxListTile(
              value: _notifications,
              onChanged: _onNotificationsChanged,
              title: const Text("Marketing Emails"),
              subtitle: const Text("We won't spam you."),
              activeColor: Colors.black,
            ),
            ListTile(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2030),
                );
                print("date : $date");

                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                print("time : $time");

                final booking = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                        data: ThemeData(
                          appBarTheme: const AppBarTheme(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                        ),
                        child: child!);
                  },
                );
                print("booking : $booking");
              },
              title: const Text("What is your birthday?"),
            ),
            ListTile(
              title: const Text("Log out(iOS)"),
              textColor: Colors.red,
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text("Are you sure?"),
                    content: const Text("Please dont go"),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("No"),
                      ),
                      CupertinoDialogAction(
                        onPressed: () => Navigator.of(context).pop(),
                        isDestructiveAction: true,
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Log out(Android)"),
              textColor: Colors.red,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    icon: const FaIcon(FontAwesomeIcons.plane),
                    title: const Text("Are you sure?"),
                    content: const Text("Please dont go"),
                    actions: [
                      IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const FaIcon(FontAwesomeIcons.car)),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
            ),
            const AboutListTile()
          ],
        ));
  }
}
