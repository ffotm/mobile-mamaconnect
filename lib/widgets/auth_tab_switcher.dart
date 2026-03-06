// lib/widgets/auth_tab_switcher.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_constants.dart';

class AuthTabSwitcher extends StatelessWidget {
  final int activeIndex; // 0 = Sign Up, 1 = Register
  final ValueChanged<int> onTabChanged;

  const AuthTabSwitcher({
    super.key,
    required this.activeIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          _buildTab('Sign up', 0),
          _buildTab('Register', 1),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isActive = activeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isActive ? AppColors.cardBackground : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style:
                isActive ? AppTextStyles.tabActive : AppTextStyles.tabInactive,
          ),
        ),
      ),
    );
  }
}
