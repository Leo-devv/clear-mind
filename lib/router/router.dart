import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clear_mind/views/tab_screen.dart';
import 'package:clear_mind/views/home_screen/screens/meditation_screen.dart';
import 'package:clear_mind/views/home_screen/screens/journal_screen.dart';
import 'package:clear_mind/views/home_screen/screens/breathe_screen.dart';
import 'package:clear_mind/views/home_screen/screens/therapy_screen.dart';
import 'package:clear_mind/utils/custom_page_transition.dart';
import 'package:clear_mind/views/auth/login_screen.dart';
import 'package:clear_mind/views/auth/signup_screen.dart';
import 'package:clear_mind/services/auth_service.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final isLoggedIn = await AuthService.isLoggedIn();
    final isLoginRoute = state.matchedLocation == '/login';
    final isSignupRoute = state.matchedLocation == '/signup';

    // If not logged in and not on login/signup page, redirect to login
    if (!isLoggedIn && !isLoginRoute && !isSignupRoute) {
      return '/login';
    }

    // If logged in and on login/signup page, redirect to home
    if (isLoggedIn && (isLoginRoute || isSignupRoute)) {
      return '/';
    }

    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) {
        return const SignupScreen();
      },
    ),
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
