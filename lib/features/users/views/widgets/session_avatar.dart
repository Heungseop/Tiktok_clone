import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/features/users/view_models/avatar_view_model.dart';

class SessionAvatar extends ConsumerWidget {
  // final String name;
  // final String uid;
  // final bool hasAvatar;

  // const SessionAvatar({
  //   super.key,
  //   required this.name,
  //   required this.hasAvatar,
  //   required this.uid,
  // });

  // Future<void> _onAvatarTap(WidgetRef ref) async {
  //   final xfile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 40,
  //     maxHeight: 150,
  //     maxWidth: 150,
  //   );

  //   if (xfile != null) {
  //     final file = File(xfile.path);
  //     ref.read(avatarProvider.notifier).uploadAvatar(file);
  //   }
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) =>  Avatar(
                                  uid: data.uid,
                                  name: data.name,
                                  hasAvatar: data.hasAvatar),

          );
  }
}
