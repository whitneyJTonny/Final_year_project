import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/profile_avatar.dart';
import '../main.dart';
import 'profile_screen.dart';
import 'settings_pages.dart';
import 'app_version_screen.dart';
import 'system_details_screen.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool systemAlertsEnabled = true;
  bool lowBatteryWarningsEnabled = true;
  bool maintenanceRemindersEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 5),
              ValueListenableBuilder<String>(
                valueListenable: userNameNotifier,
                builder: (context, name, _) => ValueListenableBuilder<String>(
                  valueListenable: userEmailNotifier,
                  builder: (context, email, _) => Row(
                    children: [
                      const ProfileAvatar(
                        size: 44,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color)),
                          Text(email, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              _buildSectionHeader('APPEARANCE'),
              Card(
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primaryYellow,
                        child: ValueListenableBuilder<ThemeMode>(
                          valueListenable: themeNotifier,
                          builder: (context, mode, _) => Icon(
                            mode == ThemeMode.dark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      ValueListenableBuilder<ThemeMode>(
                        valueListenable: themeNotifier,
                        builder: (context, mode, _) => Switch(
                          value: mode == ThemeMode.dark,
                          onChanged: (val) {
                            themeNotifier.value = val
                                ? ThemeMode.dark
                                : ThemeMode.light;
                          },
                          activeTrackColor: AppColors.successGreen.withValues(
                            alpha: 0.5,
                          ),
                          activeThumbColor: AppColors.successGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              _buildSectionHeader('ACCOUNT'),
              _buildCardItem(
                icon: '👤',
                label: 'Profile Information',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildCardItem(
                icon: '🏠',
                label: 'System Details',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SystemDetailsScreen(),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              _buildSectionHeader('NOTIFICATIONS'),
              _buildToggleCard(
                icon: '🔔',
                label: 'System Alerts',
                value: systemAlertsEnabled,
                onChanged: (val) => setState(() => systemAlertsEnabled = val),
              ),
              const SizedBox(height: 10),
              _buildToggleCard(
                icon: '⚠️',
                label: 'Low Battery Warnings',
                value: lowBatteryWarningsEnabled,
                onChanged: (val) =>
                    setState(() => lowBatteryWarningsEnabled = val),
              ),
              const SizedBox(height: 10),
              _buildToggleCard(
                icon: '🔧',
                label: 'Maintenance Reminders',
                value: maintenanceRemindersEnabled,
                onChanged: (val) =>
                    setState(() => maintenanceRemindersEnabled = val),
              ),

              const SizedBox(height: 25),

              _buildSectionHeader('SYSTEM'),
              _buildCardItem(
                icon: '📱',
                label: 'App Version',
                trailing: const Text(
                  'v1.0.0',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppVersionScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildCardItem(
                icon: '📄',
                label: 'Terms & Privacy',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsAndPrivacyScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildCardItem(
                icon: '❓',
                label: 'Help & Support',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpAndSupportScreen(),
                  ),
                ),
              ),

              const SizedBox(height: 25),
              _buildLogoutCard(context),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildCardItem({
    required String icon,
    required String label,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryYellow.withValues(alpha: 0.1),
          child: Text(icon, style: const TextStyle(fontSize: 20)),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        trailing:
            trailing ??
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
      ),
    );
  }

  Widget _buildToggleCard({
    required String icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryYellow.withValues(alpha: 0.1),
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.successGreen.withValues(alpha: 0.5),
              activeThumbColor: AppColors.successGreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutCard(BuildContext context) {
    return Card(
      color: AppColors.warningRed.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.warningRed,
          child: const Text('🚪', style: TextStyle(fontSize: 20)),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: AppColors.warningRed,
          ),
        ),
        onTap: () => _showLogoutDialog(context),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Logout',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService().logout();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warningRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
