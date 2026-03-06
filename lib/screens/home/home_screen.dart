// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';
import '../../widgets/feature_card.dart';
import '../../services/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentWeek = 7;
  int _daysToGo = 228;
  double _progress = 0.189; // 18.9%

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section with progress ring
              _HeaderSection(
                currentWeek: _currentWeek,
                daysToGo: _daysToGo,
                progress: _progress,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Feature grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: _FeatureGrid(),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(),
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Top row - greeting
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<AuthProvider>(
                builder: (_, auth, __) => Text(
                  'Hi, ${auth.user?.fullName.split(' ').first ?? 'Mama'} 👋',
                  style: AppTextStyles.heading3.copyWith(color: Colors.white),
                ),
              ),
              GestureDetector(
                onTap: () => context.read<AuthProvider>().logout().then(
                      (_) => Navigator.pushReplacementNamed(
                          context, AppRoutes.login),
                    ),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.24),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Progress ring + stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Left stat
              _StatItem(
                value: '${(progress * 100).toStringAsFixed(1)}%',
                label: 'done',
                color: Colors.white,
              ),

              // Ring progress
              _WeekRing(week: currentWeek, progress: progress),

              // Right stat
              _StatItem(
                value: '$daysToGo',
                label: 'days to go',
                color: Colors.white,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),
          Text(
            '+3 day',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heading2.copyWith(color: color),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall
              .copyWith(color: Colors.white.withValues(alpha: 0.7)),
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
      width: 110,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(110, 110),
            painter: _RingPainter(progress: progress),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'WEEK',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 10,
                ),
              ),
              Text(
                '$week',
                style: AppTextStyles.heading1.copyWith(
                  color: Colors.white,
                  fontSize: 36,
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

  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 10) / 2;

    // Background ring
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14 / 2,
      2 * 3.14 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.progress != progress;
}

class _FeatureGrid extends StatelessWidget {
  final List<_FeatureItem> features = const [
    _FeatureItem(
      title: 'Health report\nin PDF',
      color: AppColors.cardBlue,
      icon: Icons.health_and_safety,
    ),
    _FeatureItem(
      title: 'Weight\nTracker',
      color: AppColors.cardMint,
      icon: Icons.monitor_weight,
    ),
    _FeatureItem(
      title: 'Kick Counter',
      color: AppColors.cardLavender,
      icon: Icons.touch_app,
    ),
    _FeatureItem(
      title: 'Contractions\nCalculator',
      color: AppColors.cardPeach,
      icon: Icons.timer,
    ),
    _FeatureItem(
      title: 'Tummy\nGrowth',
      color: AppColors.cardYellow,
      icon: Icons.pregnant_woman,
    ),
    _FeatureItem(
      title: 'Pressure\nMonitor',
      color: AppColors.cardPink,
      icon: Icons.favorite,
    ),
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
        childAspectRatio: 1.35,
      ),
      itemCount: features.length,
      itemBuilder: (ctx, i) {
        final feature = features[i];
        return FeatureCard(
          title: feature.title,
          backgroundColor: feature.color,
          icon: Icon(feature.icon,
              color: Colors.white.withValues(alpha: 0.7), size: 36),
          onTap: () {
            // TODO: navigate to each feature screen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      '${feature.title.replaceAll('\n', ' ')} coming soon!')),
            );
          },
        );
      },
    );
  }
}

class _FeatureItem {
  final String title;
  final Color color;
  final IconData icon;

  const _FeatureItem({
    required this.title,
    required this.color,
    required this.icon,
  });
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home_rounded, label: 'Home', isActive: true),
          _NavItem(icon: Icons.favorite_border, label: 'Health'),
          _NavItem(icon: Icons.chat_bubble_outline, label: 'Chat'),
          _NavItem(icon: Icons.person_outline, label: 'Profile'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? AppColors.primary : AppColors.textLight,
          size: 24,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isActive ? AppColors.primary : AppColors.textLight,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
