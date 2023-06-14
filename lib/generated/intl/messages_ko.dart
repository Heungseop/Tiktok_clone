// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ko locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ko';

  static String m0(value) => "${value}";

  static String m1(value, cmt_txt) =>
      "${value} ${Intl.plural(cmt_txt, one: 'comment', other: 'comments')}";

  static String m2(value) => "${value}";

  static String m4(nameOfTheApp) => "${nameOfTheApp}에 로그인";

  static String m5(videoCount) => "프로필 만들기, 다른 계정 팔로우, 나만의 동영상 제작 등.";

  static String m6(nameOfTheApp, when) => "${nameOfTheApp} 가입하기 ${when}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("이미 계정이 있으신가요?"),
        "appleButton": MessageLookupByLibrary.simpleMessage("Apple로 계속 진행"),
        "commentCount": m0,
        "commentTitle": m1,
        "emailPasswordButton":
            MessageLookupByLibrary.simpleMessage("전화 또는 이메일 사용"),
        "likeCount": m2,
        "logIn": MessageLookupByLibrary.simpleMessage("로그인"),
        "loginTitle": m4,
        "signUpSubTitle": m5,
        "signUpTitle": m6
      };
}
