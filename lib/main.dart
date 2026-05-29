import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'utils/app_colors.dart';
import 'screens/splash_screen.dart'; // ✅ FIXED: was 'downloads/splash_screen.dart'

// GLOBAL NOTIFIERS
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<bool> isGuestNotifier = ValueNotifier(false);
final ValueNotifier<String> userNameNotifier = ValueNotifier(
  'Whitney Josephin',
);
final ValueNotifier<String> userEmailNotifier = ValueNotifier(
  'whitneyj@example.com',
);
final ValueNotifier<String?> userImagePathNotifier = ValueNotifier<String?>(
  null,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();

    await Hive.openBox('offline_kits');
    final profileBox = await Hive.openBox('user_profile');

    userNameNotifier.value = profileBox.get(
      'name',
      defaultValue: 'Whitney Josephin',
    );
    userEmailNotifier.value = profileBox.get(
      'email',
      defaultValue: 'whitneyj@example.com',
    );
    userImagePathNotifier.value = profileBox.get('image_path');
  } catch (e) {
    debugPrint('Hive init error: $e');
  }

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
          themeMode: mode,

          // ☀️ LIGHT THEME
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: AppColors.primaryYellow,
            scaffoldBackgroundColor: AppColors.bgLight,
            cardColor: AppColors.cardBg,
            useMaterial3: true,
            textTheme: GoogleFonts.interTextTheme().apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),

          // 🌙 DARK THEME
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.primaryYellow,
            scaffoldBackgroundColor: AppColors.darkScaffoldBg,
            cardColor: AppColors.darkCardBg,
            useMaterial3: true,
            textTheme: GoogleFonts.interTextTheme(
              ThemeData.dark().textTheme,
            ).apply(bodyColor: Colors.white, displayColor: Colors.white),
            inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(color: Colors.white70),
              labelStyle: TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white70),
          ),

          home: SplashScreen(),
        );
      },
    );
  }
}