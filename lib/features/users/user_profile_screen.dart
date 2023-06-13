import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakepoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settingsScreen.dart';
import 'package:tiktok_clone/features/users/widgets/persistent_tab_bar.dart';
import 'package:tiktok_clone/features/users/widgets/user_info_button.dart';
import 'package:tiktok_clone/features/users/widgets/user_info_card.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final double gridMarkerGap = 5;

  void _onGearPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
            // 중첩 스크롤문제를 해결하기 위해 CustomScrollView -> NestedScrollView로 변환
            // headerSliverBuilder는 슬리버로 이루어진 리스트를 반환해야한다.
            // CustomScrollView는 slivers리스트로 모두 받았지만
            // NestedScrollView는 headerSliverBuilder와 body가 나뉘어 있으므로 맞춰서 분리
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: const Text("Heungg"),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: _onGearPressed,
                      icon: const FaIcon(
                        FontAwesomeIcons.gear,
                        size: Sizes.size20,
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        Sizes.size18, 0, Sizes.size18, Sizes.size10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.teal,
                              radius: 50,
                              foregroundImage: NetworkImage(
                                  "https://avatars.githubusercontent.com/u/13977411?v=4"),
                              child: Text("Heungg"),
                            ),
                            Gaps.v12,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "@HeungSeop",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Sizes.size18,
                                  ),
                                ),
                                Gaps.h5,
                                FaIcon(
                                  FontAwesomeIcons.solidCircleCheck,
                                  size: Sizes.size16,
                                  color: Colors.blue.shade500,
                                ),
                              ],
                            ),
                            if (deviceWidth < Breakpoints.md) ...[
                              Gaps.v14,
                              const FolllowerCountBox(),
                              Gaps.v14,
                              const FollowButtonBox(),
                              Gaps.v14,
                              ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.9),
                                  child: const UserDetailBox()),
                              Gaps.v14,
                            ],
                          ],
                        ),
                        if (deviceWidth >= Breakpoints.md)
                          Column(
                            children: [
                              Row(
                                children: const [
                                  Gaps.h14,
                                  // Column(children: [],),
                                  FolllowerCountBox(),
                                  Gaps.h14,
                                  FollowButtonBox(),
                                ],
                              ),
                              Gaps.v14,
                              ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7),
                                  child: const UserDetailBox())
                            ],
                          )
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  // SliverToBoxAdapter 안에서 렌더 할 수 없음
                  pinned: true,
                  delegate:
                      PersistentTabBar(), // 스크롤 시 상단 고정을 위해 PersistentTabBar 생성
                )
              ];
            },
            body: TabBarView(
              children: [
                GridView.builder(
                    // keyboardDismissBehavior:
                    //     ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: 20,
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: deviceWidth > Breakpoints.lg ? 5 : 3,
                      crossAxisSpacing: Sizes.size2,
                      mainAxisSpacing: Sizes.size2,
                      childAspectRatio: 9 / 14,
                    ),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 9 / 14,
                            child: FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                placeholder: "assets/images/IMG_4793.jpg",
                                image:
                                    "https://source.unsplash.com/random/?${index + 1}"),
                          ),
                          if (index < 2)
                            Positioned(
                              // top left
                              top: gridMarkerGap,
                              left: gridMarkerGap,
                              child: Container(
                                padding: const EdgeInsets.all(Sizes.size2),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: const Text(
                                  "Pinned",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          if (index == 3)
                            Positioned(
                              top: gridMarkerGap,
                              right: gridMarkerGap,
                              child: const FaIcon(
                                FontAwesomeIcons.image,
                                color: Colors.white,
                                size: Sizes.size16,
                              ),
                            ),
                          Positioned(
                            bottom: gridMarkerGap,
                            left: gridMarkerGap,
                            child: Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.play,
                                  color: Colors.white,
                                  size: Sizes.size14,
                                ),
                                Gaps.h4,
                                Text(
                                  '${"${1.235 + index * 3.7 - (index * 1.4)}".substring(0, 3)} ${index % 2 == 1 ? 'M' : 'K'}',
                                  // "test",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                const Center(
                  child: Text("page2"),
                )
              ],
            )),
      ),
    );
  }
}

class UserDetailBox extends StatelessWidget {
  const UserDetailBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.size32,
          ),
          child: Text(
            "All highilghts and where to wahtch libe matches on FIFA+ I wonder how it would look. All highilghts and where to wahtch libe matches on FIFA+ I wonder how it would look. All highilghts and where to wahtch libe matches on FIFA+ I wonder how it would look.",
            textAlign: TextAlign.center,
          ),
        ),
        Gaps.v14,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            FaIcon(
              FontAwesomeIcons.link,
              size: Sizes.size12,
            ),
            Gaps.h4,
            Text(
              "https://github.com/Heungseop",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ],
    );
  }
}

class FollowButtonBox extends StatelessWidget {
  const FollowButtonBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UserInfoButton(
          onTap: () => print("##### ontap!!!!!!!!!!!!!!!!!!!!!!"),
          width: Sizes.size96 + Sizes.size48,
          color: Theme.of(context).primaryColor,
          content: const Text(
            "Follow",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Gaps.h6,
        const UserInfoButton(
          width: Sizes.size48,
          content: FaIcon(FontAwesomeIcons.youtube),
        ),
        Gaps.h6,
        const UserInfoButton(
          width: Sizes.size48,
          content: FaIcon(
            FontAwesomeIcons.caretDown,
            size: Sizes.size20,
          ),
        ),
      ],
    );
  }
}

class FolllowerCountBox extends StatelessWidget {
  const FolllowerCountBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.size48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          UserInfoCard(
            number: "97",
            infoName: "Following",
          ),
          UserInfoCardDivider(),
          UserInfoCard(
            number: "10M",
            infoName: "Followers",
          ),
          UserInfoCardDivider(),
          UserInfoCard(
            number: "149.3M",
            infoName: "Likes",
          ),
        ],
      ),
    );
  }
}

class UserInfoCardDivider extends StatelessWidget {
  const UserInfoCardDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      //특정 높이를 가진 부모가 필요함
      width: Sizes.size32,
      thickness: 1,
      color: Colors.grey.shade400,
      indent: Sizes.size14,
      endIndent: Sizes.size14,
    );
  }
}
