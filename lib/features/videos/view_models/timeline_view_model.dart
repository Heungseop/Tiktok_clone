import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [];

  // 비디오 업로드 메서드.
  // 자동/강제로 로딩상태를 유발시킴
  void uploadVideo() async {
    state = const AsyncValue
        .loading(); // => TimelineViewModel 이 다시 loading state가 되도록 만듬.
    await Future.delayed(const Duration(seconds: 3));
    final newVideo = VideoModel(title: "${DateTime.now()}");
    _list = [..._list, newVideo]; //_list에 바로 add 할 수 없음(화면에 나타나지 않음)
    state = AsyncValue.data(_list);
  }

  // build메서드는 async를 붙여 api로부터 데이터를 받아온다.
  @override
  FutureOr<List<VideoModel>> build() async {
    await Future.delayed(const Duration(seconds: 3));
    // throw Exception("omg cant fetch");
    return _list;
  }
}

//provider
final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
