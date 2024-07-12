import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';
import 'package:tiktok_clone/features/inbox/repos/messages_repo.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';

class MessagesViewModel extends AsyncNotifier<void> {
  late final UserRepository _usersRepository;
  late final MessagesRepo _repo;

  @override
  FutureOr<void> build() {
    _usersRepository = ref.read(userRepo);
    _repo = ref.read(messagesRepo);
  }

  Future<void> sendMessage(String text, String roomId) async {
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        roomId: roomId,
      );

      _repo.sendMessage(message);
    });
  }

  Future<String> createChatRoom(List<String> uidlist) async {
    final user = ref.read(authRepo).user;
    String roomId = "";

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      uidlist.add(user!.uid);
      roomId = await _repo.createChatRoom(uidlist);
    });
    await _usersRepository.addUserChatRoomList(user!.uid, roomId);

    return roomId;
  }
}

final messagesProvider = AsyncNotifierProvider<MessagesViewModel, void>(
  () => MessagesViewModel(),
);

final chatProvider = StreamProvider.autoDispose
    .family<List<MessageModel>, String>((ref, roomId) {
  final db = FirebaseFirestore.instance;

  print("chatProvider roomId : $roomId");

  return db
      .collection("chat_rooms")
      .doc(roomId)
      .collection("texts")
      .orderBy("createdAt")
      .snapshots() //stream을 리턴
      .map(
        (event) => event.docs
            .map(
              (doc) => MessageModel.fromJson(
                doc.data(),
              ),
            )
            .toList()
            .reversed
            .toList(),
      );
});
