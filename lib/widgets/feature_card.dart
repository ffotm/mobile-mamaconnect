// lib/widgets/feature_card.dart
import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_constants.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Widget icon;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: icon,
            ),
          ],
        ),
      ),
    );
  }
}
