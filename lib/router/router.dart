import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clear_mind/views/home_screen/body.dart';
import 'package:clear_mind/views/meditation_screen/meditation_screen.dart';
import 'package:clear_mind/views/journal_screen/journal_screen.dart';
import 'package:clear_mind/views/breathe_screen/breathe_screen.dart';
import 'package:clear_mind/views/therapy_screen/therapy_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
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
