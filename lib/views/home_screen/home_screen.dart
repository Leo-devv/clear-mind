import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:clear_mind/views/home_screen/body.dart';
import 'package:clear_mind/styles/colors.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: HomeTheme.background,
      body: SafeArea(
        bottom: false,
        child: HomeScreenBody(),
      ),
    );
  }
}
