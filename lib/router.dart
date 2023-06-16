import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/main_navigation/main_navigation_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const MainNavigationScreen(),
    )
  ],
);
