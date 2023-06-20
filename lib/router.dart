import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation_screen.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';

final router = GoRouter(
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
      path: InterestsScreen.routeURL,
      name: InterestsScreen.routeName,
      builder: (context, state) => const InterestsScreen(),
    ),
    GoRoute(
      path: "/:tab(home|discover|inbox|profile)",
      name: MainNavigationScreen.routeName,
      builder: (context, state) {
        final tab = state.params["tab"]!;
        return MainNavigationScreen(
          tab: tab,
        );
      },
    )
  ],
);

// push => 데이터등을 스택 위에 추가하는 것(뒤로가기 가는)
// go => 그냥 감. 스택에 추가 하지 않음(뒤로 못감)
