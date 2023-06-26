import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';

//계정 생성 시 로딩화면을 보여주고 계정생성을 트리거 할 뿐이라 expose할 데이터가 없음.
class SignupViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp() async {
    state = const AsyncValue.loading();

    final form = ref.read(signUpForm);
    state = await AsyncValue.guard(
      // error state 처리해줌
      () async => await _authRepo.signUp(
        form["email"],
        form["password"],
      ),
    );
  }
}

//유저가 양식을 채우면서 채워나갈 form정보(map => {})
final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignupViewModel, void>(
  () => SignupViewModel(),
);
