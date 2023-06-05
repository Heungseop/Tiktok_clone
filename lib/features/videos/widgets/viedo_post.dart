import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/widgets/video_comments.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished; //StatefulWidget 에 선언해야 함 아래의 State 가 아닌
  final int index;
  const VideoPost(
      {super.key, required this.onVideoFinished, required this.index});

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
// SingleTickerProviderStateMixin => 위젯이 화면에 보이는 동안에만 동작하도록 하는 ticker 제공
// ticker가 매 프레임마다 tick을 실행하여 화면을 갱신한다.

  // final VideoPlayerController _videoPlayerController =
  //     VideoPlayerController.asset("assets/videos/jiwoo.mov");
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/jiyul.mov");
  // final VideoPlayerController _videoPlayerController =
  //     VideoPlayerController.network("dataSource")
  bool _isPaused = false;
  final Duration _animationDuration = const Duration(milliseconds: 200);
  final _cutContentDetailCnt = 25;
  // final String _contentDetail = "#NEWBORN #BABY ";
  final String _contentDetail =
      "#NEWBORN #BABY #cute #jiyul #so_cute #0327 #ILoveYou #LovelyBaby #daughter";
  String _shoingContentDetail = "";
  bool _isContentDetailSpread = false;

  late final AnimationController _animationController;

  void _onVideoChange() {
    if (_videoPlayerController.value.duration ==
        _videoPlayerController.value.position) {
      widget.onVideoFinished();
    }
  }

  void _initVideoPlayer() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    _videoPlayerController.addListener(_onVideoChange);
    setState(() {});
  }

  void _initContentDetailVariables() {
    // _isContentDetailSpread = _cutContentDetailCnt < _contentDetail.length;
    _shoingContentDetail = _cutContentDetailCnt < _contentDetail.length
        ? _contentDetail.substring(0, _cutContentDetailCnt)
        : _contentDetail;
  }

  @override
  void initState() {
    super.initState();

    _initContentDetailVariables();
    _initVideoPlayer();

    _animationController = AnimationController(
      vsync: this, // 위젯이 위젯 tree에 있을 때만 Ticker를 유지시켜준다.
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );

    // 컨트롤러가 변화할 때 마다 setState로 화면을 다시 그려줌
    // _animationController.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    // 0~1 까지 화면이 표시된 비율을 리턴해줌
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }

    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onSeemorePressed() {
    _shoingContentDetail = _isContentDetailSpread
        ? _contentDetail.substring(0, _cutContentDetailCnt)
        : _contentDetail;
    _isContentDetailSpread = !_isContentDetailSpread;
    setState(() {});
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }

    // await 하면 팝업이 닫힐 때 까지 기다림
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // transparent 를 줌으로써 스캐폴드가 배경이 됨
      context: context,
      builder: (context) => const VideoComments(),
    );

    _onTogglePause();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  // AnimatedBuilder animation 컨트롤러의 변화를 감지해 builder 로 변화할때마다 다시 그려줌
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "@Heungg",
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v10,
                const Text(
                  "우리 귀여운 지율이좀 보세요~",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    color: Colors.white,
                  ),
                ),
                Gaps.v5,
                SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          strutStyle: const StrutStyle(fontSize: 16.0),
                          text: TextSpan(
                            style: const TextStyle(color: Colors.white),
                            children: [
                              TextSpan(
                                text: _shoingContentDetail,
                              ),
                              if (_cutContentDetailCnt < _contentDetail.length)
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _onSeemorePressed,
                                  text: _isContentDetailSpread
                                      ? "  ...Close"
                                      : "  ...See more",
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 27,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/13977411?v=4"),
                  child: Text('heungg'),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: "2.9M",
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentsTap(context),
                  child: const VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: "33K",
                  ),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: "Share",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
