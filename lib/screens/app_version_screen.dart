import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_colors.dart';


const String _androidPackageId = 'com.yourcompany.solarm7';
const String _iosAppId = '123456789';

class AppVersionScreen extends StatefulWidget {
  const AppVersionScreen({super.key});

  @override
  State<AppVersionScreen> createState() => _AppVersionScreenState();
}

class _AppVersionScreenState extends State<AppVersionScreen>
    with SingleTickerProviderStateMixin {
  String _version = '—';
  String _buildNumber = '—';
  bool _isChecking = false;
  String _updateStatus = 'idle'; // idle | upToDate | updateAvailable

  // Simulated latest version from your server — replace with real API call
  final String _latestVersion = '1.0.0';

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _version = info.version;
      _buildNumber = info.buildNumber;
    });
  }

  Future<void> _checkForUpdates() async {
    setState(() {
      _isChecking = true;
      _updateStatus = 'idle';
    });

    // Simulate network call to your update server
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Compare versions — replace with real server version fetch
    final bool isUpToDate = _version == _latestVersion;

    setState(() {
      _isChecking = false;
      _updateStatus = isUpToDate ? 'upToDate' : 'updateAvailable';
    });
  }

  Future<void> _openStore() async {
    final Uri url = defaultTargetPlatform == TargetPlatform.iOS
        ? Uri.parse('https://apps.apple.com/app/id$_iosAppId')
        : Uri.parse(
            'https://play.google.com/store/apps/details?id=$_androidPackageId');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not open the store. Try again later.'),
          backgroundColor: AppColors.warningRed,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'App Version',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Solar M7 Hero Card
            _buildHeroCard(),
            const SizedBox(height: 25),

            // Version Info
            _buildSectionHeader('VERSION INFO'),
            _buildInfoRow(
              icon: Icons.tag_rounded,
              label: 'App Version',
              value: 'v$_version',
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              icon: Icons.build_circle_outlined,
              label: 'Build Number',
              value: _buildNumber,
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              icon: Icons.smartphone_rounded,
              label: 'Platform',
              value: Theme.of(context).platform == TargetPlatform.android
                  ? 'Android'
                  : 'iOS',
            ),
            const SizedBox(height: 25),

            // Update Status Banner
            if (_updateStatus != 'idle') _buildUpdateBanner(),
            if (_updateStatus != 'idle') const SizedBox(height: 25),

            // Check for Updates Button
            _buildCheckButton(),
            const SizedBox(height: 25),

            // What's New
            _buildSectionHeader("WHAT'S NEW IN v$_version"),
            _buildChangelogCard(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Animated sun/solar icon
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primaryYellow,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryYellow.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.wb_sunny_rounded,
                color: AppColors.primaryDark,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Solar M7',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'v$_version  •  Build $_buildNumber',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.successGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.successGreen.withValues(alpha: 0.4)),
            ),
            child: const Text(
              '⚡ Powered by Clean Energy',
              style: TextStyle(
                color: AppColors.successGreen,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateBanner() {
    final bool upToDate = _updateStatus == 'upToDate';
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: upToDate
            ? AppColors.successGreen.withValues(alpha: 0.1)
            : AppColors.primaryYellow.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: upToDate
              ? AppColors.successGreen.withValues(alpha: 0.4)
              : AppColors.primaryYellow.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            upToDate
                ? Icons.check_circle_rounded
                : Icons.system_update_rounded,
            color: upToDate ? AppColors.successGreen : AppColors.primaryYellow,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  upToDate ? 'You\'re up to date!' : 'Update Available',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: upToDate
                        ? AppColors.successGreen
                        : AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  upToDate
                      ? 'Solar M7 is running the latest version.'
                      : 'A new version v$_latestVersion is ready to install.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (!upToDate)
            TextButton(
              onPressed: () => _openStore(),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: const Text(
                'Update',
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCheckButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isChecking ? null : _checkForUpdates,
        icon: _isChecking
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.cloud_sync_rounded, color: Colors.white),
        label: Text(
          _isChecking ? 'Checking...' : 'Check for Updates',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Widget _buildChangelogCard() {
    final List<Map<String, String>> changelog = [
      {
        'icon': '🏠',
        'title': 'System Details Screen',
        'desc': 'View your Solar M7 kit status, battery & impact in real time.',
      },
      {
        'icon': '👤',
        'title': 'Profile Editing',
        'desc': 'Update your name, email, phone and location from the app.',
      },
      {
        'icon': '🔔',
        'title': 'Smart Notifications',
        'desc': 'Get alerts for low battery, system faults & maintenance.',
      },
      {
        'icon': '⚡',
        'title': 'Energy Impact Tracking',
        'desc': 'Track your CO₂ savings and total energy generated.',
      },
    ];

    return Card(
      color: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: changelog.map((item) {
            final bool isLast = changelog.last == item;
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['icon']!, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item['desc']!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isLast)
                  const Divider(height: 24, color: AppColors.bgLight),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      color: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryYellow.withValues(alpha: 0.2),
          child: Icon(icon, color: AppColors.primaryDark, size: 20),
        ),
        title: Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: AppColors.primaryDark,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}