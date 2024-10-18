import 'package:flutter/material.dart';
import 'package:clear_mind/router/router.dart';
import 'package:clear_mind/styles/colors.dart';

void main() {
  runApp(const ClearMindApp());
}

class ClearMindApp extends StatelessWidget {
  const ClearMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Clear Mind',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent200,
          primary: AppColors.primary300,
          secondary: AppColors.accent100,
          background: AppColors.bg200,
          surface: AppColors.bg100,
        ),
        scaffoldBackgroundColor: AppColors.bg200,
        useMaterial3: true,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      routerConfig: router,
    );
  }
}
