import 'package:flutter/widgets.dart';

class VideoConfig extends InheritedWidget {
  final bool autoMute = false;

  const VideoConfig({super.key, required super.child});

  static VideoConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VideoConfig>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // 위젯을 리빌드할지 결정한다.
    return true;
  }
}
