import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Determine active colors based on theme & primary state
    Color buttonBgColor = isPrimary 
        ? AppColors.primaryYellow 
        : (isDarkMode ? AppColors.darkCardBg : AppColors.cardBg);
    Color textColor = isPrimary 
        ? AppColors.primaryDark 
        : (isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary);
    
    // Premium dynamic decoration (vivid gradient for primary, custom border for secondary)
    BoxDecoration decoration;
    if (isPrimary) {
      decoration = BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryYellow,
            AppColors.secondaryOrange,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryOrange.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      );
    } else {
      decoration = BoxDecoration(
        color: buttonBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode 
              ? AppColors.secondaryDark 
              : AppColors.textLight.withValues(alpha: 0.3),
          width: 1,
        ),
      );
    }

    final bool isEnabled = onPressed != null && !isLoading;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.65, // Elegant semi-transparent states instead of a dull solid grey coating
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(16),
            splashColor: isPrimary
                ? AppColors.primaryDark.withValues(alpha: 0.15)
                : AppColors.textLight.withValues(alpha: 0.15),
            highlightColor: Colors.transparent,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isPrimary ? AppColors.primaryDark : AppColors.primaryYellow,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            size: 20,
                            color: textColor,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
