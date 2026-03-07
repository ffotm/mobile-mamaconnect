import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';

enum AlertSeverity { critical, warning, info }

class _Alert {
  final String title;
  final String description;
  final String time;
  final AlertSeverity severity;
  final IconData icon;
  bool isRead;

  _Alert({
    required this.title,
    required this.description,
    required this.time,
    required this.severity,
    required this.icon,
    this.isRead = false,
  });
}

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<_Alert> _alerts = [
    _Alert(
      title: 'Low Kick Count Detected',
      description:
          'Baby has had fewer than 10 kicks in the last 12 hours. Please contact your midwife if this continues.',
      time: '2 hours ago',
      severity: AlertSeverity.warning,
      icon: Icons.child_care,
    ),
    _Alert(
      title: 'Heart Rate Spike',
      description:
          'Baby\'s heart rate reached 168 BPM at 10:42 AM, above the normal 160 BPM threshold. Monitor closely.',
      time: '4 hours ago',
      severity: AlertSeverity.critical,
      icon: Icons.favorite,
    ),
    _Alert(
      title: 'Temperature Elevated',
      description:
          'Detected temperature of 37.8°C. Mild elevation — stay hydrated and rest. Consult your midwife if it persists.',
      time: 'Yesterday',
      severity: AlertSeverity.warning,
      icon: Icons.thermostat,
    ),
    _Alert(
      title: 'Weekly Report Ready',
      description:
          'Your health summary for the past 7 days is available. All key indicators were within normal range.',
      time: 'Yesterday',
      severity: AlertSeverity.info,
      icon: Icons.description_outlined,
      isRead: true,
    ),
    _Alert(
      title: 'Device Battery Low',
      description:
          'Your Mamaconnect Monitor battery is at 15%. Please charge it soon to avoid data gaps.',
      time: '2 days ago',
      severity: AlertSeverity.warning,
      icon: Icons.battery_alert,
      isRead: true,
    ),
    _Alert(
      title: 'Check-in Reminder',
      description:
          'You have a scheduled midwife check-in tomorrow at 10:00 AM.',
      time: '2 days ago',
      severity: AlertSeverity.info,
      icon: Icons.calendar_today,
      isRead: true,
    ),
  ];

  int _selectedFilter = 0;
  final _filters = ['All', 'Critical', 'Warning', 'Info'];

  List<_Alert> get _filtered {
    if (_selectedFilter == 0) return _alerts;
    final severity = [
      null,
      AlertSeverity.critical,
      AlertSeverity.warning,
      AlertSeverity.info
    ][_selectedFilter];
    return _alerts.where((a) => a.severity == severity).toList();
  }

  int get _unreadCount => _alerts.where((a) => !a.isRead).length;

  void _markAllRead() => setState(() {
        for (final a in _alerts) a.isRead = true;
      });

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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Alerts', style: AppTextStyles.heading3),
            if (_unreadCount > 0) ...[
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text('$_unreadCount',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: Colors.white, fontSize: 11)),
              ),
            ],
          ],
        ),
        centerTitle: true,
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text('Mark all read',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.primary)),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filters.length, (i) {
                  final active = i == _selectedFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: AppSpacing.sm),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                          color: active ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(_filters[i],
                          style: AppTextStyles.bodySmall.copyWith(
                            color: active ? Colors.white : AppColors.textMedium,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Alert list
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.notifications_none,
                            size: 48, color: AppColors.textLight),
                        const SizedBox(height: AppSpacing.md),
                        Text('No alerts', style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _AlertCard(
                      alert: _filtered[i],
                      onTap: () => setState(() => _filtered[i].isRead = true),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final _Alert alert;
  final VoidCallback onTap;

  const _AlertCard({required this.alert, required this.onTap});

  Color get _severityColor {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return Colors.red;
      case AlertSeverity.warning:
        return Colors.orange;
      case AlertSeverity.info:
        return Colors.blue;
    }
  }

  String get _severityLabel {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return 'Critical';
      case AlertSeverity.warning:
        return 'Warning';
      case AlertSeverity.info:
        return 'Info';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: alert.isRead
              ? Colors.white
              : _severityColor.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: alert.isRead
                ? AppColors.divider
                : _severityColor.withValues(alpha: 0.3),
            width: alert.isRead ? 1 : 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _severityColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(alert.icon, color: _severityColor, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(alert.title,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: alert.isRead
                                  ? AppColors.textDark
                                  : AppColors.textDark,
                            )),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _severityColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(_severityLabel,
                            style: AppTextStyles.bodySmall.copyWith(
                                color: _severityColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(alert.description,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textMedium, height: 1.4)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(alert.time,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textLight, fontSize: 11)),
                ],
              ),
            ),
            if (!alert.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: _severityColor),
              ),
          ],
        ),
      ),
    );
  }
}
