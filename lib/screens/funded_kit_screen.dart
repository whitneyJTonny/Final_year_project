import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class FundedKitScreen extends StatelessWidget {
  final Map<String, dynamic> newKit;

  const FundedKitScreen({super.key, required this.newKit});

  @override
  Widget build(BuildContext context) {
    final int amount = newKit['amount'] as int? ?? 0;
    final int kits = amount ~/ 60 < 1 ? 1 : amount ~/ 60;
    final bool isMonthly = newKit['isMonthly'] as bool? ?? false;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: CustomScrollView(
        slivers: [
          // ── Hero Success Header ─────────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primaryDark,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    // Animated success icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.successGreen.withValues(alpha: 0.4),
                            width: 2),
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.successGreen,
                        size: 52,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Payment Successful!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Thank you, ${newKit['donor'] ?? 'Donor'}! 🌍',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryYellow.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.primaryYellow
                                .withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        isMonthly
                            ? '⚡ Monthly Gift · USD $amount/mo'
                            : '⚡ You just funded $kits kit${kits > 1 ? 's' : ''}!',
                        style: const TextStyle(
                          color: AppColors.primaryYellow,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Receipt ──────────────────────────────────────────
                  _buildSectionHeader('PAYMENT RECEIPT'),
                  _buildReceiptCard(newKit, amount, kits, isMonthly),
                  const SizedBox(height: 25),

                  // ── Kit Details ───────────────────────────────────────
                  _buildSectionHeader('KIT DETAILS'),
                  _buildKitDetailsCard(newKit),
                  const SizedBox(height: 25),

                  // ── Impact Message ────────────────────────────────────
                  _buildSectionHeader('YOUR IMPACT'),
                  _buildImpactCard(kits),
                  const SizedBox(height: 25),

                  // ── Journey Steps ─────────────────────────────────────
                  _buildSectionHeader('WHAT HAPPENS NEXT'),
                  _buildNextStepsCard(),
                  const SizedBox(height: 25),

                  // ── Actions ───────────────────────────────────────────
                  _buildActions(context),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Receipt Card ──────────────────────────────────────────────────────────
  Widget _buildReceiptCard(Map<String, dynamic> kit, int amount, int kits,
      bool isMonthly) {
    return Card(
      color: AppColors.cardBg,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Receipt header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryYellow.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.receipt_long_rounded,
                      color: AppColors.primaryDark, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Solar M7 Receipt',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: AppColors.primaryDark)),
                      Text('Ref: #${kit['id'].toString().substring(0, 10)}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('PAID',
                      style: TextStyle(
                          color: AppColors.successGreen,
                          fontWeight: FontWeight.w800,
                          fontSize: 12)),
                ),
              ],
            ),
            const Divider(height: 24, color: AppColors.bgLight),
            _receiptRow('Donor', kit['donor'] ?? '—'),
            const SizedBox(height: 10),
            _receiptRow('Email', kit['email'] ?? '—'),
            const SizedBox(height: 10),
            _receiptRow('Phone', kit['phone'] ?? '—'),
            const SizedBox(height: 10),
            _receiptRow('Date', kit['date'] ?? '—'),
            const SizedBox(height: 10),
            _receiptRow('Payment', kit['paymentMethod'] ?? '—'),
            const SizedBox(height: 10),
            _receiptRow(
                'Giving Type', isMonthly ? 'Monthly' : 'One-time'),
            const Divider(height: 24, color: AppColors.bgLight),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Amount Paid',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: AppColors.primaryDark)),
                Text(
                  'USD $amount',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Kit Details Card ──────────────────────────────────────────────────────
  Widget _buildKitDetailsCard(Map<String, dynamic> kit) {
    return Card(
      color: AppColors.primaryDark,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryYellow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.solar_power_rounded,
                      color: AppColors.primaryDark, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kit['name'] ?? 'Solar M7 Home Kit',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        kit['location'] ?? 'Uganda',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white54),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:
                            AppColors.successGreen.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: AppColors.successGreen,
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 5),
                      const Text('Active',
                          style: TextStyle(
                              color: AppColors.successGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Stats row
            Row(
              children: [
                _kitStat('🔋', '${kit['battery'] ?? 100}%', 'Battery'),
                _kitDivider(),
                _kitStat('⚡', '${kit['energy'] ?? 10} kWh', 'Energy'),
                _kitDivider(),
                _kitStat('📍', kit['location'] ?? 'Uganda', 'Location'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _kitStat(String emoji, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: 13)),
          Text(label,
              style:
                  const TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _kitDivider() {
    return Container(
        width: 1, height: 40, color: Colors.white.withValues(alpha: 0.1));
  }

  // ── Impact Card ───────────────────────────────────────────────────────────
  Widget _buildImpactCard(int kits) {
    final people = kits * 5;
    final co2 = kits * 248;

    return Card(
      color: AppColors.cardBg,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🌍 Your contribution matters',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppColors.primaryDark),
            ),
            const SizedBox(height: 6),
            Text(
              'By funding $kits kit${kits > 1 ? 's' : ''}, you are bringing clean, reliable solar power to families who have been left behind by the grid.',
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _impactStat(
                    icon: '👨‍👩‍👧‍👦',
                    value: '~$people',
                    label: 'People Reached'),
                const SizedBox(width: 10),
                _impactStat(
                    icon: '🌿',
                    value: '${co2}kg',
                    label: 'CO₂ Avoided'),
                const SizedBox(width: 10),
                _impactStat(
                    icon: '🏠',
                    value: '$kits',
                    label: 'Kit${kits > 1 ? 's' : ''} Funded'),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryYellow.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color:
                        AppColors.primaryYellow.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Text('💡', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '"In rural Uganda, Grace\'s family used to spend USD 15 monthly on kerosene. Now her children study after dark."',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
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

  Widget _impactStat(
      {required String icon,
      required String value,
      required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bgLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: AppColors.primaryDark)),
            Text(label,
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textSecondary),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // ── Next Steps Card ───────────────────────────────────────────────────────
  Widget _buildNextStepsCard() {
    final steps = [
      {
        'icon': '📧',
        'title': 'Confirmation Email',
        'desc': 'A receipt has been sent to your email address.'
      },
      {
        'icon': '🚚',
        'title': 'Kit Deployment',
        'desc': 'Our partners will deploy your kit to a verified family.'
      },
      {
        'icon': '📸',
        'title': 'Impact Update',
        'desc': 'You\'ll receive real photos and updates from the field.'
      },
      {
        'icon': '📊',
        'title': 'Quarterly Report',
        'desc': 'Track your impact in our quarterly transparency report.'
      },
    ];

    return Card(
      color: AppColors.cardBg,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: steps.asMap().entries.map((entry) {
            final isLast = entry.key == steps.length - 1;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          AppColors.primaryYellow.withValues(alpha: 0.15),
                      child: Text(entry.value['icon']!,
                          style: const TextStyle(fontSize: 16)),
                    ),
                    if (!isLast)
                      Container(
                          width: 2,
                          height: 28,
                          color: AppColors.primaryYellow
                              .withValues(alpha: 0.3)),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.value['title']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppColors.primaryDark)),
                        Text(entry.value['desc']!,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.4)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Action Buttons ────────────────────────────────────────────────────────
  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context)
                .popUntil((route) => route.isFirst),
            icon: const Icon(Icons.home_rounded,
                color: AppColors.primaryDark),
            label: const Text(
              'Back to Home',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppColors.primaryDark),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryYellow,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 3,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: AppColors.primaryDark),
            label: const Text(
              'Fund Another Kit',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.primaryDark),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(
                  color: AppColors.primaryDark, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _receiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary)),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark)),
        ),
      ],
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