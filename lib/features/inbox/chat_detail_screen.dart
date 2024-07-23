import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/view_models/messages_view_model.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL = ":roomId";
  final String roomId;
  // /chats/:id

  const ChatDetailScreen({super.key, required this.roomId});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _editingController = TextEditingController();

  void _onSendTap() {
    final text = _editingController.text;
    if (text == "") {
      return;
    }
    ref.read(messagesProvider.notifier).sendMessage(text, widget.roomId);

    _editingController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    print("@@@ ChatDetailScreen build roomId : ${widget.roomId}");
    final isLoading = ref.watch(messagesProvider).isLoading;

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
          title: Text(
            "Heung ${widget.roomId}",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text("Active now"),
          trailing: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
          ref.watch(chatProvider(widget.roomId)).when(
                data: (data) {
                  return ListView.separated(
                    reverse: true,
                    padding: EdgeInsets.only(
                      top: Sizes.size20,
                      bottom:
                          MediaQuery.of(context).padding.bottom + Sizes.size96,
                      right: Sizes.size14,
                      left: Sizes.size14,
                    ),
                    itemBuilder: (context, index) {
                      final message = data[index];
                      final isMine =
                          message.userId == ref.watch(authRepo).user!.uid;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: isMine
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(Sizes.size14),
                            decoration: BoxDecoration(
                              color: isMine
                                  ? Colors.blue
                                  : Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(Sizes.size20),
                                topRight: const Radius.circular(Sizes.size20),
                                bottomLeft: Radius.circular(
                                    isMine ? Sizes.size20 : Sizes.size2),
                                bottomRight: Radius.circular(
                                    isMine ? Sizes.size2 : Sizes.size20),
                              ),
                            ),
                            child: Text(
                              message.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: Sizes.size16,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => Gaps.v10,
                    itemCount: data.length,
                  );
                },
                error: (error, stackTrace) => Center(
                  child: Text(error.toString()),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
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
                        controller: _editingController,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(Sizes.size10),
                          hintText: "Send a message...",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Sizes.size20),
                              topRight: Radius.circular(Sizes.size20),
                              bottomLeft: Radius.circular(Sizes.size20),
                              bottomRight: Radius.circular(Sizes.size2),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.all(0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
                  GestureDetector(
                    onTap: isLoading ? null : _onSendTap,
                    child: Container(
                      padding: const EdgeInsets.all(Sizes.size10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400.withOpacity(.8),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: FaIcon(
                        isLoading
                            ? FontAwesomeIcons.hourglass
                            : FontAwesomeIcons.solidPaperPlane,
                        color: Colors.white,
                        size: Sizes.size18,
                      ),
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
