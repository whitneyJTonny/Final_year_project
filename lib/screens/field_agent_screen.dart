import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';

class FieldAgentScreen extends StatelessWidget {
  const FieldAgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.titleLarge?.color,
        title: const Text('Field Agent UI'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.warningOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.wifiOff, size: 14, color: AppColors.warningOrange),
                const SizedBox(width: 6),
                const Text('Offline Mode', style: TextStyle(color: AppColors.warningOrange, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Installation #SM7-4921',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The Ouma Family, Nakaseke District',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            
            // QR Scanner Simulation
            _buildSectionHeader(context, '0. Identify Kit'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                _showScannerSimulation(context);
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryYellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(LucideIcons.qrCode, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                     Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Scan Kit QR Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textTheme.titleMedium?.color)),
                          Text('Align the barcode on the kit to identify it.', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Location Verification
            _buildSectionHeader(context, '1. Location Verification'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondaryGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.checkCircle2, color: AppColors.secondaryGreen),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Location Verified', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryGreen)),
                      Text('Nakaseke District, Central Region', style: TextStyle(color: AppColors.secondaryGreen.withValues(alpha: 0.8), fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Photo Upload
            _buildSectionHeader(context, '2. Upload Photos'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildPhotoUploadBox(context, 'Before\nInstallation')),
                const SizedBox(width: 16),
                Expanded(child: _buildPhotoUploadBox(context, 'After\nInstallation')),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Status Update
            _buildSectionHeader(context, '3. Update Status'),
            const SizedBox(height: 16),
            
            CustomButton(
              text: 'Mark as Installed',
              icon: LucideIcons.check,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Status updated successfully (Saved offline)')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.titleMedium?.color,
      ),
    );
  }

  Widget _buildPhotoUploadBox(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2), style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.camera, color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6), size: 32),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: TextStyle(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8), fontSize: 12)),
        ],
      ),
    );
  }

  void _showScannerSimulation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 40),
            const Text('Scanning Kit...', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const Spacer(),
            // Scanner Frame
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryYellow, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                   // Animated Scanning Line (Simulated with a repeating animation would be better but for now a static line)
                   Container(
                     width: 240,
                     height: 2,
                     color: AppColors.primaryYellow.withValues(alpha: 0.5),
                   ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(40),
              child: CustomButton(
                text: 'Simulate Successful Scan',
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kit #SM7-4921 identified!')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
