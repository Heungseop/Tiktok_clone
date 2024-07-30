import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/features/users/view_models/avatar_view_model.dart';

class Avatar extends ConsumerWidget {
  final String name;
  final String uid;
  final bool hasAvatar;
  final bool isEditable;
  final double size;

  const Avatar({
    super.key,
    required this.name,
    required this.hasAvatar,
    required this.uid,
    this.isEditable = true,
    this.size = 50,
  });

  Future<void> _onAvatarTap(WidgetRef ref) async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );

    if (xfile != null) {
      final file = File(xfile.path);
      ref.read(avatarProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    return GestureDetector(
      onTap: !isEditable || isLoading ? null : () => _onAvatarTap(ref),
      child: isLoading
          ? Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const CircularProgressIndicator.adaptive(),
            )
          : CircleAvatar(
              backgroundColor: Colors.teal,
              radius: size,
              foregroundImage: hasAvatar
                  ? NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-heungg.appspot.com/o/avatars%2F$uid?alt=media&token=aefac226-27ec-4331-a326-caf9e7d216ee&version=${DateTime.now().toString()}")
                  : null,
              child: hasAvatar ? null : Text(name),
            ),
    );
  }
}
