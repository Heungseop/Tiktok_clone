import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_clone/constants/breakepoints.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';

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
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: Breakpoints.sm),
            alignment: Alignment.bottomRight,
            child: ListView(
              children: [
                SwitchListTile.adaptive(
                  title: const Text("Mute video"),
                  subtitle: const Text("Video will be muted by default."),
                  value: context.watch<PlaybackConfigViewModel>().muted,
                  onChanged: (value) {
                    context.read<PlaybackConfigViewModel>().setMuted(value);
                  },
                ),
                SwitchListTile.adaptive(
                  title: const Text("Auto Play"),
                  subtitle:
                      const Text("Video will start Playing automatically."),
                  value: context.watch<PlaybackConfigViewModel>().autoplay,
                  onChanged: (value) {
                    context.read<PlaybackConfigViewModel>().setAutoPlay(value);
                  },
                ),

                //changeNotifier를 리슨하는 방법 1
                // ChangeNotifier 와 AnimatedBuilder를 함께 사용하라고 권장하고 있음
                // 애니메이션만 하는게 아니라 notify에도 사용됨
                // AnimatedBuilder(
                //   animation: videoConfig,
                //   builder: (context, child) => SwitchListTile.adaptive(
                //     title: const Text("Mute video"),
                //     subtitle: const Text("Videos will be muted by default."),
                //     value: videoConfig.value,
                //     onChanged: (value) {
                //       videoConfig.value = !videoConfig.value;
                //     },
                //   ),
                // ),
                //원한다면 ValueListenableBuilder도 아래와 같이 사용가능 동일한 기능을 한다.
                // SwitchListTile.adaptive(
                //   title: const Text("Dark Mode"),
                //   subtitle: const Text("setting dark mode."),
                //   value: context.watch<DarkModeConfig>().isDark,
                //   onChanged: (value) {
                //     context.read<DarkModeConfig>().toggleIsDark();
                //   },
                // ),

                // SwitchListTile.adaptive(
                //   title: const Text("Auto Mute"),
                //   subtitle: const Text("Videos will be muted by default."),
                //   value: VideoConfigData.of(context).autoMute,
                //   onChanged: (value) {
                //     VideoConfigData.of(context).toggleMuted();
                //   },
                // ),
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
                    if (kDebugMode) {
                      print(date);
                    }

                    if (!mounted) return;
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (!mounted) return;
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
                    if (kDebugMode) {
                      print("booking : $booking");
                    }
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
                ListTile(
                  title: const Text("Log out(iOS / Bottom)"),
                  textColor: Colors.red,
                  onTap: () {
                    showCupertinoModalPopup(
                      // modal > 바깥영역을 누르면 팝업이 닫힌다.
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                        title: const Text("Are you sure?"),
                        message: const Text("Please dont go"),
                        actions: [
                          CupertinoActionSheetAction(
                            isDefaultAction: true,
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Not log out"),
                          ),
                          CupertinoDialogAction(
                            onPressed: () => Navigator.of(context).pop(),
                            isDestructiveAction: true,
                            child: const Text("Yes Plz"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const AboutListTile()
              ],
            ),
          ),
        ));
  }
}
