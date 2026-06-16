import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';

class GymApp extends ConsumerWidget {
  const GymApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Gym App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
    );
  }
}

class AppTheme {
  static ThemeData light() {
    const primary = Color(0xFF4361EE);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0F0F1A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F0F1A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF1E1E2E),
        selectedColor: primary,
        labelStyle: const TextStyle(color: Colors.white),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E2E),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
