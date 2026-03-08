import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';
import '../timeline/timeline_screen.dart';
import '../bluetooth/bluetooth_screen.dart';
import '../alerts/alerts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentWeek = 7;
  final int _daysToGo = 228;
  final double _progress = 0.189;

  void _onVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    if (velocity > 500) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const TimelineScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: _onVerticalDragEnd,
      child: Container(
        color: AppColors.background,
        child: Column(
          children: [
            // Header
            _HeaderSection(
              currentWeek: _currentWeek,
              daysToGo: _daysToGo,
              progress: _progress,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
              child: Row(
                children: [
                  _QuickAction(
                    icon: Icons.bluetooth,
                    label: 'Connect',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const BluetoothScreen())),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _QuickAction(
                    icon: Icons.notifications_outlined,
                    label: 'Alerts',
                    badge: true,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AlertsScreen())),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _QuickAction(
                    icon: Icons.timeline,
                    label: 'Timeline',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TimelineScreen())),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.sm),
            // Feature Grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: _FeatureGrid(),
              ),
            ),

            // Chatbot Button
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sm,
                horizontal: AppSpacing.md,
              ),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/chatbot'),
                child: const CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.smart_toy_outlined,
                      color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool badge;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, color: AppColors.primary, size: 18),
                  if (badge)
                    Positioned(
                      top: -3,
                      right: -3,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 6),
              Text(label,
                  style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textDark, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final int currentWeek;
  final int daysToGo;
  final double progress;

  const _HeaderSection({
    required this.currentWeek,
    required this.daysToGo,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8856A), Color(0xFFD4614A)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.only(
        top: 56,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: AppSpacing.lg,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _StatItem(
                value: '${(progress * 100).toStringAsFixed(1)}%',
                label: 'DONE',
              ),
              _WeekRing(
                week: currentWeek,
                progress: progress,
              ),
              _StatItem(
                value: '$daysToGo',
                label: 'DAYS TO GO',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white.withValues(alpha: 0.8),
            size: 28,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heading2.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _WeekRing extends StatelessWidget {
  final int week;
  final double progress;

  const _WeekRing({required this.week, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(120, 120),
            painter: _RingPainter(progress: progress),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'WEEK',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
              Text(
                '$week',
                style: AppTextStyles.heading1.copyWith(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
              Text(
                '+3 day',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;

  const _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 12) / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      2 * 3.14159 * progress,
      false,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _FeatureGrid extends StatelessWidget {
  final List<_FeatureItem> _items = const [
    _FeatureItem(label: 'Safe Medicines', icon: Icons.medication_outlined),
    _FeatureItem(
        label: 'Hospitals nearby', icon: Icons.local_hospital_outlined),
    _FeatureItem(label: 'log history', icon: Icons.article_outlined),
    _FeatureItem(label: 'symptoms tracker', icon: Icons.play_circle_outline),
    _FeatureItem(label: 'recommended diets', icon: Icons.restaurant_outlined),
    _FeatureItem(label: 'Workout plans', icon: Icons.directions_walk_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.3,
      ),
      itemCount: _items.length,
      itemBuilder: (context, i) => _FeatureCard(item: _items[i]),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final _FeatureItem item;

  const _FeatureCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final route = _routeForFeature(item.label);
        if (route != null) {
          Navigator.pushNamed(context, route);
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.label} coming soon!')),
        );
      },
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              item.label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem {
  final String label;
  final IconData icon;

  const _FeatureItem({required this.label, required this.icon});
}

String? _routeForFeature(String label) {
  switch (label.toLowerCase()) {
    case 'safe medicines':
      return '/medicines';
    case 'hospitals nearby':
      return '/hospitals';
    case 'log history':
      return '/logs-history';
    case 'symptoms tracker':
      return '/symptoms';
    case 'recommended diets':
      return '/diets';
    case 'workout plans':
      return '/workouts';
    default:
      return null;
  }
}
