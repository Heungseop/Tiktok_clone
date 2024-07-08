import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakepoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/users/views/edit_profile_menu_screen.dart';
import 'package:tiktok_clone/features/users/views/edit_text_screen.dart';
import 'package:tiktok_clone/features/users/views/widgets/avatar.dart';
import 'package:tiktok_clone/features/users/views/widgets/persistent_tab_bar.dart';
import 'package:tiktok_clone/features/users/views/widgets/user_info_button.dart';
import 'package:tiktok_clone/features/users/views/widgets/user_info_card.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String tab;
  const UserProfileScreen({
    super.key,
    required this.tab,
  });

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final double gridMarkerGap = 5;

  void _onGearPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _editProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditProfileMenuScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Scaffold(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            body: SafeArea(
              child: DefaultTabController(
                initialIndex: widget.tab == "likes" ? 1 : 0,
                length: 2,
                child: NestedScrollView(
                    // 중첩 스크롤문제를 해결하기 위해 CustomScrollView -> NestedScrollView로 변환
                    // headerSliverBuilder는 슬리버로 이루어진 리스트를 반환해야한다.
                    // CustomScrollView는 slivers리스트로 모두 받았지만
                    // NestedScrollView는 headerSliverBuilder와 body가 나뉘어 있으므로 맞춰서 분리
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          title: Text(data.name),
                          centerTitle: true,
                          actions: [
                            IconButton(
                              onPressed: _editProfile,
                              icon: const FaIcon(
                                FontAwesomeIcons.penToSquare,
                                size: Sizes.size20,
                              ),
                            ),
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
                                    Gaps.v12,
                                    Avatar(
                                        uid: data.uid,
                                        name: data.name,
                                        hasAvatar: data.hasAvatar),
                                    Gaps.v12,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "@${data.name}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Sizes.size16,
                                            height: 1.1,
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
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9),
                                        child: UserDetailBox(
                                          user: data,
                                        ),
                                      ),
                                      Gaps.v10,
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
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7),
                                        child: UserDetailBox(
                                          user: data,
                                        ),
                                      )
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
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  deviceWidth > Breakpoints.lg ? 5 : 3,
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
                                        placeholder:
                                            "assets/images/IMG_4793.jpg",
                                        image:
                                          // "https://source.unsplash.com/random/?${index + 1}"),
                                            "https://scontent.cdninstagram.com/v/t51.29350-15/448166430_1531609421079811_8124474133834986911_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDE4MDAuc2RyLmYyOTM1MCJ9&_nc_ht=scontent.cdninstagram.com&_nc_cat=107&_nc_ohc=ju91ujnjHsgQ7kNvgFW1vzB&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzM4NzcyODM1NjYyNzIwMDAwNg%3D%3D.2-ccb7-5&oh=00_AYBmNbIo0asRXOQtUJbkNvMmdbW5jBswB_qgutuaVZy30g&oe=66914D1A&_nc_sid=10d13b"),
                                  ),
                                  if (index < 2)
                                    Positioned(
                                      // top left
                                      top: gridMarkerGap,
                                      left: gridMarkerGap,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.all(Sizes.size2),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(2),
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
            ),
          ),
        );
  }
}

class UserDetailBox extends StatelessWidget {
  final UserProfileModel user;
  const UserDetailBox({
    super.key,
    required this.user,
  });

  void _onEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(
          item: UserProfileTextItem.bio,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (user.bio.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size32,
            ),
            child: Text(
              user.bio,
              textAlign: TextAlign.center,
              style: const TextStyle(
                height: 1.1,
              ),
            ),
          )
        else
          TextButton(
            onPressed: () => _onEditProfile(context),
            child: const Text("Edit Profile!"),
          ),
        Gaps.v14,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user.link.isNotEmpty)
              const FaIcon(
                FontAwesomeIcons.link,
                size: Sizes.size12,
              ),
            if (user.link.isNotEmpty) Gaps.h4,
            Text(
              // "https://github.com/Heungseop",
              user.link,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                height: 1.1,
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
