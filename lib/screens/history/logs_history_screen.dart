// lib/screens/logs/logs_history_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';

// ── Data models ───────────────────────────────────────────────────────────────

class _Reading {
  final DateTime time;
  final double? heartRate;
  final double? temperature;
  final int? kicks;
  final double? spo2;
  final String source; // 'device' or 'manual'

  const _Reading({
    required this.time,
    this.heartRate,
    this.temperature,
    this.kicks,
    this.spo2,
    required this.source,
  });
}

class _WeekSummary {
  final String week;
  final int alerts;
  final double avgBpm;
  const _WeekSummary(
      {required this.week, required this.alerts, required this.avgBpm});
}

class _AlertLog {
  final String level;
  final String title;
  final String details;
  final String time;
  const _AlertLog(
      {required this.level,
      required this.title,
      required this.details,
      required this.time});
}

// ── Mock data ─────────────────────────────────────────────────────────────────

final _mockReadings = [
  _Reading(
      time: DateTime.now().subtract(const Duration(hours: 1)),
      heartRate: 143,
      temperature: 36.6,
      kicks: 3,
      spo2: 98.2,
      source: 'manual'),
  _Reading(
      time: DateTime.now().subtract(const Duration(hours: 3)),
      heartRate: 158,
      temperature: 37.1,
      kicks: 1,
      spo2: 97.4,
      source: 'manual'),
  _Reading(
      time: DateTime.now().subtract(const Duration(hours: 6)),
      heartRate: 139,
      temperature: 36.5,
      kicks: 5,
      spo2: 98.8,
      source: 'manual'),
  _Reading(
      time: DateTime.now().subtract(const Duration(days: 1)),
      heartRate: 145,
      temperature: 36.7,
      kicks: 8,
      spo2: 98.5,
      source: 'manual'),
  _Reading(
      time: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      heartRate: 168,
      temperature: 37.4,
      kicks: 2,
      spo2: 96.1,
      source: 'manual'),
  _Reading(
      time: DateTime.now().subtract(const Duration(days: 2)),
      heartRate: 141,
      temperature: 36.6,
      kicks: 12,
      spo2: 98.9,
      source: 'manual'),
];

const _mockWeeks = [
  _WeekSummary(week: 'Week 34', alerts: 3, avgBpm: 145),
  _WeekSummary(week: 'Week 33', alerts: 1, avgBpm: 142),
  _WeekSummary(week: 'Week 32', alerts: 2, avgBpm: 147),
  _WeekSummary(week: 'Week 31', alerts: 0, avgBpm: 141),
];

const _mockAlerts = [
  _AlertLog(
      level: 'High',
      title: 'Heart Rate Peak',
      details: 'Heart rate reached 168 BPM for 2 minutes.',
      time: 'Today, 10:42 AM'),
  _AlertLog(
      level: 'Medium',
      title: 'Movement Drop',
      details: 'Movement dropped below your weekly baseline.',
      time: 'Yesterday, 9:05 PM'),
  _AlertLog(
      level: 'Low',
      title: 'Battery Alert',
      details: 'Monitor battery reached 15%.',
      time: 'Mar 4, 6:20 PM'),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class LogsHistoryScreen extends StatefulWidget {
  final bool showBackButton;
  const LogsHistoryScreen({super.key, this.showBackButton = true});

  @override
  State<LogsHistoryScreen> createState() => _LogsHistoryScreenState();
}

class _LogsHistoryScreenState extends State<LogsHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  final bool _deviceConnected = false;
  final List<_Reading> _readings = List.from(_mockReadings);

  int _selectedMetric = 0;
  final _metrics = ['Heart Rate', 'Temperature', 'Kicks'];
  final _metricColors = [
    AppColors.primary,
    Colors.orange,
    Colors.purple,
  ];
  final _metricIcons = [Icons.favorite, Icons.thermostat, Icons.child_care];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  List<double> get _graphValues {
    switch (_selectedMetric) {
      case 0:
        return _readings.map((r) => r.heartRate ?? 0).toList();
      case 1:
        return _readings.map((r) => r.temperature ?? 0).toList();
      case 2:
        return _readings.map((r) => (r.kicks ?? 0).toDouble()).toList();

      default:
        return [];
    }
  }

  double get _avgValue {
    final vals = _graphValues.where((v) => v > 0).toList();
    if (vals.isEmpty) return 0;
    return vals.reduce((a, b) => a + b) / vals.length;
  }

  double get _minValue {
    final vals = _graphValues.where((v) => v > 0).toList();
    if (vals.isEmpty) return 0;
    return vals.reduce(min);
  }

  double get _maxValue {
    final vals = _graphValues.where((v) => v > 0).toList();
    if (vals.isEmpty) return 0;
    return vals.reduce(max);
  }

  void _showManualEntrySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _ManualEntrySheet(
        onSave: (r) => setState(() => _readings.insert(0, r)),
      ),
    );
  }

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
        title: const Text('Health Logs', style: AppTextStyles.heading3),
        centerTitle: true,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: _showManualEntrySheet,
            tooltip: 'Log manually',
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textLight,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Graphs'),
            Tab(text: 'History'),
            Tab(text: 'Alerts')
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _GraphsTab(
            readings: _readings,
            deviceConnected: _deviceConnected,
            selectedMetric: _selectedMetric,
            metrics: _metrics,
            metricColors: _metricColors,
            metricIcons: _metricIcons,
            graphValues: _graphValues,
            avg: _avgValue,
            min: _minValue,
            max: _maxValue,
            onMetricChanged: (i) => setState(() => _selectedMetric = i),
            onConnectBluetooth: () =>
                Navigator.pushNamed(context, '/bluetooth'),
            onLogManually: _showManualEntrySheet,
          ),
          _HistoryTab(readings: _readings, weeks: _mockWeeks),
          const _AlertsTab(alerts: _mockAlerts),
        ],
      ),
    );
  }
}

