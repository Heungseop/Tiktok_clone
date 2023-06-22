// repository는 데이터 유지와 데이터 읽는 것만 책임진다.
import 'package:shared_preferences/shared_preferences.dart';

class PlaybackConfigRepository {
  static const String _autoplay = "autoplay";
  static const String _muted = "muted";

  final SharedPreferences _preferences;

  PlaybackConfigRepository(this._preferences);

  // 1. 음소거 관련 데이터를 디스크에 저장하는 메소드
  Future<void> setMuted(bool value) async {
    _preferences.setBool(_muted, value);
  }

  // 2. 자동재생 관련 데이터를 저장하는 메소드
  Future<void> setAutoplay(bool value) async {
    _preferences.setBool(_autoplay, value);
  }

  bool isMuted() {
    return _preferences.getBool(_muted) ?? false;
  }

  bool isAutoplay() {
    return _preferences.getBool(_autoplay) ?? false;
  }
}
