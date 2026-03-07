// lib/screens/monitor/monitor_screen.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';
import '../graphs/graphs_screen.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  final _random = Random();
  Timer? _timer;

  // Sensor values
  double _heartbeat = 142;
  int _kickCount = 3;
  double _temperature = 36.7;
  double _movement = 0.4;
  double _oxygenLevel = 98.2;

  // Update interval in hours (default 2)
  double _updateIntervalHours = 2;
  DateTime _lastUpdated = DateTime.now();

  final List<double> _heartbeatHistory = [138, 140, 142, 141, 143, 142];

  @override
  void initState() {
    super.initState();
    _startUpdates();
  }

  void _startUpdates() {
    _timer?.cancel();
    // For demo: update every few seconds to show live feel
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        setState(() {
          _heartbeat = 138 + _random.nextDouble() * 10;
          _temperature = 36.4 + _random.nextDouble() * 0.6;
          _movement = _random.nextDouble();
          _oxygenLevel = 97 + _random.nextDouble() * 2;
          _lastUpdated = DateTime.now();
          _heartbeatHistory.add(_heartbeat);
          if (_heartbeatHistory.length > 20) _heartbeatHistory.removeAt(0);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showIntervalPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _IntervalPickerSheet(
        current: _updateIntervalHours,
        onSelected: (val) {
          setState(() => _updateIntervalHours = val);
          _startUpdates();
          Navigator.pop(context);
        },
      ),
    );
  }

  String get _lastUpdatedText {
    final diff = DateTime.now().difference(_lastUpdated);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
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
        title: Text('Live Monitor', style: AppTextStyles.heading3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart, color: AppColors.primary),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => GraphsScreen(
                          heartbeatHistory: _heartbeatHistory,
                        ))),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Update interval bar
            _UpdateIntervalBar(
              intervalHours: _updateIntervalHours,
              lastUpdated: _lastUpdatedText,
              onTap: _showIntervalPicker,
            ),

            const SizedBox(height: AppSpacing.md),

            // Device status
            _DeviceStatusBar(),

            const SizedBox(height: AppSpacing.lg),

            // Main heartbeat card (large)
            _HeartbeatCard(bpm: _heartbeat, history: _heartbeatHistory),

            const SizedBox(height: AppSpacing.md),

            // 2-col grid for other metrics
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.child_care,
                    iconColor: Colors.purple,
                    label: 'Kicks Today',
                    value: '$_kickCount',
                    unit: 'kicks',
                    status: _kickCount >= 10 ? 'Normal' : 'Low',
                    statusColor:
                        _kickCount >= 10 ? Colors.green : Colors.orange,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.thermostat,
                    iconColor: Colors.orange,
                    label: 'Temperature',
                    value: _temperature.toStringAsFixed(1),
                    unit: '°C',
                    status: _temperature < 37.5 ? 'Normal' : 'High',
                    statusColor:
                        _temperature < 37.5 ? Colors.green : Colors.red,
                    onTap: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.waves,
                    iconColor: Colors.blue,
                    label: 'Movement',
                    value: (_movement * 100).toStringAsFixed(0),
                    unit: '%',
                    status: _movement > 0.2 ? 'Active' : 'Resting',
                    statusColor: _movement > 0.2 ? Colors.green : Colors.grey,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.air,
                    iconColor: Colors.teal,
                    label: 'Oxygen SpO₂',
                    value: _oxygenLevel.toStringAsFixed(1),
                    unit: '%',
                    status: _oxygenLevel >= 95 ? 'Normal' : 'Low',
                    statusColor: _oxygenLevel >= 95 ? Colors.green : Colors.red,
                    onTap: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Add kick manually
            _AddKickCard(
              kickCount: _kickCount,
              onAdd: () => setState(() => _kickCount++),
              onReset: () => setState(() => _kickCount = 0),
            ),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _UpdateIntervalBar extends StatelessWidget {
  final double intervalHours;
  final String lastUpdated;
  final VoidCallback onTap;

  const _UpdateIntervalBar({
    required this.intervalHours,
    required this.lastUpdated,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_outlined,
              color: AppColors.primary, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Update me every',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textLight)),
                Text(
                  intervalHours == 0.5
                      ? '30 minutes'
                      : intervalHours == 1
                          ? '1 hour'
                          : '${intervalHours.toInt()} hours',
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Text('Updated: $lastUpdated',
              style:
                  AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text('Change',
                  style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceStatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
        ),
        const SizedBox(width: 6),
        Text('Mamaconnect Monitor • Connected',
            style:
                AppTextStyles.bodySmall.copyWith(color: AppColors.textMedium)),
        const Spacer(),
        const Icon(Icons.battery_5_bar, color: Colors.green, size: 16),
        Text(' 87%',
            style:
                AppTextStyles.bodySmall.copyWith(color: AppColors.textMedium)),
      ],
    );
  }
}

class _HeartbeatCard extends StatelessWidget {
  final double bpm;
  final List<double> history;

  const _HeartbeatCard({required this.bpm, required this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFFD4614A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text('Baby Heartbeat',
                  style:
                      AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text('Normal',
                    style:
                        AppTextStyles.bodySmall.copyWith(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(bpm.toStringAsFixed(0),
                  style: AppTextStyles.heading1
                      .copyWith(color: Colors.white, fontSize: 52)),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('BPM',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: Colors.white.withValues(alpha: 0.8))),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Normal range: 120–160 BPM',
              style: AppTextStyles.bodySmall
                  .copyWith(color: Colors.white.withValues(alpha: 0.7))),
          const SizedBox(height: AppSpacing.md),
          // Mini waveform
          SizedBox(
            height: 40,
            child: CustomPaint(
              size: const Size(double.infinity, 40),
              painter: _WaveformPainter(values: history),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> values;
  const _WaveformPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV).clamp(1.0, double.infinity);

    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * size.width;
      final y = size.height - ((values[i] - minV) / range) * size.height;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter old) => old.values != values;
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;
  final String status;
  final Color statusColor;
  final VoidCallback onTap;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
    required this.status,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 18),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(status,
                      style: AppTextStyles.bodySmall.copyWith(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(label,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textLight)),
            const SizedBox(height: AppSpacing.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value,
                    style: AppTextStyles.heading2.copyWith(fontSize: 24)),
                const SizedBox(width: 3),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(unit,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textLight)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddKickCard extends StatelessWidget {
  final int kickCount;
  final VoidCallback onAdd;
  final VoidCallback onReset;

  const _AddKickCard({
    required this.kickCount,
    required this.onAdd,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Manual Kick Counter',
              style: AppTextStyles.bodyLarge
                  .copyWith(fontWeight: FontWeight.w600)),
          Text('Tap each time you feel a kick',
              style:
                  AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$kickCount kicks',
                      style: AppTextStyles.heading2
                          .copyWith(color: AppColors.primary)),
                  Text('recorded today',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textLight)),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: onReset,
                child: Text('Reset',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textMedium)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IntervalPickerSheet extends StatelessWidget {
  final double current;
  final ValueChanged<double> onSelected;

  const _IntervalPickerSheet({required this.current, required this.onSelected});

  static const _options = [
    (label: '30 minutes', value: 0.5),
    (label: '1 hour', value: 1.0),
    (label: '2 hours', value: 2.0),
    (label: '4 hours', value: 4.0),
    (label: '6 hours', value: 6.0),
    (label: '12 hours', value: 12.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Update Interval', style: AppTextStyles.heading3),
          Text('How often should we check in?',
              style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          ..._options.map((opt) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(opt.label, style: AppTextStyles.bodyLarge),
                trailing: opt.value == current
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : const Icon(Icons.radio_button_unchecked,
                        color: AppColors.textLight),
                onTap: () => onSelected(opt.value),
              )),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