// ── Tab 1: Graphs ─────────────────────────────────────────────────────────────

class _GraphsTab extends StatelessWidget {
  final List<_Reading> readings;
  final bool deviceConnected;
  final int selectedMetric;
  final List<String> metrics;
  final List<Color> metricColors;
  final List<IconData> metricIcons;
  final List<double> graphValues;
  final double avg, min, max;
  final ValueChanged<int> onMetricChanged;
  final VoidCallback onConnectBluetooth;
  final VoidCallback onLogManually;

  const _GraphsTab({
    required this.readings,
    required this.deviceConnected,
    required this.selectedMetric,
    required this.metrics,
    required this.metricColors,
    required this.metricIcons,
    required this.graphValues,
    required this.avg,
    required this.min,
    required this.max,
    required this.onMetricChanged,
    required this.onConnectBluetooth,
    required this.onLogManually,
  });

  @override
  Widget build(BuildContext context) {
    final color = metricColors[selectedMetric];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!deviceConnected)
            _ConnectionBanner(
              onConnect: onConnectBluetooth,
              onManual: onLogManually,
            ),
          if (!deviceConnected) const SizedBox(height: AppSpacing.md),

          // Summary header
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
                _SummaryChip(label: 'Total Logs', value: '${readings.length}'),
                _SummaryChip(
                    label: 'Critical',
                    value:
                        '${readings.where((r) => (r.heartRate ?? 0) > 160).length}'),
                _SummaryChip(
                    label: 'This Week',
                    value:
                        '${readings.where((r) => r.time.isAfter(DateTime.now().subtract(const Duration(days: 7)))).length}'),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(metrics.length, (i) {
                final active = i == selectedMetric;
                return GestureDetector(
                  onTap: () => onMetricChanged(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: AppSpacing.sm),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? metricColors[i] : Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                          color: active ? metricColors[i] : AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(metricIcons[i],
                            color: active ? Colors.white : metricColors[i],
                            size: 14),
                        const SizedBox(width: 6),
                        Text(metrics[i],
                            style: AppTextStyles.bodySmall.copyWith(
                                color: active
                                    ? Colors.white
                                    : AppColors.textMedium,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Graph card
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(metricIcons[selectedMetric], color: color, size: 16),
                    const SizedBox(width: 6),
                    Text(metrics[selectedMetric],
                        style: AppTextStyles.bodyLarge
                            .copyWith(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text('Last ${readings.length} readings',
                          style:
                              AppTextStyles.bodySmall.copyWith(color: color)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // Stats row
                Row(
                  children: [
                    Expanded(
                        child: _MiniStat(
                            label: 'Avg',
                            value: avg.toStringAsFixed(1),
                            color: color)),
                    Expanded(
                        child: _MiniStat(
                            label: 'Min',
                            value: min.toStringAsFixed(1),
                            color: Colors.blue)),
                    Expanded(
                        child: _MiniStat(
                            label: 'Max',
                            value: max.toStringAsFixed(1),
                            color: Colors.orange)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // Line chart
                SizedBox(
                  height: 140,
                  child: graphValues.isEmpty
                      ? Center(
                          child: Text('No data',
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: AppColors.textLight)))
                      : CustomPaint(
                          size: const Size(double.infinity, 140),
                          painter: _LineChartPainter(
                            values: graphValues,
                            color: color,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label, value;
  const _SummaryChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Text(value,
              style: AppTextStyles.heading2
                  .copyWith(color: Colors.white, fontSize: 22)),
          const SizedBox(height: 2),
          Text(label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: Colors.white.withValues(alpha: 0.85))),
        ]),
      );
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MiniStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value,
            style: AppTextStyles.bodyLarge
                .copyWith(color: color, fontWeight: FontWeight.w700)),
        Text(label,
            style:
                AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
      ]);
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final Color color;
  const _LineChartPainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final minV = values.reduce(min);
    final maxV = values.reduce(max);
    final range = (maxV - minV).clamp(1.0, double.infinity);

    double norm(double v) =>
        size.height -
        ((v - minV) / range) * (size.height * 0.85) -
        size.height * 0.05;

    // Fill area
    final fillPath = Path();
    for (int i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * size.width;
      final y = norm(values[i]);
      i == 0 ? fillPath.moveTo(x, y) : fillPath.lineTo(x, y);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    canvas.drawPath(
        fillPath,
        Paint()
          ..shader = LinearGradient(
                  colors: [color.withValues(alpha: 0.25), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)
              .createShader(Rect.fromLTWH(0, 0, size.width, size.height)));

    // Line
    final linePath = Path();
    for (int i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * size.width;
      final y = norm(values[i]);
      i == 0 ? linePath.moveTo(x, y) : linePath.lineTo(x, y);
    }
    canvas.drawPath(
        linePath,
        Paint()
          ..color = color
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round);

    // Dots
    for (int i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * size.width;
      final y = norm(values[i]);
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(x, y), 3, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) => old.values != values;
}

class _ConnectionBanner extends StatelessWidget {
  final VoidCallback onConnect;
  final VoidCallback onManual;
  const _ConnectionBanner({required this.onConnect, required this.onManual});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bluetooth_disabled,
                    color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('No device connected',
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text('Connect your belt or enter data manually',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textLight)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onConnect,
                  icon: const Icon(Icons.bluetooth,
                      size: 16, color: Colors.white),
                  label: const Text('Connect Belt',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.full)),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onManual,
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Log Manually',
                      style: TextStyle(fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textDark,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.full)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  final List<_Reading> readings;
  final List<_WeekSummary> weeks;
  const _HistoryTab({required this.readings, required this.weeks});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('Weekly Summary',
            style:
                AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.sm),
        ...weeks.map((w) => _WeekTile(week: w)),
        const SizedBox(height: AppSpacing.lg),
        Text('All Readings',
            style:
                AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.sm),
        ...readings.map((r) => _ReadingRow(reading: r)),
      ],
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
              child: Text(week.week,
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600))),
          Text('Avg ${week.avgBpm.toStringAsFixed(0)} BPM',
              style: AppTextStyles.bodySmall),
          const SizedBox(width: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: week.alerts > 0
                  ? Colors.red.withValues(alpha: 0.1)
                  : Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text('${week.alerts} alerts',
                style: AppTextStyles.bodySmall.copyWith(
                    color: week.alerts > 0 ? Colors.red : Colors.green)),
          ),
        ],
      ),
    );
  }
}

class _ReadingRow extends StatelessWidget {
  final _Reading reading;
  const _ReadingRow({required this.reading});

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final isAlert =
        (reading.heartRate ?? 0) > 160 || (reading.temperature ?? 0) > 37.5;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isAlert ? Colors.red.withValues(alpha: 0.03) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
            color:
                isAlert ? Colors.red.withValues(alpha: 0.3) : AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
              reading.source == 'device'
                  ? Icons.monitor_heart_outlined
                  : Icons.edit_outlined,
              color: AppColors.textLight,
              size: 16),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Wrap(
              spacing: AppSpacing.sm,
              children: [
                if (reading.heartRate != null)
                  _Chip(
                      icon: Icons.favorite,
                      color: AppColors.primary,
                      label: '${reading.heartRate!.toStringAsFixed(0)} BPM',
                      alert: (reading.heartRate ?? 0) > 160),
                if (reading.temperature != null)
                  _Chip(
                      icon: Icons.thermostat,
                      color: Colors.orange,
                      label: '${reading.temperature!.toStringAsFixed(1)}°C',
                      alert: (reading.temperature ?? 0) > 37.5),
                if (reading.kicks != null)
                  _Chip(
                      icon: Icons.child_care,
                      color: Colors.purple,
                      label: '${reading.kicks} kicks'),
              ],
            ),
          ),
          Text(_formatTime(reading.time),
              style:
                  AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final bool alert;
  const _Chip(
      {required this.icon,
      required this.color,
      required this.label,
      this.alert = false});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: (alert ? Colors.red : color).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: alert ? Colors.red : color, size: 11),
          const SizedBox(width: 3),
          Text(label,
              style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 11,
                  color: alert ? Colors.red : AppColors.textDark)),
        ]),
      );
}

