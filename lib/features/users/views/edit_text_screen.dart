import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

enum UserProfileTextItem {
  name("Name", 1),
  bio("Bio", 4),
  link("Link", 1);

  const UserProfileTextItem(this.title, this.row);
  final String title;
  final int row;
}

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserProfileTextItem item;

  const EditProfileScreen({super.key, required this.item});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _textController;
  late String _text;

  @override
  void initState() {
    super.initState();
    final profile =
        ref.read(usersProvider.notifier).state.value as UserProfileModel;

    switch (widget.item) {
      case UserProfileTextItem.name:
        _text = profile.name;
        break;
      case UserProfileTextItem.bio:
        _text = profile.bio;
        break;
      case UserProfileTextItem.link:
        _text = profile.link;
        break;
    }
    _textController = TextEditingController(text: _text);

    _textController.addListener(
      () {
        setState(() {
          _text = _textController.text;
        });
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String? _textValid() {
    if (widget.item == UserProfileTextItem.name) {
      if (_text.isEmpty) {
        return "${widget.item.title} can not be empty.";
      }
    }
    return null;
  }

  void _onSave() {
    if (_textValid() != null) {
      return;
    }
    UserProfileModel profile =
        ref.read(usersProvider.notifier).state.value as UserProfileModel;

    switch (widget.item) {
      case UserProfileTextItem.name:
        profile = profile.copyWith(name: _text);
        break;
      case UserProfileTextItem.bio:
        profile = profile.copyWith(bio: _text);
        break;
      case UserProfileTextItem.link:
        profile = profile.copyWith(link: _text);
        break;
    }
    ref
        .read(usersProvider.notifier)
        .updateUserProfileRepository({widget.item.name: _text});
    ref.read(usersProvider.notifier).changeProfile(profile);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _onSave,
            child: Text(
              "저장",
              style: _textValid() == null
                  ? null
                  : TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.size12),
        child: Column(
          children: [
            SizedBox(
              child: TextField(
                maxLines: widget.item.row,
                minLines: widget.item.row,
                controller: _textController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  errorText: _textValid(),
                  hintText: widget.item.title,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
