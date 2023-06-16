import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  bool _hasPermission = false;
  late CameraController _cameraController;
  bool _isSelfieMode = false;

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    print("#### cameras : $cameras");
    if (cameras.isEmpty) {
      return;
    }
    _cameraController = CameraController(
        cameras[_isSelfieMode ? 1 : 0], ResolutionPreset.ultraHigh);

    await _cameraController.initialize();
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
      initCamera();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.black,
        body: SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission || !_cameraController.value.isInitialized
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
                  CameraPreview(_cameraController),
                  Positioned(
                    top: Sizes.size20,
                    left: Sizes.size20,
                    child: IconButton(
                      color: Colors.grey,
                      onPressed: _toggleSelfieMode,
                      icon: const Icon(Icons.cameraswitch),
                    ),
                  )
                ],
              ),
      ),
    ));
  }
}