class _AlertsTab extends StatelessWidget {
  final List<_AlertLog> alerts;
  const _AlertsTab({required this.alerts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: alerts.length,
      itemBuilder: (_, i) => _AlertTile(alert: alerts[i]),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.full)),
            child: Text(alert.level,
                style: AppTextStyles.bodySmall.copyWith(color: color)),
          ),
          const Spacer(),
          Text(alert.time,
              style:
                  AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
        ]),
        const SizedBox(height: AppSpacing.sm),
        Text(alert.title,
            style:
                AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(alert.details,
            style:
                AppTextStyles.bodySmall.copyWith(color: AppColors.textMedium)),
      ]),
    );
  }
}

// ── Manual Entry Sheet ────────────────────────────────────────────────────────

class _ManualEntrySheet extends StatefulWidget {
  final void Function(_Reading) onSave;
  const _ManualEntrySheet({required this.onSave});

  @override
  State<_ManualEntrySheet> createState() => _ManualEntrySheetState();
}

class _ManualEntrySheetState extends State<_ManualEntrySheet> {
  final _bpmCtrl = TextEditingController();
  final _tempCtrl = TextEditingController();
  final _kickCtrl = TextEditingController();

  @override
  void dispose() {
    _bpmCtrl.dispose();
    _tempCtrl.dispose();
    _kickCtrl.dispose();

    super.dispose();
  }

