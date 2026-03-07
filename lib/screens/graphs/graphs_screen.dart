// lib/screens/graphs/graphs_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';

class GraphsScreen extends StatefulWidget {
  final List<double> heartbeatHistory;

  const GraphsScreen({super.key, required this.heartbeatHistory});

  @override
  State<GraphsScreen> createState() => _GraphsScreenState();
}

class _GraphsScreenState extends State<GraphsScreen> {
  int _selectedTab = 0;
  final _tabs = ['Heart Rate', 'Temperature', 'Movement', 'SpO₂'];

  // Generate mock weekly data
  final _random = Random(42);
  late final Map<String, List<_DataPoint>> _weeklyData;

  @override
  void initState() {
    super.initState();
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    _weeklyData = {
      'Heart Rate': days
          .map((d) => _DataPoint(d, 135 + _random.nextDouble() * 20))
          .toList(),
      'Temperature': days
          .map((d) => _DataPoint(d, 36.3 + _random.nextDouble() * 0.8))
          .toList(),
      'Movement':
          days.map((d) => _DataPoint(d, _random.nextDouble() * 100)).toList(),
      'SpO₂': days
          .map((d) => _DataPoint(d, 95 + _random.nextDouble() * 4))
          .toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final data = _weeklyData[_tabs[_selectedTab]]!;
    final minVal = data.map((e) => e.value).reduce(min);
    final maxVal = data.map((e) => e.value).reduce(max);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Health Graphs', style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  final active = i == _selectedTab;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = i),
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
                      child: Text(
                        _tabs[i],
                        style: AppTextStyles.bodySmall.copyWith(
                          color: active ? Colors.white : AppColors.textMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Summary cards
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: 'Average',
                    value: (data.map((e) => e.value).reduce((a, b) => a + b) /
                            data.length)
                        .toStringAsFixed(1),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _SummaryCard(
                      label: 'Min',
                      value: minVal.toStringAsFixed(1),
                      color: Colors.blue),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _SummaryCard(
                      label: 'Max',
                      value: maxVal.toStringAsFixed(1),
                      color: Colors.orange),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Chart
            Container(
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
                  Text('This Week',
                      style: AppTextStyles.bodyLarge
                          .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 200,
                    child: CustomPaint(
                      size: const Size(double.infinity, 200),
                      painter: _BarChartPainter(
                        data: data,
                        minVal: minVal,
                        maxVal: maxVal,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Live feed (last readings)
            Text('Recent Readings',
                style: AppTextStyles.bodyLarge
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            ...widget.heartbeatHistory.reversed
                .take(5)
                .toList()
                .asMap()
                .entries
                .map((e) => _ReadingRow(
                      index: e.key,
                      value: e.value.toStringAsFixed(1),
                      unit: _tabs[_selectedTab] == 'Heart Rate' ? 'BPM' : '',
                    )),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryCard(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Text(value, style: AppTextStyles.heading3.copyWith(color: color)),
          Text(label,
              style:
                  AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
        ],
      ),
    );
  }
}

class _ReadingRow extends StatelessWidget {
  final int index;
  final String value;
  final String unit;

  const _ReadingRow(
      {required this.index, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Text('#${index + 1}',
              style:
                  AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
          const Spacer(),
          Text('$value $unit',
              style: AppTextStyles.bodyMedium
                  .copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _DataPoint {
  final String label;
  final double value;
  const _DataPoint(this.label, this.value);
}

class _BarChartPainter extends CustomPainter {
  final List<_DataPoint> data;
  final double minVal;
  final double maxVal;

  const _BarChartPainter(
      {required this.data, required this.minVal, required this.maxVal});

  @override
  void paint(Canvas canvas, Size size) {
    final range = (maxVal - minVal).clamp(1.0, double.infinity);
    final barWidth = (size.width / data.length) * 0.5;
    final spacing = size.width / data.length;
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < data.length; i++) {
      final x = i * spacing + spacing / 2;
      final normalised = (data[i].value - minVal) / range;
      final barHeight = normalised * (size.height - 30);
      final top = size.height - 20 - barHeight;

      final rRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x - barWidth / 2, top, barWidth, barHeight),
        const Radius.circular(4),
      );
      canvas.drawRRect(
          rRect, paint..color = AppColors.primary.withValues(alpha: 0.85));

      // Label
      textPainter.text = TextSpan(
        text: data[i].label,
        style: const TextStyle(fontSize: 10, color: Color(0xFF9E9E9E)),
      );
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(x - textPainter.width / 2, size.height - 16));
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) => old.data != data;
}
