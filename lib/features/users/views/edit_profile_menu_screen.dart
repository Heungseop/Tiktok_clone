import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/users/views/edit_text_screen.dart';
import 'package:tiktok_clone/features/users/views/widgets/avatar.dart';

class EditProfileMenuScreen extends ConsumerWidget {
  const EditProfileMenuScreen({super.key});

  void _onMenuTab(BuildContext context, UserProfileTextItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          item: item,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Scaffold(
            appBar: AppBar(
              title: const Text("Edit Profile"),
              centerTitle: true,
            ),
            body: ListView(
              children: [
                Gaps.v16,
                Column(
                  children: [
                    Avatar(
                      name: data.name,
                      hasAvatar: data.hasAvatar,
                      uid: data.uid,
                    ),
                  ],
                ),
                ListTile(
                  onTap: () => _onMenuTab(context, UserProfileTextItem.name),
                  title: const Text("Name"),
                  trailing: SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(20 < data.name.length
                            ? "${data.name.substring(0, 20)}..."
                            : data.name),
                        Gaps.h10,
                        const FaIcon(
                          FontAwesomeIcons.chevronRight,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
                ListTile(
                  onTap: () => _onMenuTab(context, UserProfileTextItem.bio),
                  title: const Text("BIO"),
                  trailing: SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (0 < data.bio.indexOf("\n"))
                          const Text('...')
                        else
                          Text(20 < data.bio.length
                              ? "${data.bio.substring(0, 20)}..."
                              : data.bio),
                        Gaps.h10,
                        const FaIcon(
                          FontAwesomeIcons.chevronRight,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
                ListTile(
                  onTap: () => _onMenuTab(context, UserProfileTextItem.link),
                  title: const Text("Link"),
                  trailing: SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(20 < data.link.length
                            ? "${data.link.substring(0, 20)}..."
                            : data.link),
                        Gaps.h10,
                        const FaIcon(
                          FontAwesomeIcons.chevronRight,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}
