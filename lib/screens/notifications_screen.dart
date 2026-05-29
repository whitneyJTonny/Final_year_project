import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../utils/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.titleLarge?.color,
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildNotificationItem(
            context: context,
            icon: LucideIcons.checkCircle2,
            iconColor: AppColors.secondaryGreen,
            title: 'Your solar kit has been installed!',
            message: 'Kit #SM7-4921 is now powering the Ouma Family home in Nakaseke.',
            time: '2 hours ago',
            isUnread: true,
          ),
          const SizedBox(height: 16),
          _buildNotificationItem(
            context: context,
            icon: LucideIcons.bookOpen,
            iconColor: AppColors.trustBlue,
            title: 'A new impact story is available',
            message: 'Read about how the new clinic in Gulu is saving lives 24/7.',
            time: '1 day ago',
            isUnread: false,
          ),
          const SizedBox(height: 16),
          _buildNotificationItem(
            context: context,
            icon: LucideIcons.heart,
            iconColor: AppColors.primaryYellow,
            title: 'Thank you for powering a home',
            message: 'Your donation of \$60 has been received and is processing.',
            time: '3 days ago',
            isUnread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String time,
    required bool isUnread,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread 
            ? (isDark ? theme.cardColor : Colors.white) 
            : (isDark ? theme.cardColor.withValues(alpha: 0.6) : AppColors.cardBg),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread ? AppColors.primaryYellow.withValues(alpha: 0.5) : theme.dividerColor.withValues(alpha: 0.1),
        ),
        boxShadow: isUnread
            ? [
                BoxShadow(
                  color: AppColors.primaryYellow.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                          fontSize: 16,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.accentOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
