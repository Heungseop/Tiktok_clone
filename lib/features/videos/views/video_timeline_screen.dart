import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/view_models/timeline_view_model.dart';
import 'package:tiktok_clone/features/videos/widgets/viedo_post.dart';

class VideoTimeLineScreen extends ConsumerStatefulWidget {
  const VideoTimeLineScreen({super.key});

  @override
  VideoTimeLineScreenState createState() => VideoTimeLineScreenState();
}

class VideoTimeLineScreenState extends ConsumerState<VideoTimeLineScreen> {
  int _itemCount = 0;

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
      ref.watch(timelineProvider.notifier).fetchNextPage();
    }

    setState(() {});
  }

  void _onVideoFinished() {
    return;
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

  Future<void> _onRefresh() {
    return Future.delayed(const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    // TimelineViewModel의 build에서 api를 fetch해온뒤 화면을 그린다.
    return ref.watch(timelineProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              "Could not load videos : $error",
              // style: const TextStyle(color: Colors.white),
            ),
          ),
          data: (videos) {
            _itemCount = videos.length;
            return RefreshIndicator(
              onRefresh: _onRefresh,
              displacement: 50,
              // edgeOffset: 21,
              color: Theme.of(context).primaryColor,
              child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: videos.length,
                  onPageChanged: _onPageChaged,
                  itemBuilder: (context, index) {
                    final videoData = videos[index];
                    return VideoPost(
                      onVideoFinished: _onVideoFinished,
                      index: index,
                      videoData: videoData,
                    );
                  }

                  //  => VideoPost(
                  //       onVideoFinished: _onVideoFinished,
                  //       index: index,
                  //     )
                  ),
            );
          },
        );
  }
}
