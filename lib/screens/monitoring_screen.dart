import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen>
    with TickerProviderStateMixin {
  String selectedFilter = '24h';

  // Live metrics
  double currentPower = 3.8; // kW
  double batteryLevel = 87; // %
  double load = 2.1; // kW
  double temperature = 32; // °C
  double solarRadiation = 800; // W/m² for weather influence

  // Panel performance
  List<Map<String, dynamic>> panels = [
    {'name': 'Panel 1', 'array': 'East', 'efficiency': 98, 'status': 'Excellent'},
    {'name': 'Panel 2', 'array': 'West', 'efficiency': 95, 'status': 'Excellent'},
    {'name': 'Panel 3', 'array': 'South', 'efficiency': 82, 'status': 'Good'},
  ];

  // Animation controllers for flow bars
  late AnimationController chartAnimationController;
  late List<Animation<double>> chartBarAnimations;

  @override
  void initState() {
    super.initState();

    chartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    chartBarAnimations = List.generate(
      14,
      (index) => Tween<double>(begin: 0, end: (0.4 + 0.06 * (index % 10)))
          .animate(
        CurvedAnimation(
          parent: chartAnimationController,
          curve: Curves.easeOut,
        ),
      ),
    );

    chartAnimationController.repeat(reverse: true);

    // Simulate live metrics
    _simulateLiveData();
  }

  void _simulateLiveData() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        currentPower = (3 + (0.5 + 1.0 * (timer.tick % 5) / 5));
        batteryLevel = (80 + (timer.tick % 15));
        load = (2 + ((timer.tick % 3) * 0.5));
        temperature = (30 + (timer.tick % 5));
        solarRadiation = 700 + (timer.tick % 200); // simulate weather effect
        panels[0]['efficiency'] = 95 + (timer.tick % 5);
      });
    });
  }

  @override
  void dispose() {
    chartAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🚨 Alerts Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: batteryLevel < 20 ? Colors.redAccent : Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      batteryLevel < 20 ? Icons.warning : Icons.check_circle,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        batteryLevel < 20
                            ? 'Battery low! Consider charging soon.'
                            : 'All systems normal',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Header
              const Text(
                'Energy Monitor',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Live System Status',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 25),

              // Live Metrics Row
              _buildMetricsRow(),

              const SizedBox(height: 20),

              // 🔋 Battery Storage + Weather Influence
              _buildBatteryWeather(),

              const SizedBox(height: 20),

              // ⚡ Animated Power Flow Chart
              _buildPowerFlowChart(),

              const SizedBox(height: 20),

              // Panel Performance Cards
              _buildPanelPerformance(),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  // LIVE METRICS ROW
  Widget _buildMetricsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMetricCard('⚡', '${currentPower.toStringAsFixed(1)} kW', 'Power'),
        _buildMetricCard('🔋', '${batteryLevel.toInt()}%', 'Battery'),
        _buildMetricCard('📊', '${load.toStringAsFixed(1)} kW', 'Load'),
        _buildMetricCard('🌡️', '${temperature.toInt()}°C', 'Temp'),
      ],
    );
  }

  Widget _buildMetricCard(String icon, String value, String label) {
    return Container(
      width: 75,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // BATTERY STORAGE + WEATHER
  Widget _buildBatteryWeather() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Battery & Weather',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Icon(Icons.battery_full, color: AppColors.primaryYellow, size: 32),
                  const SizedBox(height: 5),
                  Text('${batteryLevel.toInt()}%', style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  const Text('Battery Level', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.wb_sunny, color: AppColors.successGreen, size: 32),
                  const SizedBox(height: 5),
                  Text('${solarRadiation.toInt()} W/m²', style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  const Text('Solar Radiation', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // POWER FLOW CHART
  Widget _buildPowerFlowChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Power Flow',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: chartBarAnimations.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: chartBarAnimations[index],
                  builder: (context, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 25,
                            height: 160 * chartBarAnimations[index].value,
                            decoration: BoxDecoration(
                              color: AppColors.primaryYellow,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('H${index + 1}',
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // PANEL PERFORMANCE
  Widget _buildPanelPerformance() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Panel Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 15),
          ...panels.map((panel) {
            Color statusColor;
            if (panel['status'] == 'Excellent') {
              statusColor = AppColors.successGreen;
            } else if (panel['status'] == 'Good') {
              statusColor = AppColors.primaryYellow;
            } else {
              statusColor = Colors.redAccent;
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 40,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(panel['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15)),
                        Text(panel['array'],
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${panel['efficiency']}%',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppColors.primaryDark)),
                      Text(panel['status'],
                          style:
                              TextStyle(fontSize: 11, color: statusColor)),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}