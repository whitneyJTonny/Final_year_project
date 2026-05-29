import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'dart:math' as math;

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE
              const Text(
                'Admin Analytics',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                width: 60,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 24),

              // GLOBAL IMPACT OVERVIEW
              const Text(
                'Global Impact Overview',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 14),

              // LIVE DEPLOYMENT MAP CARD
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/demo1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black.withValues(alpha: 0.35),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9800).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.map_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Live Deployment Map',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // STATS ROW
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.inventory_2_outlined,
                      iconColor: const Color(0xFFFF9800),
                      value: '12,450',
                      label: 'Total Kits',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.attach_money_rounded,
                      iconColor: const Color(0xFF4CAF50),
                      value: '\$747k',
                      label: 'Total Funds',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // DONATION FLOW
              const Text(
                'Donation Flow',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 14),

              // CHART
              Container(
                width: double.infinity,
                height: 220,
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Expanded(child: _DonationLineChart()),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['Jan', 'Feb', 'Mar', 'Apr', 'May']
                          .map((m) => Text(
                                m,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DonationLineChart extends StatelessWidget {
  final List<double> data = const [400, 600, 500, 800, 700, 1100, 1300];

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LinePainter(data: data),
      child: Container(),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<double> data;
  _LinePainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = data.reduce(math.max);
    final minVal = data.reduce(math.min);
    final range = maxVal - minVal;

    // Y axis labels
    final yPaint = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i <= 3; i++) {
      final val = (minVal + (range * i / 3)).round();
      yPaint.text = TextSpan(
        text: val.toString(),
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey.shade400,
        ),
      );
      yPaint.layout();
      final y = size.height - (i / 3) * size.height;
      yPaint.paint(canvas, Offset(0, y - 6));

      // Grid line
      final gridPaint = Paint()
        ..color = Colors.grey.shade100
        ..strokeWidth = 1;
      canvas.drawLine(
        Offset(30, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Line path
    final linePaint = Paint()
      ..color = const Color(0xFFFF9800)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFF9800).withValues(alpha: 0.15),
          const Color(0xFFFF9800).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final chartWidth = size.width - 30;
    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final x = 30 + (i / (data.length - 1)) * chartWidth;
      final y = size.height -
          ((data[i] - minVal) / range) * size.height * 0.85 -
          size.height * 0.05;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        final prevX = 30 + ((i - 1) / (data.length - 1)) * chartWidth;
        final prevY = size.height -
            ((data[i - 1] - minVal) / range) * size.height * 0.85 -
            size.height * 0.05;
        final cpX = (prevX + x) / 2;
        path.cubicTo(cpX, prevY, cpX, y, x, y);
        fillPath.cubicTo(cpX, prevY, cpX, y, x, y);
      }
    }

    fillPath.lineTo(30 + chartWidth, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // Dots
    final dotPaint = Paint()
      ..color = const Color(0xFFFF9800)
      ..style = PaintingStyle.fill;
    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final x = 30 + (i / (data.length - 1)) * chartWidth;
      final y = size.height -
          ((data[i] - minVal) / range) * size.height * 0.85 -
          size.height * 0.05;
      canvas.drawCircle(Offset(x, y), 5, dotBorderPaint);
      canvas.drawCircle(Offset(x, y), 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
