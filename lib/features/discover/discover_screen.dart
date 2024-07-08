import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakepoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();

  late final TabController _tabController =
      TabController(length: tabs.length, vsync: this);

  void _onSearchChanged(String value) {
    // FocusScope.of(context).unfocus();
    print("_onSearchChanged : $value");
  }

  void _onSearchSubmitted(String value) {
    print("_onSearchSubmitted : $value");
  }

  void _onSearchFieldReset() {
    _textEditingController.clear();
  }

  @override
  void initState() {
    super.initState();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          // title: CupertinoSearchTextField(
          //   controller: _textEditingController,
          //   onChanged: _onSearchChanged,
          //   onSubmitted: _onSearchSubmitted,
          // ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(
                    maxWidth: Breakpoints.sm), // 마냥 늘어나는 크기를 제한해줄 수 있다.
                width: MediaQuery.of(context).size.width - Sizes.size24 - 60,
                height: Sizes.size40, // 인풋 높이
                child: TextField(
                  onSubmitted: _onSearchSubmitted,
                  onChanged: _onSearchChanged,
                  controller: _textEditingController,
                  // cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Sizes.size12),
                      borderSide: BorderSide.none, // 라인제거
                    ),
                    filled: true, // 인풋 색상 채울지 여부
                    fillColor: isDarkMode(context)
                        ? Colors.grey.shade800
                        : Colors.grey.shade200,
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.magnifyingGlass,
                          // color: Colors.grey.shade500,
                          color: isDarkMode(context)
                              ? Colors.grey.shade500
                              : Colors.black,
                          size: Sizes.size20,
                        ),
                      ],
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _onSearchFieldReset,
                          child: FaIcon(
                            FontAwesomeIcons.solidCircleXmark,
                            color: Colors.grey.shade600,
                            size: Sizes.size20,
                          ),
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size12,
                      vertical: Sizes.size10,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.size12),
                child: FaIcon(
                  FontAwesomeIcons.sliders,
                  // color: Colors.grey.shade500,
                  size: Sizes.size24,
                ),
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            splashFactory:
                NoSplash.splashFactory, //material design의 버튼을 누르면 퍼지는 효과 제거
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
            ),
            isScrollable: true,
            // labelColor: Colors.black,
            // unselectedLabelColor: Colors.grey.shade500,
            // indicatorColor: Colors.black,
            indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16,
            ),
            tabs: [
              for (var tab in tabs)
                Tab(
                  text: tab,
                )
            ],
          ), // PreferredSizeWidget type을 가져야한다. (= 특정한 크기를 가지려고 하지만 자식요소의 크기를 제한하지 않는 위젯)
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: 20,
              padding: const EdgeInsets.all(Sizes.size6),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: width > Breakpoints.lg ? 5 : 2,
                crossAxisSpacing: Sizes.size10,
                mainAxisSpacing: Sizes.size10,
                childAspectRatio: 9 / 20,
              ),
              itemBuilder: (context, index) => LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    // color: Colors.teal,
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Sizes.size4),
                        ),
                        child: AspectRatio(
                          aspectRatio: 9 / 15,
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholder: "assets/images/IMG_4793.jpg",
                              image:
                                  // "https://source.unsplash.com/random/?$index"),
                                  "https://scontent.cdninstagram.com/v/t51.29350-15/448166430_1531609421079811_8124474133834986911_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDE4MDAuc2RyLmYyOTM1MCJ9&_nc_ht=scontent.cdninstagram.com&_nc_cat=107&_nc_ohc=ju91ujnjHsgQ7kNvgFW1vzB&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzM4NzcyODM1NjYyNzIwMDAwNg%3D%3D.2-ccb7-5&oh=00_AYBmNbIo0asRXOQtUJbkNvMmdbW5jBswB_qgutuaVZy30g&oe=66914D1A&_nc_sid=10d13b"),
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
                          height: 1.1,
                        ),
                      ),
                      Gaps.v8,
                      if (160 < constraints.maxWidth)
                        DefaultTextStyle(
                          style: TextStyle(
                            color: isDarkMode(context)
                                ? Colors.grey.shade300
                                : Colors.grey.shade600,
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
                  );
                },
              ),
            ),
            for (var tab in tabs.skip(1))
              Center(
                child: Text(
                  tab,
                  style: const TextStyle(fontSize: 28),
                ),
              )
          ],
        ));
  }
}
