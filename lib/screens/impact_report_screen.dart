import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../utils/app_colors.dart';

class ImpactReportScreen extends StatelessWidget {
  const ImpactReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.titleLarge?.color,
        title: const Text('Impact Stories'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'See The Change',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Real stories from communities powered by Solar M7.',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            
            // Impact Story 1
            _buildStoryCard(
              context: context,
              imageUrl: 'https://images.unsplash.com/photo-1542810634-71277d95dcbb?auto=format&fit=crop&q=80&w=800',
              title: "Grace's children now study 3 extra hours per night",
              village: 'Kiboga District',
              quote: '"Before Solar M7, we spent heavily on kerosene and the smoke made my children cough. Now, they study safely under bright light."',
              impacts: ['3 hrs extra study time', 'Saved \$15/month on kerosene'],
            ),
            
            const SizedBox(height: 24),
            
            // Impact Story 2
            _buildStoryCard(
              context: context,
              imageUrl: 'https://images.unsplash.com/photo-1531206715517-5c0ba140b2b8?auto=format&fit=crop&q=80&w=800',
              title: "A new clinic powered 24/7",
              village: 'Gulu District',
              quote: '"We can now deliver babies safely at night and refrigerate crucial vaccines. The solar system changed everything."',
              impacts: ['24/7 Maternity Care', 'Vaccine refrigeration'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCard({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String village,
    required String quote,
    required List<String> impacts,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.2 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.mapPin, size: 14, color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7)),
                    const SizedBox(width: 4),
                    Text(
                      village,
                      style: TextStyle(
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryYellow.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    quote,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: theme.brightness == Brightness.dark ? AppColors.primaryYellow : AppColors.trustBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...impacts.map((impact) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.checkCircle2, color: AppColors.secondaryGreen, size: 16),
                      const SizedBox(width: 8),
                      Text(impact, style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontWeight: FontWeight.w500)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
