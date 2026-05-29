import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(LucideIcons.arrowLeft, color: Theme.of(context).iconTheme.color),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 24),
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Join the movement for clean energy.',
                style: TextStyle(fontSize: 16, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
              ),
              const SizedBox(height: 40),
              
              _buildTextField(
                label: 'Full Name',
                icon: LucideIcons.user,
                hint: 'John Doe',
                controller: _nameController,
                isDark: isDark,
              ),
              const SizedBox(height: 24),
              
              _buildTextField(
                label: 'Email Address',
                icon: LucideIcons.mail,
                hint: 'user@example.com',
                controller: _emailController,
                isDark: isDark,
              ),
              const SizedBox(height: 24),
              
              _buildTextField(
                label: 'Password',
                icon: LucideIcons.lock,
                hint: '••••••••',
                obscureText: _obscurePassword,
                controller: _passwordController,
                isDark: isDark,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye, 
                    size: 20, 
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              
              const SizedBox(height: 40),
              CustomButton(
                text: 'Sign Up',
                isLoading: _isLoading,
                onPressed: () async {
                  final name = _nameController.text.trim();
                  final email = _emailController.text.trim();
                  final password = _passwordController.text;

                  if (name.isEmpty) {
                    _showError('Please enter your full name.');
                    return;
                  }
                  if (email.isEmpty || !email.contains('@')) {
                    _showError('Please enter a valid email address containing "@".');
                    return;
                  }
                  if (password.isEmpty || password.length < 6) {
                    _showError('Password must be at least 6 characters long.');
                    return;
                  }

                  setState(() => _isLoading = true);

                  try {
                    final success = await AuthService().register(name, email, password);
                    if (success) {
                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false,
                        );
                      }
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
                },
              ),
              
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'By signing up, you agree to our Terms & Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary.withValues(alpha: 0.7) : AppColors.textLight, 
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    TextEditingController? controller,
    required bool isDark,
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
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, size: 20),
              suffixIcon: suffixIcon,
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
