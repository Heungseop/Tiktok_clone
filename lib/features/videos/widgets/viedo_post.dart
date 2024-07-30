import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/view_models/video_post_view_models.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/widgets/video_comments.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends ConsumerStatefulWidget {
  final Function onVideoFinished; //StatefulWidget 에 선언해야 함 아래의 State 가 아닌
  final VideoModel videoData;
  final int index;
  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.videoData,
    required this.index,
  });

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
// SingleTickerProviderStateMixin => 위젯이 화면에 보이는 동안에만 동작하도록 하는 ticker 제공
// ticker가 매 프레임마다 tick을 실행하여 화면을 갱신한다.

  // final VideoPlayerController _videoPlayerController =
  //     VideoPlayerController.asset("assets/videos/jiwoo.mov");
  // final VideoPlayerController _videoPlayerController =
  //     VideoPlayerController.asset("assets/videos/jiyul.mov");
  late final VideoPlayerController _videoPlayerController =
      VideoPlayerController.network(widget.videoData.fileUrl);
  bool _isPaused = false;
  final Duration _animationDuration = const Duration(milliseconds: 200);
  final _cutContentDetailCnt = 25;
  // final String _contentDetail = "#NEWBORN #BABY ";
  final String _contentDetail =
      "#NEWBORN #BABY #cute #jiyul #so_cute #0327 #ILoveYou #LovelyBaby #daughter";
  String _shoingContentDetail = "";
  bool _isContentDetailSpread = false;

  late final AnimationController _animationController;
  late bool _isMute;
  late bool _isLiked = false;

  void _onVideoChange() {
    if (_videoPlayerController.value.duration ==
        _videoPlayerController.value.position) {
      widget.onVideoFinished();
    }
  }

  void _onLikeTap() {
    ref.read(videoPostProvider(widget.videoData.id).notifier).likeVideo();
    _isLiked ? widget.videoData.likes-- : widget.videoData.likes++;
    _isLiked = !_isLiked;
    setState(() {});
  }

  void _initVideoPlayer() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);

    // 웹에서는 소리가 있는 동영상을 바로 재생 시킬 수 없다. (브라우저 정책)
    // 아예 에러가 나버림..
    // if (kIsWeb) {
    //   await _videoPlayerController.setVolume(0);
    //   _isMute = true;
    // }

    _isLiked = await ref
        .read(videoPostProvider(widget.videoData.id).notifier)
        .isLikeVideo();

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
    // 영상소리 초기값 판단 우선순위
    // 1. 웹이면 무음
    // 2. 글로벌 셋팅값
    _isMute = kIsWeb || ref.read(playbackConfigProvider).muted;
    _adjust_isMute();

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

    //changeNotifier를 리슨하는 방법 2
    // videoConfig.addListener(() {
    //   setState(() {
    //     _autoMute = videoConfig.value;
    //   });
    // });

    // context
    //     .read<PlaybackConfigViewModel>()
    //     .addListener(_onPlaybackConfigChanged);
    // _onPlaybackConfigChanged();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onPlaybackConfigChanged() {
    // if (!mounted) return;

    // Provider
    // final muted = context.read<PlaybackConfigViewModel>().muted;

    // Riverpod
    // final muted = ref.read(playbackConfigProvider).muted;
    // ref.read(playbackConfigProvider.notifier).setMuted(!muted);

    // if (muted) {
    //   _videoPlayerController.setVolume(0);
    // } else {
    //   _videoPlayerController.setVolume(1);
    // }

    if (ref.watch(playbackConfigProvider).muted) {
      _isMute = true;
    }

    _adjust_isMute();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    // 사용자에게 보이지 않을 땐 이미 dispose된 상태이기 때문에 에러가 발생함.
    // mounted되지 않았으면 아무것도 하지 않음
    if (!mounted) return;

    // 0~1 까지 화면이 표시된 비율을 리턴해줌
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      // final autoplay = context.read<PlaybackConfigViewModel>().autoplay;
      if (ref.read(playbackConfigProvider).autoplay) {
        _videoPlayerController.play();
      }
      setState(() {
        _isPaused = !ref.read(playbackConfigProvider).autoplay;
      });
    }

    // 재생중이고 화면이 가려졌을 때 동영상 정지
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
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

  void _adjust_isMute() async {
    await _videoPlayerController.setVolume(_isMute ? 0 : 1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("@@@@ video post!!");

    ref.listen(playbackConfigProvider, (previous, next) {
      _onPlaybackConfigChanged();
    });

    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                // : Container(
                //     color: Colors.black,
                //   ),
                : Image.network(
                    widget.videoData.thumbnailUrl,
                    fit: BoxFit.cover,
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
            left: 20,
            top: 20,
            child: IconButton(
              onPressed: () {
                _isMute = !_isMute;
                _adjust_isMute();
              },
              // onPressed: () {
              //   context
              //       .read<PlaybackConfigViewModel>()
              //       .setMuted(!context.read<PlaybackConfigViewModel>().muted);
              // },
              icon: FaIcon(
                // watch => 값이 바뀌었을 때 notify 받는다는 뜻(read는 1회성)
                // context.watch<PlaybackConfigViewModel>().muted
                _isMute
                    ? FontAwesomeIcons.volumeOff
                    : FontAwesomeIcons.volumeHigh,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "@${widget.videoData.creator}",
                  style: const TextStyle(
                    fontSize: Sizes.size20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v10,
                Text(
                  widget.videoData.description,
                  style: const TextStyle(
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
                CircleAvatar(
                  radius: 27,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: widget.videoData.creatorHasAvatar
                      ? NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-heungg.appspot.com/o/avatars%2F${widget.videoData.creatorUid}?alt=media&token=aefac226-27ec-4331-a326-caf9e7d216ee")
                      : null,
                  child: Text(widget.videoData.creator),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: _onLikeTap,
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidHeart,
                    text: S.of(context).likeCount(widget.videoData.likes),
                    iconColor: _isLiked ? Colors.red : Colors.white,
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentsTap(context),
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: S.of(context).commentCount(widget.videoData.comments),
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
          // Positioned(
          //   top: 20,
          //   right: 4,
          //   child: GestureDetector(
          //     onTap: _onMuteTap,
          //     child: Container(
          //       // color: Colors.red,
          //       padding: const EdgeInsets.all(Sizes.size14),
          //       width: Sizes.size48,
          //       child: FaIcon(
          //         _isMute
          //             ? FontAwesomeIcons.volumeOff
          //             : FontAwesomeIcons.volumeHigh,
          //         color: Colors.white.withOpacity(.8),
          //         size: Sizes.size20,
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
