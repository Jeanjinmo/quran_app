import 'package:go_router/go_router.dart';

import '../../features/quran_player/presentation/pages/home_page.dart';
import '../../features/quran_player/presentation/pages/player_page.dart';
import '../../features/quran_player/presentation/pages/splash_page.dart';

/// App routes (go_router). Player is nested under `/home` so popping back
/// keeps HomePage mounted — no scroll-position loss or rebuild flash.
/// Navigate with `context.go('/home/player/:n')`.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'player/:surahNumber',
          builder: (context, state) => const PlayerPage(),
        ),
      ],
    ),
  ],
);
