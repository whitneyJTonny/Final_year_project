import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SystemDetailsScreen extends StatefulWidget {
  const SystemDetailsScreen({super.key});

  @override
  State<SystemDetailsScreen> createState() => _SystemDetailsScreenState();
}

class _SystemDetailsScreenState extends State<SystemDetailsScreen> {
  bool _isLoading = true;
  bool _isRefreshing = false;

  // Solar M7 system data — replace with real API/sensor data
  final Map<String, dynamic> _systemData = {
    'kitId': 'SM7-UG-00421',
    'kitName': 'Solar M7 Home Kit',
    'location': 'Kampala, Uganda',
    'installedDate': 'March 2024',
    'batteryLevel': 78, // percent
    'batteryStatus': 'Charging', // Charging / Discharging / Full
    'solarInput': '45W',
    'powerOutput': '12W',
    'panelStatus': 'Active',
    'lastSynced': 'Today, 10:32 AM',
    'connectivity': 'Online',
    'totalEnergySaved': '312 kWh',
    'co2Avoided': '248 kg',
    'firmwareVersion': 'v2.3.1',
    'signalStrength': 'Strong', // Strong / Moderate / Weak
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate fetching from API/device
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _refresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isRefreshing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('System data refreshed'),
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
          'System Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
          ),
        ),
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryDark,
                    ),
                  )
                : const Icon(Icons.refresh_rounded,
                    color: AppColors.primaryDark),
            onPressed: _isRefreshing ? null : _refresh,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryYellow),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kit Identity Card
                  _buildKitHeader(),
                  const SizedBox(height: 25),

                  // Battery & Power Status
                  _buildSectionHeader('POWER STATUS'),
                  _buildBatteryCard(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.solar_power_rounded,
                          label: 'Solar Input',
                          value: _systemData['solarInput'],
                          color: AppColors.primaryYellow,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.electrical_services_rounded,
                          label: 'Power Output',
                          value: _systemData['powerOutput'],
                          color: AppColors.secondaryOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Connectivity
                  _buildSectionHeader('CONNECTIVITY'),
                  _buildInfoCard(
                    icon: Icons.wifi_rounded,
                    label: 'System Status',
                    value: _systemData['connectivity'],
                    valueColor: _systemData['connectivity'] == 'Online'
                        ? AppColors.successGreen
                        : AppColors.warningRed,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    icon: Icons.signal_cellular_alt_rounded,
                    label: 'Signal Strength',
                    value: _systemData['signalStrength'],
                    valueColor: _systemData['signalStrength'] == 'Strong'
                        ? AppColors.successGreen
                        : _systemData['signalStrength'] == 'Moderate'
                            ? AppColors.warningOrange
                            : AppColors.warningRed,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    icon: Icons.sync_rounded,
                    label: 'Last Synced',
                    value: _systemData['lastSynced'],
                  ),
                  const SizedBox(height: 25),

                  // Impact
                  _buildSectionHeader('IMPACT'),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.bolt_rounded,
                          label: 'Energy Saved',
                          value: _systemData['totalEnergySaved'],
                          color: AppColors.infoBlue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.eco_rounded,
                          label: 'CO₂ Avoided',
                          value: _systemData['co2Avoided'],
                          color: AppColors.successGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Kit Info
                  _buildSectionHeader('KIT INFORMATION'),
                  _buildInfoCard(
                    icon: Icons.qr_code_rounded,
                    label: 'Kit ID',
                    value: _systemData['kitId'],
                  ),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    icon: Icons.location_on_rounded,
                    label: 'Location',
                    value: _systemData['location'],
                  ),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    icon: Icons.calendar_today_rounded,
                    label: 'Installed',
                    value: _systemData['installedDate'],
                  ),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    icon: Icons.system_update_rounded,
                    label: 'Firmware',
                    value: _systemData['firmwareVersion'],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildKitHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryYellow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.solar_power_rounded,
                color: AppColors.primaryDark, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _systemData['kitName'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _systemData['location'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.successGreen.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.successGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'Active',
                  style: TextStyle(
                    color: AppColors.successGreen,
                    fontWeight: FontWeight.w700,
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

  Widget _buildBatteryCard() {
    final int level = _systemData['batteryLevel'];
    final String status = _systemData['batteryStatus'];
    final Color batteryColor = level >= 60
        ? AppColors.successGreen
        : level >= 30
            ? AppColors.warningOrange
            : AppColors.warningRed;

    return Card(
      color: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      status == 'Charging'
                          ? Icons.battery_charging_full_rounded
                          : Icons.battery_full_rounded,
                      color: batteryColor,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Battery Level',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$level%',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: batteryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: level / 100,
                minHeight: 10,
                backgroundColor: AppColors.bgLight,
                valueColor: AlwaysStoppedAnimation<Color>(batteryColor),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Status: $status',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      color: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
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
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: valueColor ?? AppColors.primaryDark,
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
}