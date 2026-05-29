import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TimelineTracker extends StatelessWidget {
  final int currentStep;
  final List<String> steps = [
    'Funded',
    'Processing',
    'Shipped',
    'Installed',
    'Verified'
  ];

  TimelineTracker({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        bool isCompleted = index <= currentStep;
        bool isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? AppColors.secondaryGreen : AppColors.inputBg,
                    border: Border.all(
                      color: isCompleted ? AppColors.secondaryGreen : AppColors.textLight,
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted ? AppColors.secondaryGreen : AppColors.inputBg,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted ? Theme.of(context).textTheme.bodyLarge?.color : AppColors.textLight,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
