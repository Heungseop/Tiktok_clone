import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';

// 개발 시 모델을 직접 접근하지 않고 뷰모델을 통해 모델데이터에 접근한다.(get/set)
class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  final PlaybackConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  void setMuted(bool value) {
    _repository.setMuted(value);
    //notifier는 state를 가지고 있고 그 state는 사용자에게 노출시키고 싶은 데이터

    // state.muted = value;
    // state를 바꾸지 않고 새로운 state로 기존의 state를 바꿔서 업데이트함. 이 때 화면도 갱신됨
    state = PlaybackConfigModel(
      muted: value,
      autoplay: state.autoplay,
    );
  }

  void setAutoPlay(bool value) {
    _repository.setAutoplay(value);
    state = PlaybackConfigModel(
      muted: state.muted,
      autoplay: value,
    );
  }

  @override
  PlaybackConfigModel build() {
    //사용자가 보게 될, 즉 화면이 갖게 될 초기의 데이터 = state의 초기값
    return PlaybackConfigModel(
      muted: _repository.isMuted(),
      autoplay: _repository.isAutoplay(),
    );
  }
}

//PlaybackConfigModel의 데이터 변화를 통지
//NotifierProvider<vm, model>
// 1. expose하고 싶은 Provider = vm
// 2. Provider가 expose할 data = model
// parameter : vm을 만들 함수
final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  // () => PlaybackConfigViewModel(),
  // SharedPreferences getInstance를 main에서 await해야 하기때문에 어쩔 수 없이 예시로 exception throw
  //대신 main.dart에서 overrideWith 로 repository를 가진 provider로 오버라이드해줌.
  () => throw UnimplementedError(),
);
