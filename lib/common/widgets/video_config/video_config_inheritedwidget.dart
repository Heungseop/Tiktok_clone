import 'package:flutter/widgets.dart';

// InheritedWidget 은
// final videoConfig = VideoConfigData.of(context);
// 와 같은 방식으로 하위 모든 트리에 데이터를 전달 할 수 있지만
// update는 불가하므로 아래와 같이 InheritedWidget으로 child를 감싸는 StatefulWidget을 쌍으로 만들어서
// 실제 사용 시엔 StatefulWidget을 만들고 InheritedWidget.of(context).~~~ 방식으로 사용하면
// StatefulWidget이 값이 바뀌면 InheritedWidget 자체를 다시 생성하는 방식으로 update와 같은 효과를 준다.
class VideoConfigData_remove extends InheritedWidget {
  final bool autoMute;

  // InheritedWidget.of(context).toggleMuted() 처럼 하위위젯에서 사용하기 위해 메서드를 보관
  final void Function() toggleMuted;

  const VideoConfigData_remove({
    super.key,
    required super.child,
    required this.autoMute,
    required this.toggleMuted,
  });

  static VideoConfigData_remove of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<VideoConfigData_remove>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // 위젯을 리빌드할지 결정한다.
    return true;
  }
}

class VideoConfig_remove extends StatefulWidget {
  final Widget child;
  const VideoConfig_remove({super.key, required this.child});

  @override
  State<VideoConfig_remove> createState() => _VideoConfig_removeState();
}

class _VideoConfig_removeState extends State<VideoConfig_remove> {
  bool autoMute = false;
  void toggleMuted() {
    setState(() {
      autoMute = !autoMute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VideoConfigData_remove(
      toggleMuted: toggleMuted,
      autoMute: autoMute,
      child: widget.child,
    );
  }
}
