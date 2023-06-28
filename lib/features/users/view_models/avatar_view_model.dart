import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';

class AcatarViewModel extends AsyncNotifier<void> {
  late final UserRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(userRepo);
  }

  Future<void> uploadAvatar(File file) async {
    state = const AsyncValue.loading();

    final fileName = ref.read(authRepo).user!.uid;

    // 이 부분은 단지 Firebase 와 소통할 뿐이라 viewModel에 있을 필요가 없다.
    // viewModel의 역할은 로딩상태를 거쳐 성공/에러상태로 변경하는 것 (=>repository로 이동)
    state = await AsyncValue.guard(
      () async => await _repository.uploadAvatar(file, fileName),
    );
  }
}
