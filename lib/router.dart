import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';

import 'common/widgets/main_navigation_screen.dart';
import 'features/authentication/login_screen.dart';
import 'features/authentication/sign_up_screen.dart';
import 'features/inbox/activity_screen.dart';
import 'features/inbox/chat_detail_screen.dart';
import 'features/inbox/chats_screen.dart';
import 'features/onboarding/interests_screen.dart';
import 'features/videos/views/video_recording_screen.dart';
import 'package:flutter/widgets.dart';

final routerProvider = Provider((ref) {
  // ref.read(authRepo);

  // ref.watch(authState);
  //authState에 변화가 있을 때 프로바이더 리빌드 되고 리다이렉트

  return GoRouter(
    initialLocation: "/home",
    redirect: (context, state) {
      final isLoggedin = ref.read(authRepo).isLoggedin;

      if (!isLoggedin) {
        if (state.subloc != SignUpScreen.routeURL &&
            state.subloc != LoginScreen.routeURL) {
          return SignUpScreen.routeURL;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        name: SignUpScreen.routeName,
        path: SignUpScreen.routeURL,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        name: LoginScreen.routeName,
        path: LoginScreen.routeURL,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: InterestsScreen.routeName,
        path: InterestsScreen.routeURL,
        builder: (context, state) => const InterestsScreen(),
      ),
      GoRoute(
        name: MainNavigationScreen.routeName,
        path: "/:tab(home|discover|inbox|profile)",
        builder: (context, state) {
          final tab = state.params["tab"]!;
          return MainNavigationScreen(
            tab: tab,
          );
        },
      ),
      GoRoute(
        name: ActivityScreen.routeName,
        path: ActivityScreen.routeURL,
        builder: (context, state) => const ActivityScreen(),
      ),
      GoRoute(
        name: ChatsScreen.routeName,
        path: ChatsScreen.routeURL,
        builder: (context, state) => const ChatsScreen(),
        routes: [
          GoRoute(
            // /chats/:id
            path: ChatDetailScreen.routeURL,
            name: ChatDetailScreen.routeName,
            builder: (context, state) {
              final chatId = state.params["chatId"]!;
              return ChatDetailScreen(chatId: chatId);
            },
          )
        ],
      ),
      GoRoute(
        path: VideoRecordingScreen.routeURL,
        name: VideoRecordingScreen.routeName,
        pageBuilder: (context, state) => CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 200),
          child: const VideoRecordingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final position = Tween(
              begin: const Offset(0, 1),
              end: const Offset(0, 0),
            ).animate(animation);
            return SlideTransition(
              position: position,
              child: child,
            );
          },
        ),
      )
    ],
  );
});

// push => 데이터등을 스택 위에 추가하는 것(뒤로가기 가는)
// go => 그냥 감. 스택에 추가 하지 않음(뒤로 못감)
