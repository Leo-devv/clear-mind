import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clear_mind/views/home_screen/body.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
  ],
);
