import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  int _step = 1; // 1: Email, 2: OTP & New Password, 3: Success
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.warningRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleSendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showError('Please enter a valid email address.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await AuthService().forgotPassword(email);
      if (success && mounted) {
        setState(() {
          _step = 2;
        });
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = e.toString();
        if (errorMsg.startsWith('Exception: ')) {
          errorMsg = errorMsg.replaceFirst('Exception: ', '');
        }
        _showError(errorMsg);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleResetPassword() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (otp.isEmpty || otp.length != 6) {
      _showError('Please enter a valid 6-digit OTP.');
      return;
    }
    if (password.isEmpty || password.length < 6) {
      _showError('Password must be at least 6 characters.');
      return;
    }
    if (password != confirmPassword) {
      _showError('Passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await AuthService().resetPassword(email, otp, password);
      if (success && mounted) {
        setState(() {
          _step = 3;
        });
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = e.toString();
        if (errorMsg.startsWith('Exception: ')) {
          errorMsg = errorMsg.replaceFirst('Exception: ', '');
        }
        _showError(errorMsg);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            if (_step == 2) {
              setState(() => _step = 1);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.key, color: AppColors.primaryYellow, size: 40),
              ).animate().fadeIn().scale(),
              const SizedBox(height: 32),
              Text(
                _step == 1 ? 'Forgot Password?' : _step == 2 ? 'Reset Password' : 'Password Reset',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              Text(
                _step == 1 
                  ? 'Enter the email address associated with your account and we\'ll send you a 6-digit OTP to reset your password.'
                  : _step == 2 
                    ? 'Enter the 6-digit OTP sent to your email and create a new password.'
                    : 'Your password has been reset successfully. You can now login with your new password.',
                style: TextStyle(fontSize: 16, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 48),

              if (_step == 1) ...[
                _buildTextField(
                  label: 'Email Address',
                  icon: LucideIcons.mail,
                  hint: 'user@example.com',
                  controller: _emailController,
                  isDark: isDark,
                  keyboardType: TextInputType.emailAddress,
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 40),
                CustomButton(
                  text: 'Send OTP',
                  isLoading: _isLoading,
                  onPressed: _handleSendOtp,
                ).animate().fadeIn(delay: 800.ms),
              ] else if (_step == 2) ...[
                _buildTextField(
                  label: '6-Digit OTP',
                  icon: LucideIcons.lock,
                  hint: 'Enter 6-digit code',
                  controller: _otpController,
                  isDark: isDark,
                  keyboardType: TextInputType.number,
                ).animate().fadeIn(delay: 500.ms),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'New Password',
                  icon: LucideIcons.lock,
                  hint: 'Enter new password',
                  controller: _passwordController,
                  isDark: isDark,
                  obscureText: true,
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'Confirm Password',
                  icon: LucideIcons.lock,
                  hint: 'Confirm new password',
                  controller: _confirmPasswordController,
                  isDark: isDark,
                  obscureText: true,
                ).animate().fadeIn(delay: 700.ms),
                const SizedBox(height: 40),
                CustomButton(
                  text: 'Reset Password',
                  isLoading: _isLoading,
                  onPressed: _handleResetPassword,
                ).animate().fadeIn(delay: 800.ms),
              ] else ...[
                Center(
                  child: Column(
                    children: [
                      const Icon(LucideIcons.checkCircle, color: Colors.green, size: 80)
                        .animate()
                        .scale(duration: 500.ms, curve: Curves.elasticOut),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Back to Login',
                        isPrimary: false,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    required bool isDark,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Theme.of(context).textTheme.titleLarge?.color, 
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.textLight.withValues(alpha: 0.2)),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, size: 20),
              hintText: hint,
              hintStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary.withValues(alpha: 0.6) : AppColors.textLight, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
