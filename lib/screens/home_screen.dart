import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/profile_avatar.dart';
import 'fund_kit_screen.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final double _currentEnergy = 3.8;
  final int _batteryLevel = 87;
  final double _energyToday = 12.4;
  final int _savingsMonthly = 45000;
  final int _co2Reduced = 184;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isGuestNotifier,
      builder: (context, isGuest, _) {
        return ValueListenableBuilder<String>(
          valueListenable: userNameNotifier,
          builder: (context, currentUserName, _) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. HEADER
                    _buildHeader(isGuest, currentUserName),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          // 2. LIVE GENERATION or GUEST CARD
                          if (!isGuest)
                            _buildEnergyPulseCard()
                          else
                            _buildGuestImpactCard(),

                          const SizedBox(height: 24),

                          // 3. SYSTEM STATS GRID
                          if (!isGuest) ...[
                            Text(
                              'System Overview',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).textTheme.titleLarge?.color,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildStatsGrid(),
                            const SizedBox(height: 24),
                          ],

                          // 4. GLOBAL IMPACT
                          _buildGlobalImpactSection(),

                          const SizedBox(height: 24),

                          // 5. FUND A KIT
                          _buildFundKitCard(),

                          const SizedBox(height: 24),

                          // 6. RECENT ALERTS
                          if (!isGuest) ...[
                            _buildAlertsHeader(),
                            const SizedBox(height: 12),
                            _buildAlertCard(
                              icon: Icons.battery_alert_rounded,
                              title: 'Low Battery Warning',
                              desc: 'Battery dropped to 15%. Reduce usage.',
                              time: '2h ago',
                              color: AppColors.warningOrange,
                            ),
                            const SizedBox(height: 12),
                          ],

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: const BottomNavBar(currentIndex: 0),
            );
          },
        );
      },
    );
  }

  // ─── HEADER ────────────────────────────────────────────────────────────────
  Widget _buildHeader(bool isGuest, String userName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // AVATAR
          isGuest
              ? Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryYellow, AppColors.secondaryOrange],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(Icons.volunteer_activism_rounded, color: Colors.white, size: 22),
                  ),
                )
              : ProfileAvatar(
                  size: 52,
                  border: Border.all(color: AppColors.primaryYellow, width: 2),
                ),

          const SizedBox(width: 14),

          // NAME & GREETING
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isGuest ? 'Hello, Change Maker!' : userName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ],
            ),
          ),

          // NOTIFICATION BELL
          _buildNotificationIcon(isGuest),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon(bool isGuest) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.notifications_none_rounded,
              color: Theme.of(context).textTheme.titleLarge?.color,
              size: 24,
            ),
          ),
          if (!isGuest)
            Positioned(
              top: 11,
              right: 13,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: AppColors.warningRed,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── LIVE GENERATION CARD ──────────────────────────────────────────────────
  Widget _buildEnergyPulseCard() {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(28),
          image: const DecorationImage(
            image: AssetImage('assets/demo1.jpg'),
            fit: BoxFit.cover,
            opacity: 0.22,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryOrange.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withValues(alpha: 0.15),
                Colors.black.withValues(alpha: 0.80),
              ],
            ),
          ),
          child: Column(
            children: [
              // LABEL
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.solar_power_rounded, color: AppColors.secondaryOrange, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'LIVE GENERATION',
                    style: TextStyle(
                      color: AppColors.secondaryOrange.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // BIG kW NUMBER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$_currentEnergy',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 4),
                    child: Text(
                      'kW',
                      style: TextStyle(
                        fontSize: 22,
                        color: AppColors.secondaryOrange,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // TREND BADGE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up_rounded, color: AppColors.successGreen, size: 16),
                    SizedBox(width: 6),
                    Text(
                      '12% vs yesterday',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── GUEST CARD ────────────────────────────────────────────────────────────
  Widget _buildGuestImpactCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondaryOrange, AppColors.primaryYellow],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryOrange.withValues(alpha: 0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 30),
          SizedBox(height: 14),
          Text(
            'Change a Life Today',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            'Your support brings light and opportunity to communities in need. Track every kit you fund in real-time.',
            style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500, height: 1.45),
          ),
        ],
      ),
    );
  }

  // ─── STATS GRID ────────────────────────────────────────────────────────────
  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildStatTile(
          Icons.battery_charging_full_rounded,
          '$_batteryLevel%',
          'Battery Status',
          const Color(0xFFE8F5E9),
          const Color(0xFF4CAF50),
        ),
        _buildStatTile(
          Icons.wb_sunny_rounded,
          '$_energyToday',
          'kWh Produced',
          const Color(0xFFFFF3E0),
          const Color(0xFFFF9800),
        ),
        _buildStatTile(
          Icons.savings_rounded,
          'UGX ${(_savingsMonthly / 1000).toStringAsFixed(0)}K',
          'Saved Monthly',
          const Color(0xFFF3E5F5),
          const Color(0xFF9C27B0),
        ),
        _buildStatTile(
          Icons.eco_rounded,
          '${_co2Reduced}kg',
          'CO2 Reduced',
          const Color(0xFFE3F2FD),
          const Color(0xFF2196F3),
        ),
      ],
    );
  }

  Widget _buildStatTile(
    IconData icon,
    String value,
    String label,
    Color bgColor,
    Color iconColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? bgColor.withValues(alpha: 0.1) : bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── GLOBAL IMPACT ─────────────────────────────────────────────────────────
  Widget _buildGlobalImpactSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.public_rounded, color: AppColors.secondaryOrange, size: 20),
              const SizedBox(width: 10),
              Text(
                'Global Community Impact',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildImpactItem('1,247', 'Kits'),
              _buildImpactItem('10.8K', 'People'),
              _buildImpactItem('14', 'Cities'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ─── FUND KIT CARD ─────────────────────────────────────────────────────────
  Widget _buildFundKitCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(28),
        image: const DecorationImage(
          image: AssetImage('assets/demo1.jpg'),
          fit: BoxFit.cover,
          opacity: 0.25,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.black.withValues(alpha: 0.0),
              Colors.black.withValues(alpha: 0.82),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.volunteer_activism_rounded, color: AppColors.secondaryOrange, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Fund a Solar Kit',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'ACTIVE',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Your \$60 contribution provides clean energy and light to a rural family in Africa.',
              style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FundKitScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'FUND A KIT',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ALERTS ────────────────────────────────────────────────────────────────
  Widget _buildAlertsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'System Alerts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'View All',
            style: TextStyle(color: AppColors.secondaryOrange, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertCard({
    required IconData icon,
    required String title,
    required String desc,
    required String time,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border(left: BorderSide(color: color, width: 5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}