import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/chat/chat_screen.dart';
import '../features/home/home_screen.dart';
import '../features/lessons/lesson_detail_screen.dart';
import '../features/lessons/lessons_screen.dart';
import '../features/lessons/doodle_land_screen.dart';
import '../features/lessons/word_scramble_screen.dart';
import '../features/lessons/time_wizz_screen.dart';
import '../features/onboarding/login_screen.dart';
import '../features/onboarding/welcome_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/tools/safety_tools_screen.dart';
import '../widgets/navigation_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  Stream<AuthState>? authStream;
  try {
    authStream = Supabase.instance.client.auth.onAuthStateChange;
  } catch (_) {
    authStream = const Stream.empty();
  }

  return GoRouter(
    initialLocation: '/welcome',
    refreshListenable: GoRouterRefreshStream(authStream),
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainNavigationShell(shell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/lessons',
                builder: (context, state) => const LessonsScreen(),
                routes: [
                  GoRoute(
                    path: 'detail/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return LessonDetailScreen(lessonId: id);
                    },
                  ),
                  GoRoute(
                    path: 'doodle',
                    builder: (context, state) => const DoodleLandScreen(),
                  ),
                  GoRoute(
                    path: 'scramble',
                    builder: (context, state) => const WordScrambleScreen(),
                  ),
                  GoRoute(
                    path: 'timewizz',
                    builder: (context, state) => const TimeWizzScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                builder: (context, state) => const ChatScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tools',
                builder: (context, state) => const SafetyToolsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isWelcome = state.matchedLocation == '/welcome';
      final isLogin = state.matchedLocation == '/login';
      if (!isWelcome && !isLogin) {
        return null;
      }
      return null;
    },
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic>? stream) {
    _subscription = stream?.listen((_) => notifyListeners());
  }
  StreamSubscription<dynamic>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

