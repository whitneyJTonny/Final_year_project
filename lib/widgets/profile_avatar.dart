import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../main.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;
  final BoxBorder? border;

  const ProfileAvatar({
    super.key,
    required this.size,
    this.border,
  });

  String _getInitials(String name) {
    if (name.trim().isEmpty) return '??';
    List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: userImagePathNotifier,
      builder: (context, imagePath, _) {
        return ValueListenableBuilder<String>(
          valueListenable: userNameNotifier,
          builder: (context, userName, _) {
            ImageProvider? imageProvider;
            if (imagePath != null && imagePath.isNotEmpty) {
              try {
                if (kIsWeb) {
                  imageProvider = NetworkImage(imagePath);
                } else {
                  final file = File(imagePath);
                  if (file.existsSync()) {
                    imageProvider = FileImage(file);
                  }
                }
              } catch (e) {
                debugPrint('Failed to load profile image file: $e');
              }
            }

            if (imageProvider != null) {
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: border,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }

            // Fallback styled initials with a subtle, premium gradient background
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: border,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryYellow.withValues(alpha: isDarkMode ? 0.25 : 0.15),
                    AppColors.secondaryOrange.withValues(alpha: isDarkMode ? 0.25 : 0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  _getInitials(userName),
                  style: TextStyle(
                    fontSize: size * 0.38,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryYellow,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
