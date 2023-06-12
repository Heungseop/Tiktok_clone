import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/widgets/user_info_card.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("Heungg"),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const FaIcon(
                  FontAwesomeIcons.gear,
                  size: Sizes.size20,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.teal,
                  radius: 50,
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/13977411?v=4"),
                  child: Text("Heungg"),
                ),
                Gaps.v20,
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
                Gaps.v24,
                SizedBox(
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
                ),
                Gaps.v14,
                FractionallySizedBox(
                  widthFactor: .33,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.size12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(
                        Sizes.size4,
                      ),
                    ),
                    child: const Text(
                      "Follow",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Gaps.v14,
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes.size32,
                  ),
                  child: Text(
                    "All highilghts and where to wahtch libe matches on FIFA+ I wonder how it would look",
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
                Gaps.v20,
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Colors.grey.shade200,
                        width: .5,
                      ),
                    ),
                  ),
                  child: const TabBar(
                    indicatorColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: EdgeInsets.symmetric(vertical: Sizes.size10),
                    labelColor: Colors.black,
                    tabs: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Sizes.size20),
                        child: Icon(Icons.grid_4x4_rounded),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Sizes.size20),
                        child: FaIcon(FontAwesomeIcons.heart),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    children: [
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: 20,
                        padding: const EdgeInsets.all(Sizes.size6),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: Sizes.size10,
                          mainAxisSpacing: Sizes.size10,
                          childAspectRatio: 9 / 20,
                        ),
                        itemBuilder: (context, index) => Column(
                          // color: Colors.teal,
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Sizes.size4),
                              ),
                              child: AspectRatio(
                                aspectRatio: 9 / 15,
                                child: FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    placeholder: "assets/images/IMG_4793.jpg",
                                    image:
                                        "https://source.unsplash.com/random/?$index"),
                              ),
                            ),
                            Gaps.v10,
                            const Text(
                              "This is a very long cation for my tiktok thet im upload just now currently.",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: Sizes.size16 + Sizes.size2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gaps.v8,
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 12,
                                    backgroundImage: NetworkImage(
                                        "https://avatars.githubusercontent.com/u/13977411?v=4"),
                                  ),
                                  Gaps.h4,
                                  const Expanded(
                                    child: Text(
                                      "my avatar is going to be very long",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Gaps.h4,
                                  FaIcon(
                                    FontAwesomeIcons.heart,
                                    size: Sizes.size16,
                                    color: Colors.grey.shade600,
                                  ),
                                  Gaps.h2,
                                  const Text(
                                    "2.5M",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Center(
                        child: Text("page2"),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
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
