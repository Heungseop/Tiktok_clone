import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final List<int> _items = [];

  void _addItem() {
    if (_key.currentState != null) {
      _key.currentState!.insertItem(_items.length,
          duration: const Duration(milliseconds: 300));
      _items.add(_items.length);
    }
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
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/13977411?v=4"
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
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: Sizes.size12),
                    ),
                  ],
                ),
                subtitle: const Text("Don't forget to make video"),
              ),
            ),
          );
        },
      ),
    );
  }
}
