import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:developer' as developer;

import '../utils/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data
    final List<EnergyData> monthlyData = [
      EnergyData('Dec', 0.65),
      EnergyData('Jan', 0.78),
      EnergyData('Feb', 0.92),
    ];

    final List<EnergyData> efficiencyData = [
      EnergyData('Dec', 0.92),
      EnergyData('Jan', 0.94),
      EnergyData('Feb', 0.942),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Analytics',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Performance Insights',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 30),

              // Metric Cards
              _buildMetricCard(
                '📊',
                'Total Energy Generated',
                '387 kWh',
                '↗ +12% vs last month',
                true,
              ),
              const SizedBox(height: 15),
              _buildMetricCard(
                '⚡',
                'Average Daily Production',
                '12.4 kWh',
                '↗ +8% vs last week',
                true,
              ),
              const SizedBox(height: 15),
              _buildMetricCard(
                '💰',
                'Cost Savings',
                'UGX 45,300',
                '↗ This month',
                true,
              ),
              const SizedBox(height: 15),
              _buildMetricCard(
                '🌍',
                'Carbon Offset',
                '184 kg',
                '↗ CO₂ reduced this month',
                true,
              ),
              const SizedBox(height: 15),
              _buildMetricCard(
                '🎯',
                'System Efficiency',
                '94.2%',
                '↘ -1.2% vs optimal',
                false,
              ),
              const SizedBox(height: 30),

              // Monthly Energy Chart
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monthly Comparison',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 220,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          majorGridLines: const MajorGridLines(width: 0),
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: 0,
                          maximum: 1,
                          interval: 0.2,
                          majorGridLines: const MajorGridLines(width: 0),
                        ),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CartesianSeries>[
                          ColumnSeries<EnergyData, String>(
                            dataSource: monthlyData,
                            xValueMapper: (data, _) => data.month,
                            yValueMapper: (data, _) => data.value,
                            pointColorMapper: (data, index) {
                              if (index == 0) return AppColors.primaryYellow;
                              if (index == 1) return AppColors.secondaryOrange;
                              return AppColors.successGreen;
                            },
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              textStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Efficiency Trend Line Chart
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Efficiency Trend',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 220,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(
                          majorGridLines: const MajorGridLines(width: 0),
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: 0.8,
                          maximum: 1,
                          interval: 0.05,
                          majorGridLines: const MajorGridLines(width: 0),
                        ),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CartesianSeries>[
                          LineSeries<EnergyData, String>(
                            dataSource: efficiencyData,
                            xValueMapper: (data, _) => data.month,
                            yValueMapper: (data, _) => data.value,
                            color: AppColors.primaryYellow,
                            width: 3,
                            markerSettings: const MarkerSettings(
                              isVisible: true,
                              color: AppColors.successGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildMetricCard(
    String icon,
    String title,
    String value,
    String change,
    bool isPositive,
  ) {
    return GestureDetector(
      onTap: () {
        developer.log('$title card tapped!');
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryYellow,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    change,
                    style: TextStyle(
                      fontSize: 12,
                      color: isPositive
                          ? AppColors.successGreen
                          : AppColors.warningRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model for chart data
class EnergyData {
  final String month;
  final double value;
  EnergyData(this.month, this.value);
}
