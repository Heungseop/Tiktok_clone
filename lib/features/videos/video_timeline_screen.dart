import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/widgets/viedo_post.dart';

class VideoTimeLineScreen extends StatefulWidget {
  const VideoTimeLineScreen({super.key});

  @override
  State<VideoTimeLineScreen> createState() => _VideoTimeLineScreenState();
}

class _VideoTimeLineScreenState extends State<VideoTimeLineScreen> {
  int _itemCount = 4;

  final PageController _pageController = PageController();
  final Duration _scrollduration = const Duration(milliseconds: 250);
  final Curve _scrollCurve = Curves.linear;

  void _onPageChaged(int page) {
    _pageController.animateToPage(
      page,
      duration: _scrollduration,
      curve: _scrollCurve,
    );
    if (page == _itemCount - 1) {
      _itemCount += 4;
    }

    setState(() {});
  }

  void _onVideoFinished() {
    _pageController.nextPage(
      duration: _scrollduration,
      curve: _scrollCurve,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: _itemCount,
      onPageChanged: _onPageChaged,
      itemBuilder: (context, index) =>
          VideoPost(onVideoFinished: _onVideoFinished),
    );
  }
}
