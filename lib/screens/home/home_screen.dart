// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:mamacita/services/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';
import '../timeline/timeline_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentWeek = 7;
  final int _daysToGo = 228;
  final double _progress = 0.189;

  int _bottomNavIndex = 0;

  void _onVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    // Pull DOWN → open timeline
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
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // Header
            _HeaderSection(
              currentWeek: _currentWeek,
              daysToGo: _daysToGo,
              progress: _progress,
            ),

            // Feature Grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: _FeatureGrid(),
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sm,
                horizontal: AppSpacing.md,
              ),
              child: GestureDetector(
                onTap: () => context.read<AuthProvider>().logout().then(
                      (_) => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.login,
                      ),
                    ),
                child: const CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.logout, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _BottomNav(
          currentIndex: _bottomNavIndex,
          onTap: (i) => setState(() => _bottomNavIndex = i),
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
    _FeatureItem(label: 'Medicines', icon: Icons.medication_outlined),
    _FeatureItem(label: 'Exercises', icon: Icons.directions_walk_outlined),
    _FeatureItem(label: 'Hospitals', icon: Icons.local_hospital_outlined),
    _FeatureItem(label: 'Articles', icon: Icons.article_outlined),
    _FeatureItem(label: 'Videos', icon: Icons.play_circle_outline),
    _FeatureItem(label: 'Food', icon: Icons.restaurant_outlined),
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

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.people_outline, label: 'Social'),
    _NavItem(icon: Icons.storefront_outlined, label: 'Shop'),
    _NavItem(icon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: List.generate(_items.length, (i) {
          final active = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _items[i].icon,
                  color: active ? AppColors.primary : AppColors.textLight,
                ),
                const SizedBox(height: 2),
                Text(
                  _items[i].label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: active ? AppColors.primary : AppColors.textLight,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
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
