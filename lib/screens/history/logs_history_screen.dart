import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';

class LogsHistoryScreen extends StatelessWidget {
  const LogsHistoryScreen({super.key});

  static const List<_WeekSummary> _weeks = [
    _WeekSummary(week: 'Week 34', alerts: 3, avgBpm: 145),
    _WeekSummary(week: 'Week 33', alerts: 1, avgBpm: 142),
    _WeekSummary(week: 'Week 32', alerts: 2, avgBpm: 147),
    _WeekSummary(week: 'Week 31', alerts: 0, avgBpm: 141),
  ];

  static const List<_AlertLog> _alerts = [
    _AlertLog(
      level: 'High',
      title: 'Heart Rate Peak',
      details: 'Heart rate reached 168 BPM for 2 minutes.',
      time: 'Today, 10:42 AM',
    ),
    _AlertLog(
      level: 'Medium',
      title: 'Movement Drop',
      details: 'Movement dropped below your weekly baseline.',
      time: 'Yesterday, 9:05 PM',
    ),
    _AlertLog(
      level: 'Low',
      title: 'Battery Alert',
      details: 'Monitor battery reached 15%.',
      time: 'Mar 4, 6:20 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Logs History', style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8856A), Color(0xFFD4614A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                children: [
                  _SummaryValue(
                      label: 'Total Alerts', value: '${_alerts.length}'),
                  _SummaryValue(
                    label: 'Critical',
                    value: '${_alerts.where((a) => a.level == 'High').length}',
                  ),
                  const _SummaryValue(label: 'Weeks', value: '4'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Weekly Summary', style: AppTextStyles.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            ..._weeks.map((week) => _WeekTile(week: week)),
            const SizedBox(height: AppSpacing.md),
            Text('Alert Timeline', style: AppTextStyles.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            ..._alerts.map((alert) => _AlertTile(alert: alert)),
          ],
        ),
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.heading2.copyWith(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _WeekTile extends StatelessWidget {
  final _WeekSummary week;

  const _WeekTile({required this.week});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              week.week,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text('Avg BPM ${week.avgBpm}', style: AppTextStyles.bodySmall),
          const SizedBox(width: AppSpacing.md),
          Text('${week.alerts} alerts', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final _AlertLog alert;

  const _AlertTile({required this.alert});

  @override
  Widget build(BuildContext context) {
    final color = switch (alert.level) {
      'High' => AppColors.error,
      'Medium' => Colors.orange,
      _ => Colors.blueGrey,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  alert.level,
                  style: AppTextStyles.bodySmall.copyWith(color: color),
                ),
              ),
              const Spacer(),
              Text(alert.time, style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            alert.title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(alert.details, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _WeekSummary {
  final String week;
  final int alerts;
  final int avgBpm;

  const _WeekSummary({
    required this.week,
    required this.alerts,
    required this.avgBpm,
  });
}

class _AlertLog {
  final String level;
  final String title;
  final String details;
  final String time;

  const _AlertLog({
    required this.level,
    required this.title,
    required this.details,
    required this.time,
  });
}
