import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils.dart';

class AddChatRoomPop extends StatefulWidget {
  const AddChatRoomPop({super.key});

  @override
  State<AddChatRoomPop> createState() => _AddChatRoomPopState();
}

class _AddChatRoomPopState extends State<AddChatRoomPop> {
  bool _isWriting = false;
  final ScrollController _scrollController = ScrollController();

  void _onClossePressed() {
    Navigator.of(context).pop();
  }

  void _stopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = isDarkMode(context);
    return Container(
      height: size.height * 0.7,
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
          title: Text(
            S.of(context).commentTitle(4894532, 4894532),
            // 숫자 포맷팅
            //https://docs.flutter.dev/accessibility-and-localization/internationalization#messages-with-numbers-and-currencies
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: _onClossePressed,
                icon: const FaIcon(
                  FontAwesomeIcons.xmark,
                ))
          ],
        ),
        body: GestureDetector(
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
                          backgroundColor: isDark ? Colors.grey.shade800 : null,
                          child: const Text("H"),
                        ),
                        Gaps.h10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              const Text(
                                  "That's not it l've seen the same Thing but also in a cabe")
                            ],
                          ),
                        ),
                        Gaps.h10,
                        Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.heart,
                              size: Sizes.size20,
                              color: Colors.grey.shade500,
                            ),
                            Gaps.v2,
                            Text(
                              "52.2K",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            )
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                width: size.width,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size16,
                      vertical: Sizes.size10,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade500,
                          foregroundColor: Colors.white,
                          child: const Text("흥섭"),
                        ),
                        Gaps.h10,
                        Expanded(
                          child: SizedBox(
                            height: Sizes.size44,
                            child: TextField(
                              onTap: _onStartWriting,
                              expands: true,
                              minLines: null,
                              maxLines: null,
                              textInputAction: TextInputAction.newline,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                hintText: "Write a comment...",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      Sizes.size12,
                                    ),
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: isDark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.size12,
                                  vertical: Sizes.size10,
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      right: Sizes.size14),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.at,
                                        color: isDark
                                            ? Colors.grey.shade500
                                            : Colors.grey.shade900,
                                      ),
                                      Gaps.h14,
                                      FaIcon(
                                        FontAwesomeIcons.gift,
                                        color: isDark
                                            ? Colors.grey.shade500
                                            : Colors.grey.shade900,
                                      ),
                                      Gaps.h14,
                                      FaIcon(
                                        FontAwesomeIcons.faceSmile,
                                        color: isDark
                                            ? Colors.grey.shade500
                                            : Colors.grey.shade900,
                                      ),
                                      if (_isWriting) Gaps.h14,
                                      if (_isWriting)
                                        GestureDetector(
                                          onTap: _stopWriting,
                                          child: FaIcon(
                                            FontAwesomeIcons.circleArrowUp,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
