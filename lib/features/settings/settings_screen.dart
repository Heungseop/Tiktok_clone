import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/breakepoints.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';

class SettingsScreen extends ConsumerWidget {
  // ConsumerWidget => riverpod으로 부터 provide를 공급받기위한 stateless 위젯
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ref : provide들을 가져오거나 읽을 수 있는 레퍼런스
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
                  value: ref.watch(playbackConfigProvider).muted,
                  onChanged: (value) =>
                      ref.read(playbackConfigProvider.notifier).setMuted(value),
                ),
                SwitchListTile.adaptive(
                  title: const Text("Auto Play"),
                  subtitle:
                      const Text("Video will start Playing automatically."),
                  value: ref.watch(playbackConfigProvider).autoplay,
                  onChanged: (value) => ref
                      .read(playbackConfigProvider.notifier)
                      .setAutoPlay(value),
                ),
                CheckboxListTile(
                  value: false,
                  onChanged: (value) {},
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

                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

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
                            onPressed: () {
                              ref.read(authRepo).signOut();
                              context.go("/");
                            },
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
