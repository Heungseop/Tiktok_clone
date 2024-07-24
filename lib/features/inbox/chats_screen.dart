import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room.dart';
import 'package:tiktok_clone/features/inbox/widgets/create_a_new_chat_screen.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  static const routeName = "chats";
  static const routeURL = "/chats";
  const ChatsScreen({super.key});

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  // late final Future<List<ChatRoomModel>> chatRoomList =
  //     ref.watch(usersProvider.notifier).fetchMyChatRoomList();
  late final Future<List<ChatRoomModel>> roomList =
      ref.watch(usersProvider.notifier).fetchMyChatRoomList();

  late UserProfileModel profile =
      ref.read(usersProvider.notifier).state.value as UserProfileModel;

  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();
  final Duration _duration = const Duration(milliseconds: 200);

  void _addItem() async {
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
    // if (_key.currentState != null) {
    //   _key.currentState!.removeItem(
    //     index,
    //     (context, animation) => SizeTransition(
    //       sizeFactor: animation,
    //       child: Container(color: Colors.red, child: _makeTile(index)),
    //     ),
    //     duration: _duration,
    //   );
    //   _items.removeAt(index);
    // }
  }

  void _onChatTap(String roomId) {
    print("_onChatTap roomId : $roomId");

    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {"roomId": roomId},
    );

    // context.push("${ChatDetailScreen.routeURL}/123");
  }

  @override
  Widget build(BuildContext context) {
    print("@@@ chatroomList : ${roomList.toString()}");
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
        body: FutureBuilder(
          future: roomList,
          builder: (context, snapshot) => ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Gaps.v1,
            itemCount: snapshot.data != null ? snapshot.data!.length : 0,
            itemBuilder: (BuildContext context, int index) {
              return _makeTile(snapshot.data![index]);
            },
          ),
        )

        // AnimatedList(
        //   key: _key,
        //   padding: const EdgeInsets.symmetric(vertical: Sizes.size10),
        //   itemBuilder:
        //       (BuildContext context, int index, Animation<double> animation) {
        //     return FadeTransition(
        //       opacity: animation,
        //       key: UniqueKey(), // 리스트 타일에 유니크 키 부여
        //       child: SizeTransition(
        //         sizeFactor: animation,
        //         child: _makeTile(index),
        //         // child: FutureBuilder(
        //         //   future: roomList,
        //         //   builder: (BuildContext context,
        //         //           AsyncSnapshot<List<ChatRoomModel>> snapshot) =>
        //         //       _makeTile(index, snapshot.data![index]),
        //         // ),
        //       ),
        //     );
        //   },
        // ),
        );
  }

  ListTile _makeTile(ChatRoomModel room) {
    // profile
    final userList = room.users!;
    final userListExMe = userList;
    userListExMe.removeWhere((element) => element.uid == profile.uid);
    final firstUser = userListExMe.first;

    return ListTile(
      // onLongPress: () => _deleteItem(index),
      onTap: () => _onChatTap(room.roomId),
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: !firstUser.hasAvatar
            ? null
            : NetworkImage(firstUser.getAvatarImgUrl()),
        child: Text(firstUser.name),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            userListExMe.map((e) => e.name).join(", "),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            DateFormat("MM/dd hh:mm").format(
                DateTime.fromMillisecondsSinceEpoch(room.lastMsgDate,
                    isUtc: true)),
            style:
                TextStyle(color: Colors.grey.shade500, fontSize: Sizes.size12),
          ),
        ],
      ),
      subtitle: Text(room.lastMsg),
    );
  }
}
