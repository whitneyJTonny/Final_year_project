import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

// ✅ USE ALIASES TO AVOID NAME CONFLICTS
import '../screens/home_screen.dart' as home;
import '../screens/monitoring_screen.dart' as monitor;
import '../screens/analytics_screen.dart' as analytics;
import '../screens/settings_screen.dart' as settings;

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // ✅ FIXED
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          if (index == currentIndex) return;

          Widget targetScreen;

          switch (index) {
            case 0:
              targetScreen = const home.HomeScreen();
              break;
            case 1:
              targetScreen = const monitor.MonitoringScreen();
              break;
            case 2:
              targetScreen = const analytics.AnalyticsScreen();
              break;
            case 3:
              targetScreen = const settings.SettingsScreen();
              break;
            default:
              targetScreen = const home.HomeScreen();
          }

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => targetScreen),
            (route) => false,
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: AppColors.primaryYellow.withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.monitor_heart_outlined),
            selectedIcon: Icon(Icons.monitor_heart),
            label: 'Monitor',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
