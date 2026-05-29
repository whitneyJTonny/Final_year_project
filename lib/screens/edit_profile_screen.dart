import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/profile_avatar.dart';
import '../main.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController(
    text: 'Passionate about bringing clean energy to rural Africa.',
  );

  bool _isSaving = false;
  String? _pendingImagePath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController.text =
        userNameNotifier.value.isNotEmpty ? userNameNotifier.value : 'Guest User';
    _emailController.text =
        userEmailNotifier.value.isNotEmpty ? userEmailNotifier.value : 'guest@example.com';
    _pendingImagePath = userImagePathNotifier.value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // ──────────────────── Image Picking ────────────────────
  Future<void> _pickFromSource(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (picked != null && mounted) {
        setState(() => _pendingImagePath = picked.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not access ${source == ImageSource.camera ? 'camera' : 'gallery'}: $e'),
            backgroundColor: AppColors.warningRed,
          ),
        );
      }
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : AppColors.cardBg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textLight.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Update Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Choose where to get your new photo from',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Camera option
              _buildSourceTile(
                ctx: ctx,
                icon: LucideIcons.camera,
                label: 'Take a Photo',
                subtitle: 'Use your camera to capture a new photo',
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFromSource(ImageSource.camera);
                },
                isDark: isDark,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(height: 1),
              ),
              // Gallery option
              _buildSourceTile(
                ctx: ctx,
                icon: LucideIcons.image,
                label: 'Choose from Gallery',
                subtitle: 'Pick an existing photo from your gallery',
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFromSource(ImageSource.gallery);
                },
                isDark: isDark,
              ),
              if (_pendingImagePath != null) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(height: 1),
                ),
                _buildSourceTile(
                  ctx: ctx,
                  icon: LucideIcons.trash2,
                  label: 'Remove Photo',
                  subtitle: 'Go back to using your initials',
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _pendingImagePath = null);
                  },
                  isDark: isDark,
                  isDestructive: true,
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSourceTile({
    required BuildContext ctx,
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.warningRed : AppColors.primaryYellow;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(icon, color: color, size: 22),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: isDestructive
                        ? AppColors.warningRed
                        : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────── Save Logic ────────────────────
  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name cannot be empty.'),
          backgroundColor: AppColors.warningOrange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Persist to Hive
      final profileBox = Hive.box('user_profile');
      await profileBox.put('name', _nameController.text.trim());
      await profileBox.put('email', _emailController.text.trim());
      await profileBox.put('image_path', _pendingImagePath);

      // Update global notifiers so all screens rebuild immediately
      userNameNotifier.value = _nameController.text.trim();
      userEmailNotifier.value = _emailController.text.trim();
      userImagePathNotifier.value = _pendingImagePath;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(LucideIcons.checkCircle, color: Colors.white, size: 18),
                SizedBox(width: 10),
                Text('Profile updated successfully!'),
              ],
            ),
            backgroundColor: AppColors.successGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: $e'),
            backgroundColor: AppColors.warningRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ──────────────────── Build ────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ── Profile Image Picker ──
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Show pending image preview OR current ProfileAvatar
                  _buildAvatarPreview(isDark),
                  // Camera badge button
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showImageSourceSheet,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryYellow, AppColors.secondaryOrange],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondaryOrange.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(LucideIcons.camera, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the camera icon to change your photo',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),

            // ── Fields ──
            _buildEditField(
              label: 'Full Name',
              controller: _nameController,
              icon: LucideIcons.user,
            ),
            const SizedBox(height: 20),
            _buildEditField(
              label: 'Email Address',
              controller: _emailController,
              icon: LucideIcons.mail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _buildEditField(
              label: 'Bio',
              controller: _bioController,
              icon: LucideIcons.info,
              maxLines: 3,
            ),
            const SizedBox(height: 40),

            // ── Save Button ──
            CustomButton(
              text: 'Save Changes',
              isLoading: _isSaving,
              onPressed: _saveProfile,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPreview(bool isDark) {
    // If user has chosen a new image this session, show a live preview
    if (_pendingImagePath != null && _pendingImagePath!.isNotEmpty) {
      ImageProvider? previewProvider;
      try {
        if (kIsWeb) {
          previewProvider = NetworkImage(_pendingImagePath!);
        } else {
          final f = File(_pendingImagePath!);
          if (f.existsSync()) previewProvider = FileImage(f);
        }
      } catch (_) {}

      if (previewProvider != null) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryYellow, width: 3),
            image: DecorationImage(image: previewProvider, fit: BoxFit.cover),
          ),
        );
      }
    }

    // Fall back to the globally saved avatar (or initials)
    return ProfileAvatar(
      size: 120,
      border: Border.all(color: AppColors.primaryYellow, width: 3),
    );
  }

  Widget _buildEditField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Theme.of(context).textTheme.titleSmall?.color,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon,
                color: Theme.of(context).textTheme.bodySmall?.color, size: 20),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primaryYellow, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
