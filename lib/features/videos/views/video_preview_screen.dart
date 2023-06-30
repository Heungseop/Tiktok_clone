import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/view_models/upload_video_view_model.dart';
import 'package:tiktok_clone/features/videos/views/upload_video_description_screen.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends ConsumerStatefulWidget {
  final XFile video;
  final bool isPicked;

  const VideoPreviewScreen({
    super.key,
    required this.video,
    required this.isPicked,
  });

  @override
  VideoPreviewScreenState createState() => VideoPreviewScreenState();
}

class VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
  late final VideoPlayerController _videoPlayerController;
  bool savedVideo = false;

  Future<void> _initVideo() async {
    _videoPlayerController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _initVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _saveToGallery() async {
    if (savedVideo) {
      return;
    }

    GallerySaver.saveVideo(widget.video.path, albumName: "TikTok Clone!");

    savedVideo = true;
    setState(() {});
  }

  void _onUploadPressed() {
    ref.read(uploadVideoProvider.notifier).uploadVideo(
          File(widget.video.path),
          context,
        );
  }

  void _onUploadNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadVideoDescriptionScreen(video: widget.video),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview video"),
        actions: [
          if (!widget.isPicked)
            IconButton(
              onPressed: _saveToGallery,
              icon: FaIcon(savedVideo
                  ? FontAwesomeIcons.check
                  : FontAwesomeIcons.download),
            ),
          IconButton(
            onPressed: ref.watch(uploadVideoProvider).isLoading
                ? () {}
                : _onUploadPressed,
            icon: ref.watch(uploadVideoProvider).isLoading
                ? const CircularProgressIndicator()
                : const FaIcon(FontAwesomeIcons.cloudArrowUp),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_videoPlayerController.value.isInitialized)
            Positioned(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              top: 40,
              left: 0,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      child: Transform.translate(
                        offset: Offset(
                            0, (-MediaQuery.of(context).size.height * 0.4 / 2)),
                        child: AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: VideoPlayer(_videoPlayerController))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: Sizes.size40,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: _onUploadPressed,
                  child: Container(
                    width: Sizes.size80,
                    height: Sizes.size80,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.check,
                        color: Colors.black,
                        size: Sizes.size40,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: _onUploadNext,
                      child: Container(
                          height: Sizes.size44,
                          width: Sizes.size44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade900),
                          child: const FaIcon(
                            FontAwesomeIcons.arrowRight,
                            color: Colors.white,
                          )),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
