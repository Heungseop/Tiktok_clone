import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room.dart';
import 'package:tiktok_clone/features/inbox/repos/chat_room_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';

class ChatRoomViewModel extends AsyncNotifier<void> {
  late final UserRepository _usersRepository;
  // late final MessagesRepo _repo;
  late final ChatRoomRepository _repo;

  @override
  FutureOr<void> build() {
    _usersRepository = ref.read(userRepo);
    _repo = ref.read(chatRoomRepo);
  }

  Future<String> createChatRoom(List<String> uidlist) async {
    final user = ref.read(authRepo).user;
    String roomId = "";

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      uidlist.add(user!.uid);
      roomId = await _repo.createChatRoom(uidlist);
    });
    await _usersRepository.addUserChatRoomList(roomId, uidlist);

    return roomId;
  }

  Future<ChatRoomModel> getChatRoom(String roomId) async {
    final json = await _repo.getChatRoom(roomId);

    ChatRoomModel room = ChatRoomModel.fromJson(json!);

    for (var uid in room.uidlist!) {
      room.users ??= [];
      UserProfileModel temp = UserProfileModel.fromJson(
          await _usersRepository.findProfile(uid) as Map<String, dynamic>);
      room.users!.add(temp);
    }

    return room;
  }
}

final chatRoomRepo = Provider(
  (ref) => ChatRoomRepository(),
);

final chatRoomProvider =
    AsyncNotifierProvider<ChatRoomViewModel, void>(() => ChatRoomViewModel());
