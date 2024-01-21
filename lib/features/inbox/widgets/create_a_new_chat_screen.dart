import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakepoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widgets/main_button.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/users/views/widgets/avatar.dart';
import 'package:tiktok_clone/utils.dart';

class CreateANewChatScreen extends ConsumerStatefulWidget {
  const CreateANewChatScreen({super.key});

  @override
  CreateANewChatScreenState createState() => CreateANewChatScreenState();
}

class CreateANewChatScreenState extends ConsumerState<CreateANewChatScreen> {
  bool _isWriting = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  late final Future<List<UserProfileModel>> _users =
      ref.watch(usersProvider.notifier).fetchAllUsers();
  List<UserProfileModel> selected = List.empty(growable: true);

  // void _fetchUsers() {
  //   _users = ref.watch(usersProvider.notifier).fetchAllUsers();
  //   print("_fetchUsers users : $_users");
  // }

  void _onClossePressed() {
    Navigator.of(context).pop();
  }

  void _stopWriting() {
    print("_stopWriting");
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  // void _onStartWriting() {
  //   setState(() {
  //     _isWriting = true;
  //   });
  // }

  void _onSearchFieldReset() {
    _textEditingController.clear();
  }

  void _userTap(UserProfileModel user) {
    print("_userTap user : $user");
    print("_userTap selected : $selected");
    if (selected.isEmpty) {
      // showBottomSheet(

      //   // isScrollControlled: true,
      //   // backgroundColor: Colors.transparent, // transparent 를 줌으로써 스캐폴드가 배경이 됨
      //   context: context,
      //   builder: (context) => const selectedChatUsersScreen(),
      // );
    }

    if (!selected.contains(user)) {
      selected.add(user);
    } else {
      selected.remove(user);
    }
    setState(() {});
    print("2_userTap selected : $selected");
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("create a new chat screen build");
    final size = MediaQuery.of(context).size;
    final isDark = isDarkMode(context);

    return Container(
      height: size.height * 0.9,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          Sizes.size14,
        ),
      ),
      child: Scaffold(
        backgroundColor: isDark ? null : Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: isDark ? null : Colors.grey.shade50,
          centerTitle: true,
          title: const Text("Create a new chat"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: _onClossePressed,
                icon: const FaIcon(
                  FontAwesomeIcons.xmark,
                ))
          ],
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: Breakpoints.sm,
                  ), // 마냥 늘어나는 크기를 제한해줄 수 있다.
                  width: MediaQuery.of(context).size.width - Sizes.size24,
                  height: Sizes.size40, // 인풋 높이
                  child: TextField(
                    // onSubmitted: _onSearchSubmitted,
                    // onChanged: _onSearchChanged,
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
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  Scrollbar(
                    controller: _scrollController,
                    child: FutureBuilder(
                      future: _users,
                      builder: (context, snapshot) => ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(
                          top: Sizes.size10,
                          bottom: Sizes.size10 + Sizes.size96,
                          left: Sizes.size16,
                          right: Sizes.size16,
                        ),
                        separatorBuilder: (context, index) => Gaps.v1,
                        itemCount:
                            snapshot.data == null ? 0 : snapshot.data!.length,
                        itemBuilder: (context, index) {
                          UserProfileModel seletedUser = snapshot.data![index];
                          return ListTile(
                            onTap: () => _userTap(seletedUser),
                            leading: CircleAvatar(
                              radius: 18,
                              backgroundColor:
                                  isDark ? Colors.grey.shade800 : null,
                              child: Text("H$index"),
                            ),
                            title: Text(
                              seletedUser.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Sizes.size14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            subtitle: Text(seletedUser.email),
                            trailing: FaIcon(
                              selected.contains(seletedUser)
                                  ? FontAwesomeIcons.solidCircleCheck
                                  : FontAwesomeIcons.circleCheck,
                              size: Sizes.size20,
                              color: selected.contains(seletedUser)
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade500,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomSheet: selected.isEmpty
            ? null
            : SizedBox(
                height: Sizes.size80 + Sizes.size80 + Sizes.size60,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Sizes.size18),
                      // height: Sizes.size80,
                      // clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Sizes.size14,
                        ),
                      ),
                      child: Row(
                        children: [
                          for (UserProfileModel user in selected)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.size10),
                              child: Avatar(
                                uid: user.uid,
                                name: user.name,
                                hasAvatar: user.hasAvatar,
                                isEditable: false,
                                size: Sizes.size32,
                              ),

                              // CircleAvatar(
                              //   radius: Sizes.size20,
                              //   // foregroundImage:
                              //   //     user.hasAvatar ? user.bio : null,
                              //   backgroundColor:
                              //       isDark ? Colors.grey.shade800 : null,
                              //   child: Text(
                              //     user.name,
                              //     textScaleFactor: 0.7,
                              //   ),
                              // ),
                            ),
                        ],
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.all(Sizes.size18),
                        child: MainButton(
                          text: "Chat",
                        )),
                  ],
                ),
              ),
      ),
    );
  }
}
