// lib/screens/timeline/timeline_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  static const List<_TimelineWeek> _weeks = [
    _TimelineWeek(week: 1, isCurrent: false),
    _TimelineWeek(week: 2, isCurrent: false),
    _TimelineWeek(week: 3, isCurrent: false),
    _TimelineWeek(week: 4, isCurrent: false),
    _TimelineWeek(week: 6, isCurrent: true),
    _TimelineWeek(week: 4, isCurrent: false),
    _TimelineWeek(week: 4, isCurrent: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Timeline', style: AppTextStyles.heading3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        itemCount: _weeks.length,
        itemBuilder: (context, index) {
          final item = _weeks[index];
          final isLast = index == _weeks.length - 1;
          return _TimelineItem(
            week: item.week,
            isCurrent: item.isCurrent,
            isLast: isLast,
          );
        },
      ),
      bottomNavigationBar: _BottomNav(currentIndex: 0),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final int week;
  final bool isCurrent;
  final bool isLast;

  const _TimelineItem({
    required this.week,
    required this.isCurrent,
    required this.isLast,
  });

  static const String _description =
      'This first week is actually your menstrual period. Because '
      'your expected birth date (EDD or EDB) is calculated from '
      'the first day of your last period.';

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Timeline rail (dot + line) ─────────────────────────────────
          SizedBox(
            width: 28,
            child: Column(
              children: [
                // Dot
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isCurrent ? AppColors.primary : AppColors.primaryLight,
                    border: isCurrent
                        ? null
                        : Border.all(color: AppColors.primaryLight, width: 2),
                  ),
                ),
                // Vertical line (hidden for last item)
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.primaryLight,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // ── Content ────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Week $week',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isCurrent ? AppColors.primary : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMedium,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineWeek {
  final int week;
  final bool isCurrent;
  const _TimelineWeek({required this.week, required this.isCurrent});
}

// ── Shared bottom nav (same as home) ──────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItem(icon: Icons.home_rounded, label: 'Home'),
      _NavItem(icon: Icons.people_outline, label: 'Social'),
      _NavItem(icon: Icons.storefront_outlined, label: 'Shop'),
      _NavItem(icon: Icons.person_outline, label: 'Profile'),
    ];

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = i == currentIndex;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                items[i].icon,
                color: active ? AppColors.primary : AppColors.textLight,
                size: 24,
              ),
              const SizedBox(height: 2),
              Text(
                items[i].label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: active ? AppColors.primary : AppColors.textLight,
                  fontSize: 10,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
