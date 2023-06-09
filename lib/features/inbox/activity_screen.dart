import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

// dismissible 위젯만 사용하면 사용자가 dismiss했을 때 화면에서만 없어지고 실제로는 위젯트리에 남아있기때문에
// 소스 변경 후 핫 리로드 되면 에러가 난다 이를 위해
// 1. stateless -> stateful 변경
// 2. _notifications 생성
// 3. Dismissible 을 리스트 for루프로 그려줌
// 4. onDismissed 에서 삭제된 아이템을 리스트에서도 remove

class ActivityScreen extends StatefulWidget {
  static const String routeName = "activity";
  static const String routeURL = "/activity";
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
  late final Animation<double> _arrowAnimation =
      Tween(begin: 0.0, end: -0.5).animate(_animationController);

  final List<Map<String, dynamic>> _tabs = [
    {
      "title": "All activity",
      "icon": FontAwesomeIcons.solidMessage,
    },
    {
      "title": "Likes",
      "icon": FontAwesomeIcons.solidHeart,
    },
    {
      "title": "Comments",
      "icon": FontAwesomeIcons.solidComments,
    },
    {
      "title": "Mentions",
      "icon": FontAwesomeIcons.at,
    },
    {
      "title": "Followers",
      "icon": FontAwesomeIcons.solidUser,
    },
    {
      "title": "From TikTok",
      "icon": FontAwesomeIcons.tiktok,
    }
  ];

  late final Animation<Offset> _panelAnimation = Tween(
    begin: const Offset(0, -1), // 비율. .5이면 해당 축의 50%이동
    end: const Offset(0, 0),
  ).animate(_animationController); // 동일한 컨트롤러 사용 아마도 동시에 일어나는 하나의 행위라서 그런듯

  late final Animation<Color?> _barrierAnimation = ColorTween(
    begin: Colors.transparent,
    end: Colors.black38,
  ).animate(_animationController);

  bool _showBarrier = false;

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

  void _toggleTitleAnimations() async {
    if (_animationController.isCompleted) {
      await _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _showBarrier = !_showBarrier;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: _toggleTitleAnimations,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("All activity"),
              Gaps.h2,
              RotationTransition(
                turns: _arrowAnimation,
                child: const FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: Sizes.size14,
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
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
                        color: isDark ? Colors.grey.shade800 : Colors.white,
                        border: Border.all(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade400,
                          width: Sizes.size1,
                        ),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.bell,
                          // color: Colors.black,
                        ),
                      ),
                    ),
                    title: RichText(
                      text: TextSpan(
                        text: "Account updates:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? null : Colors.black,
                          fontSize: Sizes.size16,
                        ),
                        children: [
                          const TextSpan(
                            text: " Upload longer videos ",
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
          if (_showBarrier)
            AnimatedModalBarrier(
              color: _barrierAnimation,
              dismissible: true, // 배리어 클릭 시 start로 변경해줌
              onDismiss: _toggleTitleAnimations,
            ),
          SlideTransition(
            position: _panelAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(
                    Sizes.size5,
                  ),
                  bottomRight: Radius.circular(
                    Sizes.size5,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var tab in _tabs)
                    ListTile(
                      title: Row(
                        children: [
                          Icon(
                            tab["icon"],
                            // color: Colors.black,
                            size: Sizes.size16,
                          ),
                          Gaps.h20,
                          Text(
                            tab["title"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
