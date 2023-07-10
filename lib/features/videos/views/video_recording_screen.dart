import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/views/video_preview_screen.dart';
import 'package:tiktok_clone/features/videos/widgets/flash_function_icon.dart';

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = "postVideo";
  static const String routeURL = "/upload";

  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  //두개이상의 애니메이션 컨트롤러를 사용하기 때문에 두개 이상의 Ticker가 필요하다
  bool _hasPermission = false;
  late CameraController _cameraController;
  bool _isSelfieMode = false;
  late FlashMode _flashMode;

  late double maxZoomLevel;
  late double minZoomLevel;
  late double currentZoomLevel;

  late final bool _noCamera = kDebugMode; //kDebugMode; //&& Platform.isIOS;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late final Animation<double> _buttonAnimation = Tween(
    begin: 1.0,
    end: 1.3,
  ).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print("##### didChangeAppLifecycleState state : $state");
    // App state changed before we got the chance to initialize.
    if (!_hasPermission ||
        _noCamera ||
        !_cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    // print("#### cameras : $cameras");
    if (cameras.isEmpty) {
      return;
    }
    _cameraController = CameraController(
        cameras[_isSelfieMode ? 1 : 0], ResolutionPreset.ultraHigh);

    await _cameraController.initialize();

    await _cameraController.prepareForVideoRecording(); //ios만을 위한 메서드 (싱크 문제처리)

    _flashMode = _cameraController.value.flashMode;

    maxZoomLevel = await _cameraController.getMaxZoomLevel();
    minZoomLevel = await _cameraController.getMinZoomLevel();
    currentZoomLevel = minZoomLevel;

    // print("maxZoomLevel  : $maxZoomLevel");
    // print("minZoomLevel  : $minZoomLevel");

    setState(() {});
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    // android 는 권한동의하지 않아도 다시 요청할 수 있고
    // IOS 는 한번 거절하면 사용자가 직접 설정에 들어가서 해야한다 ->isPermanentlyDenied 를 말하는것 같음
    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    print("###initState _noCamera : $_noCamera");
    if (!_noCamera) {
      initPermissions();
    } else {
      setState(() {
        _hasPermission = true;
      });
    }
    print("###initState _hasPermission : $_hasPermission");
    //유저가 애플리케이션을 벗어나는 경우를 탐지하기위해 사용
    WidgetsBinding.instance.addObserver(this);

    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      // print("#### status : $status");
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
      setState(() {});
    });
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _startRecording(TapDownDetails _) async {
    if (!_noCamera) {
      if (_cameraController.value.isRecordingVideo) return;

      await _cameraController.startVideoRecording();
    }

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_noCamera) {
      if (!_cameraController.value.isRecordingVideo) return;
    }

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    if (!_noCamera) {
      final file = await _cameraController.stopVideoRecording();
      // print("#### ${file.name}");
      // print("#### ${file.path}");

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPreviewScreen(
            video: file,
            isPicked: false,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _buttonAnimationController.dispose();
    if (!_noCamera) {
      _cameraController.dispose();
    }

    super.dispose();
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video == null) {
      return;
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: true,
        ),
      ),
    );
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) async {
    if (_noCamera) {
      return;
    }

    if (currentZoomLevel == minZoomLevel && 0 < details.delta.direction ||
        currentZoomLevel == maxZoomLevel && details.delta.direction < 0) {
      return;
    }

    currentZoomLevel -= (details.delta.dy / 100);

    if (currentZoomLevel < minZoomLevel) currentZoomLevel = minZoomLevel;
    if (maxZoomLevel < currentZoomLevel) currentZoomLevel = maxZoomLevel;

    _cameraController.setZoomLevel(currentZoomLevel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // _hasPermission = false;
    print("### build _hasPermission : $_hasPermission");
    return Scaffold(
        // backgroundColor: Colors.black,
        body: SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You don't have permissions. Please set from Settings.",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                      onPressed: initPermissions,
                      child: const Text("go to Settings."))
                ],
              )
            : !_noCamera && !_cameraController.value.isInitialized
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Initializing..."),
                      Gaps.v20,
                      CircularProgressIndicator.adaptive()
                    ],
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      if (!_noCamera && _cameraController.value.isInitialized)
                        CameraPreview(_cameraController),
                      const Positioned(
                        top: Sizes.size20,
                        left: Sizes.size20,
                        child: CloseButton(),
                      ),
                      if (!_noCamera)
                        Positioned(
                          top: Sizes.size20,
                          right: Sizes.size20,
                          child: Column(
                            children: [
                              IconButton(
                                color: Colors.grey,
                                onPressed: _toggleSelfieMode,
                                icon: const Icon(Icons.cameraswitch),
                              ),
                              Gaps.v10,
                              FlashFunctionIcon(
                                flashMode: FlashMode.off,
                                selectedFlashMode: _flashMode,
                                onTap: _setFlashMode,
                              ),
                              FlashFunctionIcon(
                                flashMode: FlashMode.always,
                                selectedFlashMode: _flashMode,
                                onTap: _setFlashMode,
                              ),
                              FlashFunctionIcon(
                                flashMode: FlashMode.auto,
                                selectedFlashMode: _flashMode,
                                onTap: _setFlashMode,
                              ),
                              FlashFunctionIcon(
                                flashMode: FlashMode.torch,
                                selectedFlashMode: _flashMode,
                                onTap: _setFlashMode,
                              ),
                            ],
                          ),
                        ),
                      Positioned(
                        bottom: Sizes.size40,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            const Spacer(),
                            GestureDetector(
                              onVerticalDragUpdate: _onVerticalDragUpdate,
                              onTapDown: _startRecording,
                              onTapUp: (details) => _stopRecording(),
                              onVerticalDragEnd: (details) => _stopRecording(),
                              child: ScaleTransition(
                                scale: _buttonAnimation,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: Sizes.size80 + Sizes.size14,
                                      height: Sizes.size80 + Sizes.size14,
                                      child: CircularProgressIndicator(
                                        color: Colors.red.shade400,
                                        strokeWidth: Sizes.size6,
                                        value:
                                            _progressAnimationController.value,
                                      ),
                                    ),
                                    Container(
                                      width: Sizes.size80,
                                      height: Sizes.size80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: _onPickVideoPressed,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.image,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
      ),
    ));
  }
}
