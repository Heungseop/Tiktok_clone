import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

// dismissible 위젯만 사용하면 사용자가 dismiss했을 때 화면에서만 없어지고 실제로는 위젯트리에 남아있기때문에
// 소스 변경 후 핫 리로드 되면 에러가 난다 이를 위해
// 1. stateless -> stateful 변경
// 2. _notifications 생성
// 3. Dismissible 을 리스트 for루프로 그려줌
// 4. onDismissed 에서 삭제된 아이템을 리스트에서도 remove

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  //SingleTickerProviderStateMixin 는 화면에 그려주는 시계같은 존재이고
  // 위젯이 트리에 없을 때 리소스를 낭비하지 않게 함.
  final List<String> _notifications = List.generate(20, (index) => "${index}h");
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  // late 키워드가 있으면 this(혹은 instance 멤버)를 참조할 수 있게 된다. 원래는 initState에서 초기화 해야한다.

  // 애니메이션을 주기 위한 방법으로
  // 첫번 째는 video_post.dart 에서와 같이
  // _animationController = AnimationController(
  //   vsync: this, // 위젯이 위젯 tree에 있을 때만 Ticker를 유지시켜준다.
  //   lowerBound: 1.0,
  //   upperBound: 1.5,
  //   value: 1.5,
  //   duration: _animationDuration,
  // );
  // 컨트롤러에 바운드를 주고 event listner를 통해 setState를 통해 빌드 해주는 방법
  // 두번째로 직접 setState하는게 아닌 AnimatedBuilder를 사용 하는방법
  // 세번째가 지금과같이 Animation을 사용하는 방법
  late final Animation<double> _animation =
      Tween(begin: 0.0, end: -0.5).animate(_animationController);

  void _onDismissed(String noti) {
    setState(() {
      _notifications.remove(noti);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTitleTap() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: _onTitleTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("All activity"),
              Gaps.h2,
              RotationTransition(
                turns: _animation,
                child: const FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: Sizes.size14,
                ),
              )
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size12),
            child: Text(
              "New",
              style: TextStyle(
                fontSize: Sizes.size14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Gaps.v14,
          for (String noti in _notifications)
            Dismissible(
              key: Key(noti),
              onDismissed: (direction) => _onDismissed(noti),
              background: Container(
                alignment: Alignment.centerLeft,
                color: Colors.green,
                child: const Padding(
                  padding: EdgeInsets.only(
                    left: Sizes.size10,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.checkDouble,
                    color: Colors.white,
                    size: Sizes.size32,
                  ),
                ),
              ),
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                color: Colors.red,
                child: const Padding(
                  padding: EdgeInsets.only(
                    right: Sizes.size10,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.trashCan,
                    color: Colors.white,
                    size: Sizes.size32,
                  ),
                ),
              ),
              child: ListTile(
                minVerticalPadding: Sizes.size16,
                // contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: Sizes.size52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: Sizes.size1,
                    ),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.bell,
                      color: Colors.black,
                    ),
                  ),
                ),
                title: RichText(
                  text: TextSpan(
                    text: "Account updates:",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: Sizes.size16,
                    ),
                    children: [
                      const TextSpan(
                        text: " Upload longer videos",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: noti,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: const FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: Sizes.size16,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
