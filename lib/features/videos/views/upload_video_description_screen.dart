import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widgets/main_button.dart';
import 'package:tiktok_clone/features/videos/view_models/upload_video_view_model.dart';

class UploadVideoDescriptionScreen extends ConsumerStatefulWidget {
  final XFile video;
  const UploadVideoDescriptionScreen({super.key, required this.video});

  @override
  UploadVideoDescriptionScreenState createState() =>
      UploadVideoDescriptionScreenState();
}

class UploadVideoDescriptionScreenState
    extends ConsumerState<UploadVideoDescriptionScreen> {
  late final TextEditingController _descTextController;
  late final TextEditingController _titleTextController;
  late String _text;

  @override
  void initState() {
    super.initState();
    _descTextController = TextEditingController();
    _titleTextController = TextEditingController();

    // _descTextController.addListener(
    //   () {
    //     setState(() {
    //       _text = _descTextController.text;
    //     });
    //   },
    // );
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _descTextController.dispose();
    super.dispose();
  }

  void _onSave() {
    // UserProfileModel profile =
    //     ref.read(usersProvider.notifier).state.value as UserProfileModel;

    // ref
    //     .read(usersProvider.notifier)
    //     .updateUserProfileRepository({widget.item.name: _text});
    // ref.read(usersProvider.notifier).changeProfile(profile);

    // Navigator.of(context).pop();

    ref.read(uploadVideoProvider.notifier).uploadVideo(
          File(widget.video.path),
          context,
          title: _titleTextController.text,
          description: _descTextController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Post"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(Sizes.size12),
          child: Column(
            children: [
              SizedBox(
                child: TextField(
                  controller: _titleTextController,
                  decoration: InputDecoration(
                    hintText: "Title",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      maxLines: 5,
                      minLines: 5,
                      controller: _descTextController,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        hintText: "Share your thoughts within 2200 characters",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   width: 100,
                  //   child: Center(image),
                  // )
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox.expand(
            child: Row(children: [
              Flexible(
                  child: MainButton(
                text: "Drafts",
                backColor: Colors.grey.shade200,
              )),
              Gaps.h10,
              Flexible(
                  child: MainButton(
                text: "Post",
                onTap: (p0) => _onSave(),
              ))
            ]),
          ),
        ));
  }
}
