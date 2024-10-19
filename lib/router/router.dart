import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clear_mind/views/tab_screen.dart';
import 'package:clear_mind/views/home_screen/screens/meditation_screen.dart';
import 'package:clear_mind/views/home_screen/screens/journal_screen.dart';
import 'package:clear_mind/views/home_screen/screens/breathe_screen.dart';
import 'package:clear_mind/views/home_screen/screens/therapy_screen.dart';
import 'package:clear_mind/utils/custom_page_transition.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const TabScreen();
      },
      routes: [
        GoRoute(
          path: 'meditation',
          pageBuilder: (context, state) =>
              FadeSlidePageTransition(child: const MeditationScreen()),
        ),
        GoRoute(
          path: 'journal',
          pageBuilder: (context, state) =>
              FadeSlidePageTransition(child: const JournalScreen()),
        ),
        GoRoute(
          path: 'breathe',
          pageBuilder: (context, state) =>
              FadeSlidePageTransition(child: const BreatheScreen()),
        ),
        GoRoute(
          path: 'therapy',
          pageBuilder: (context, state) =>
              FadeSlidePageTransition(child: const TherapyScreen()),
        ),
      ],
    ),
  ],
);
