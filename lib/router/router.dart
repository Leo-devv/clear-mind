import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clear_mind/views/tab_screen.dart';
import 'package:clear_mind/views/home_screen/screens/meditation_screen.dart';
import 'package:clear_mind/views/home_screen/screens/journal_screen.dart';
import 'package:clear_mind/views/home_screen/screens/breathe_screen.dart';
import 'package:clear_mind/views/home_screen/screens/therapy_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const TabScreen();
      },
    ),
    GoRoute(
      path: '/meditation',
      builder: (BuildContext context, GoRouterState state) {
        return const MeditationScreen();
      },
    ),
    GoRoute(
      path: '/journal',
      builder: (BuildContext context, GoRouterState state) {
        return const JournalScreen();
      },
    ),
    GoRoute(
      path: '/breathe',
      builder: (BuildContext context, GoRouterState state) {
        return const BreatheScreen();
      },
    ),
    GoRoute(
      path: '/therapy',
      builder: (BuildContext context, GoRouterState state) {
        return const TherapyScreen();
      },
    ),
  ],
);
