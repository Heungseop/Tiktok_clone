import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/widgets/create_a_new_chat_screen.dart';

class ChatsScreen extends StatefulWidget {
  static const routeName = "chats";
  static const routeURL = "/chats";
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final List<int> _items = [];
  final Duration _duration = const Duration(milliseconds: 200);

  void _addItem() async {
    print("additem");
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // transparent 를 줌으로써 스캐폴드가 배경이 됨
      context: context,
      builder: (context) => const CreateANewChatScreen(),
    );

    // if (_key.currentState != null) {
    //   _key.currentState!.insertItem(_items.length, duration: _duration);
    //   _items.add(_items.length);
    // }
  }

  void _deleteItem(int index) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Container(color: Colors.red, child: _makeTile(index)),
        ),
        duration: _duration,
      );
      _items.removeAt(index);
    }
  }

  void _onChatTap(int index) {
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {"chatId": "$index"},
    );
    // context.push("${ChatDetailScreen.routeURL}/123");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("Direct message"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const FaIcon(
              FontAwesomeIcons.plus,
            ),
          )
        ],
      ),
      body: AnimatedList(
        key: _key,
        padding: const EdgeInsets.symmetric(vertical: Sizes.size10),
        itemBuilder:
            (BuildContext context, int index, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            key: UniqueKey(), // 리스트 타일에 유니크 키 부여
            child: SizeTransition(
              sizeFactor: animation,
              child: _makeTile(index),
            ),
          );
        },
      ),
    );
  }

  ListTile _makeTile(int index) {
    return ListTile(
      onLongPress: () => _deleteItem(index),
      onTap: () => _onChatTap(index),
      leading: const CircleAvatar(
        radius: 30,
        foregroundImage:
            NetworkImage("https://avatars.githubusercontent.com/u/13977411?v=4"
                // "https://avatars.githubusercontent.com/u/3612017?v=4"
                ),
        child: Text("jinjoo"),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Jin $index",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "2:16 PM",
            style:
                TextStyle(color: Colors.grey.shade500, fontSize: Sizes.size12),
          ),
        ],
      ),
      subtitle: const Text("Don't forget to make video"),
    );
  }
}
