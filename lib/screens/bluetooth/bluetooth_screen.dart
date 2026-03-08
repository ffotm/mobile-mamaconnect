// lib/screens/bluetooth/bluetooth_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';
import '../../widgets/primary_button.dart';
import '../monitor/monitor_screen.dart';

enum _BtState { searching, found, connecting, connected }

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen>
    with SingleTickerProviderStateMixin {
  _BtState _state = _BtState.searching;
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Simulate "found device" after 2.5s
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _state = _BtState.found);
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  void _onConnect() {
    setState(() => _state = _BtState.connecting);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _state = _BtState.connected);
    });
  }

  void _onContinue() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MonitorScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: _state != _BtState.connected
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text('Bluetooth', style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _BtState.searching:
        return _SearchingView(spinController: _spinController);
      case _BtState.found:
        return _FoundView(onConnect: _onConnect);
      case _BtState.connecting:
        return _ConnectingView(spinController: _spinController);
      case _BtState.connected:
        return _ConnectedView(onContinue: _onContinue);
    }
  }
}

// ── 1. Searching ──────────────────────────────────────────────────────────────
class _SearchingView extends StatelessWidget {
  final AnimationController spinController;
  const _SearchingView({required this.spinController});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('searching'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: spinController,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
              child: const Icon(Icons.bluetooth,
                  color: AppColors.primary, size: 36),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Searching for devices...', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Make sure your device is nearby\nand powered on',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) => _Dot(delay: i * 300)),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _a = Tween(begin: 0.3, end: 1.0)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _c.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _a,
      child: Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// ── 2. Found ──────────────────────────────────────────────────────────────────
class _FoundView extends StatelessWidget {
  final VoidCallback onConnect;
  const _FoundView({required this.onConnect});

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: const ValueKey('found'),
      children: [
        // Greyed background
        Container(color: Colors.black.withValues(alpha: 0.3)),
        // Bottom sheet style card
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  child: const Icon(Icons.monitor_heart_outlined,
                      color: AppColors.primary, size: 30),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Mamaconnect Monitor', style: AppTextStyles.heading3),
                const SizedBox(height: AppSpacing.xs),
                Text('Ready to connect',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textLight)),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(label: 'Connect', onPressed: onConnect),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () {},
                  child: Text('Not your device?',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textMedium)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── 3. Connecting ─────────────────────────────────────────────────────────────
class _ConnectingView extends StatelessWidget {
  final AnimationController spinController;
  const _ConnectingView({required this.spinController});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('connecting'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            height: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                RotationTransition(
                  turns: spinController,
                  child: CustomPaint(
                    size: const Size(90, 90),
                    painter: _DashedCirclePainter(),
                  ),
                ),
                const Icon(Icons.bluetooth_searching,
                    color: AppColors.primary, size: 32),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Connecting to\nMamaconnect Monitor...',
              textAlign: TextAlign.center, style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.sm),
          Text('This will only take a moment', style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          const SizedBox(
            width: 180,
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              backgroundColor: AppColors.primaryLight,
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const dashCount = 12;
    const gap = 0.18;
    const arc = (2 * 3.14159 / dashCount) - gap;
    for (int i = 0; i < dashCount; i++) {
      final start = i * (arc + gap) - 3.14159 / 2;
      canvas.drawArc(
        Rect.fromLTWH(4, 4, size.width - 8, size.height - 8),
        start,
        arc,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── 4. Connected ──────────────────────────────────────────────────────────────
class _ConnectedView extends StatelessWidget {
  final VoidCallback onContinue;
  const _ConnectedView({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('connected'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 36),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Connected Successfully!', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.xs),
          Text('Your Mamaconnect Monitor is ready to use',
              style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Device Information',
                    style: AppTextStyles.bodyLarge
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.md),
                const _DeviceInfoRow(
                  icon: Icons.battery_full,
                  iconColor: Colors.green,
                  label: 'Battery',
                  value: '87%',
                  valueColor: AppColors.textDark,
                ),
                const SizedBox(height: AppSpacing.sm),
                _DeviceInfoRow(
                  icon: Icons.circle,
                  iconColor: Colors.green,
                  label: 'Status',
                  value: 'Connected',
                  valueColor: Colors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(label: 'Continue', onPressed: onContinue),
        ],
      ),
    );
  }
}

class _DeviceInfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  const _DeviceInfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: AppTextStyles.bodyMedium),
        const Spacer(),
        Text(value,
            style: AppTextStyles.bodyMedium
                .copyWith(color: valueColor, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
