import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            children: [
              const CircleAvatar(
                radius: Sizes.size24,
                foregroundImage: NetworkImage(
                    "https://avatars.githubusercontent.com/u/13977411?v=4"),
                child: Text("Heung"),
              ),
              Positioned(
                  bottom: -Sizes.size4,
                  right: -Sizes.size4,
                  child: SizedBox(
                    width: Sizes.size20,
                    height: Sizes.size20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        border: Border.all(
                          color: Colors.white,
                          width: Sizes.size4,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(Sizes.size20),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
          title: const Text(
            "Heung",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text("Active now"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              FaIcon(
                FontAwesomeIcons.flag,
                color: Colors.black,
                size: Sizes.size20,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.black,
                size: Sizes.size20,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size20,
              horizontal: Sizes.size14,
            ),
            itemBuilder: (context, index) {
              final isMine = index % 2 == 0;
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(Sizes.size14),
                    decoration: BoxDecoration(
                      color:
                          isMine ? Colors.blue : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(Sizes.size20),
                        topRight: const Radius.circular(Sizes.size20),
                        bottomLeft: Radius.circular(
                            isMine ? Sizes.size20 : Sizes.size2),
                        bottomRight: Radius.circular(
                            isMine ? Sizes.size2 : Sizes.size20),
                      ),
                    ),
                    child: const Text(
                      "this is a message",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size16,
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => Gaps.v10,
            itemCount: 10,
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: BottomAppBar(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size6,
                horizontal: Sizes.size10,
              ),
              color: Colors.grey.shade200,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: Sizes.size40,
                      child: TextField(
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(Sizes.size10),
                          hintText: "Send a message...",
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Sizes.size20),
                              topRight: Radius.circular(Sizes.size20),
                              bottomLeft: Radius.circular(Sizes.size20),
                              bottomRight: Radius.circular(Sizes.size2),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                FaIcon(
                                  FontAwesomeIcons.faceLaugh,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gaps.h16,
                  Container(
                    padding: const EdgeInsets.all(Sizes.size10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400.withOpacity(.8),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.solidPaperPlane,
                      color: Colors.white,
                      size: Sizes.size18,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
