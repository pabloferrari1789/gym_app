import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import 'screens/login/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/progress/progress_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/day/day_screen.dart';
import 'screens/exercise/exercise_detail_screen.dart';
import 'widgets/main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    refreshListenable: _AuthStateListenable(ref),
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      if (authState.isLoading) return null;

      final isLoggedIn = authState.valueOrNull != null;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Full-screen routes (no bottom nav)
      GoRoute(
        path: '/week/:weekNumber/day/:dayNumber',
        builder: (context, state) {
          final weekNumber = int.parse(state.pathParameters['weekNumber']!);
          final dayNumber = int.parse(state.pathParameters['dayNumber']!);
          return DayScreen(weekNumber: weekNumber, dayNumber: dayNumber);
        },
      ),
      GoRoute(
        path: '/week/:weekNumber/day/:dayNumber/exercise/:exerciseIndex',
        builder: (context, state) {
          final weekNumber = int.parse(state.pathParameters['weekNumber']!);
          final dayNumber = int.parse(state.pathParameters['dayNumber']!);
          final exerciseIndex =
              int.parse(state.pathParameters['exerciseIndex']!);
          return ExerciseDetailScreen(
            weekNumber: weekNumber,
            dayNumber: dayNumber,
            exerciseIndex: exerciseIndex,
          );
        },
      ),
      // Tabs with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/progress',
              builder: (context, state) => const ProgressScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});

class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(Ref ref) {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
  }
}