  void _save() {
    final r = _Reading(
      time: DateTime.now(),
      heartRate: double.tryParse(_bpmCtrl.text),
      temperature: double.tryParse(_tempCtrl.text),
      kicks: int.tryParse(_kickCtrl.text),
      source: 'manual',
    );
    widget.onSave(r);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Text('Log Reading Manually', style: AppTextStyles.heading3),
              const Spacer(),
              IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context)),
            ]),
            Text('Fill in what you know — all fields are optional',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textLight)),
            const SizedBox(height: AppSpacing.lg),
            Row(children: [
              Expanded(
                  child: _EntryField(
                      label: 'Heart Rate (BPM)',
                      ctrl: _bpmCtrl,
                      hint: '140',
                      icon: Icons.favorite,
                      color: AppColors.primary)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                  child: _EntryField(
                      label: 'Temperature (°C)',
                      ctrl: _tempCtrl,
                      hint: '36.6',
                      icon: Icons.thermostat,
                      color: Colors.orange)),
            ]),
            const SizedBox(height: AppSpacing.md),
            Row(children: [
              Expanded(
                  child: _EntryField(
                      label: 'Kick Count',
                      ctrl: _kickCtrl,
                      hint: '5',
                      icon: Icons.child_care,
                      color: Colors.purple)),
              const SizedBox(width: AppSpacing.md),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.full)),
                  ),
                  child: const Text('Save Reading',
                      style: AppTextStyles.buttonText),
                ),
              ),
            ]),
          ]),
    );
  }
}

class _EntryField extends StatelessWidget {
  final String label, hint;
  final TextEditingController ctrl;
  final IconData icon;
  final Color color;
  const _EntryField(
      {required this.label,
      required this.hint,
      required this.ctrl,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style:
                AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: color, size: 16),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: color)),
          ),
        ),
      ]);
}
