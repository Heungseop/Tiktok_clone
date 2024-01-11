import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakepoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class CreateANewChatScreen extends StatefulWidget {
  const CreateANewChatScreen({super.key});

  @override
  State<CreateANewChatScreen> createState() => _CreateANewChatScreenState();
}

class _CreateANewChatScreenState extends State<CreateANewChatScreen> {
  bool _isWriting = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  void _onClossePressed() {
    Navigator.of(context).pop();
  }

  void _stopWriting() {
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
                child: GestureDetector(
                  onTap: _stopWriting,
                  child: Stack(
                    children: [
                      Scrollbar(
                        controller: _scrollController,
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                            top: Sizes.size10,
                            bottom: Sizes.size10 + Sizes.size96,
                            left: Sizes.size16,
                            right: Sizes.size16,
                          ),
                          separatorBuilder: (context, index) => Gaps.v20,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor:
                                      isDark ? Colors.grey.shade800 : null,
                                  child: const Text("H"),
                                ),
                                Gaps.h10,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Heungg",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: Sizes.size14,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                      Gaps.v3,
                                      const Text("user1234")
                                    ],
                                  ),
                                ),
                                Gaps.h10,
                                FaIcon(
                                  FontAwesomeIcons.circleCheck,
                                  size: Sizes.size20,
                                  color: Colors.grey.shade500,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
