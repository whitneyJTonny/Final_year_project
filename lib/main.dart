import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

// Global theme notifier — controls light/dark mode
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const SolarApp());
}

class SolarApp extends StatelessWidget {
  const SolarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Solar M7',

          // Theme switching
          themeMode: mode,

          // ───────── LIGHT THEME ─────────
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.orange,
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            cardColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFF8F9FA),
              foregroundColor: Color(0xFF111111),
              elevation: 0,
            ),
            useMaterial3: false,
          ),

          // ───────── DARK THEME ─────────
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.orange,
            scaffoldBackgroundColor: const Color(0xFF111111),
            cardColor: const Color(0xFF1E1E1E),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF111111),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            dividerColor: Colors.white12,
            useMaterial3: false,
          ),

          // App entry point
          home: const SplashScreen(),
        );
      },
    );
  }
}