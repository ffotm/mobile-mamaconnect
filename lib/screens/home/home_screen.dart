// lib/screens/home/home_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../timeline/timeline_screen.dart';
import '../bluetooth/bluetooth_screen.dart';
import '../alerts/alerts_screen.dart';
import '../history/logs_history_screen.dart';
import '../../widgets/next_appointment_alert.dart';

// ─────────────────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _week = 7;
  final int _daysToGo = 228;
  final double _progress = 0.189;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EFEC),
      body: Stack(
        children: [
          Column(
            children: [
              // ── Wave hero ────────────────────────────────────────────────
              _WaveHero(week: _week, daysToGo: _daysToGo, progress: _progress),
              const NextAppointmentAlert(),
              // ── Quick actions row ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Row(children: [
                  _QBtn(
                      icon: Icons.bluetooth_rounded,
                      label: 'Connect',
                      onTap: () => _push(const BluetoothScreen())),
                  const SizedBox(width: 10),
                  _QBtn(
                      icon: Icons.notifications_outlined,
                      label: 'Alerts',
                      badge: true,
                      onTap: () => _push(const AlertsScreen())),
                  const SizedBox(width: 10),
                  _QBtn(
                      icon: Icons.view_timeline_outlined,
                      label: 'Timeline',
                      onTap: () => _push(const TimelineScreen())),
                ]),
              ),

              const SizedBox(height: 14),

              // ── Feature grid ─────────────────────────────────────────────
              const Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 0, 16, 20),
                  child: _Grid(),
                ),
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 30,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.chatbot),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9690), Color(0xFFA53A2D)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCC3D22).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Chat with AI Assistant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _push(Widget screen) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
}

class _WaveHero extends StatelessWidget {
  final int week, daysToGo;
  final double progress;
  const _WaveHero(
      {required this.week, required this.daysToGo, required this.progress});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return SizedBox(
      width: double.infinity,
      height: top + 270,
      child: Stack(children: [
        // ── gradient fill clipped to wave ─────────────────────────────
        ClipPath(
          clipper: _WaveClipper(),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                // vivid warm coral → deep brick — matches reference exactly
                colors: [Color(0xFFFF9690), Color(0xFFA53A2D)],
              ),
            ),
          ),
        ),

        // ── content ───────────────────────────────────────────────────
        Positioned(
          top: top + 40,
          left: 24,
          right: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Stat(
                  value: '${(progress * 100).toStringAsFixed(1)}%',
                  sub: 'DONE'),
              _Ring(week: week, progress: progress),
              _Stat(value: '$daysToGo', sub: 'DAYS TO GO'),
            ],
          ),
        ),

        // ── swipe hint ─────────────────────────────────────────────
        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          child: Center(
              child: Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.white.withValues(alpha: 0.6), size: 26)),
        ),
      ]),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    final p = Path()..lineTo(0, s.height - 60);

    p.quadraticBezierTo(
      s.width * 0.5,
      s.height + 10,
      s.width,
      s.height - 60,
    );

    p.lineTo(s.width, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(_) => false;
}

class _Stat extends StatelessWidget {
  final String value, sub;
  const _Stat({required this.value, required this.sub});
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins')),
          const SizedBox(height: 2),
          Text(sub,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 10,
                  letterSpacing: 1.3,
                  fontFamily: 'Poppins')),
        ],
      );
}

class _Ring extends StatelessWidget {
  final int week;
  final double progress;
  const _Ring({required this.week, required this.progress});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 150,
        height: 150,
        child: Stack(alignment: Alignment.center, children: [
          CustomPaint(
              size: const Size(180, 180), painter: _RingPaint(progress)),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Text('WEEK',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    fontFamily: 'Poppins')),
            Text('$week',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    height: 1.0)),
            Text('+3 day',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins')),
          ]),
        ]),
      );
}

class _RingPaint extends CustomPainter {
  final double progress;
  const _RingPaint(this.progress);
  @override
  void paint(Canvas canvas, Size s) {
    final c = s.center(Offset.zero);
    final r = (s.width + 3) / 2;
    // track
    canvas.drawCircle(
        c,
        r,
        Paint()
          ..color =
              const Color.fromARGB(255, 65, 39, 39).withValues(alpha: 0.28)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);
    // arc
    canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant _RingPaint o) => o.progress != progress;
}

class _QBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool badge;
  final VoidCallback onTap;
  const _QBtn(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.badge = false});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFFCC3D22).withValues(alpha: 0.07),
                    blurRadius: 6,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Stack(clipBehavior: Clip.none, children: [
                Icon(icon, color: AppColors.primary, size: 17),
                if (badge)
                  Positioned(
                      top: -3,
                      right: -3,
                      child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red))),
              ]),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D2D2D),
                      fontFamily: 'Poppins')),
            ]),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Feature grid
// ─────────────────────────────────────────────────────────────────────────────

class _Cell {
  final String label;
  final IconData icon;
  final Color color;
  final String route;
  const _Cell(this.label, this.icon, this.color, this.route);
}

const _cells = [
  _Cell('Safe Medicines', Icons.medication, Color(0xFFE64646), '/medicines'),
  _Cell('Hospitals Nearby', Icons.local_hospital, Color(0xFFEB7155),
      '/hospitals'),
  _Cell('Log History', Icons.bar_chart, Color(0xFF8B5CF6), '/logs'),
  _Cell(
      'Symptom Tracker', Icons.favorite_border, Color(0xFFE84393), '/symptoms'),
  _Cell('Recommended Diets', Icons.restaurant, Color(0xFF10B981), '/diet'),
  _Cell('Workout Plans', Icons.directions_run, Color(0xFFF59E0B), '/workouts'),
];

class _Grid extends StatelessWidget {
  const _Grid();
  @override
  Widget build(BuildContext context) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
        ),
        itemCount: _cells.length,
        itemBuilder: (ctx, i) => _Tile(_cells[i]),
      );
}

class _Tile extends StatelessWidget {
  final _Cell cell;
  const _Tile(this.cell);
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.pushNamed(context, cell.route),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: cell.color.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 3))
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cell.color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(cell.icon, color: cell.color, size: 22),
            ),
            const SizedBox(width: 11),
            Expanded(
                child: Text(cell.label,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2A2A2A),
                        height: 1.25,
                        fontFamily: 'Poppins'))),
          ]),
        ),
      );
}
