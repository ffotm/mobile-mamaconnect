// lib/screens/hospitals/hospitals_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';

class _Hospital {
  final String name;
  final String address;
  final String city;
  final String phone;
  final double distance; // km
  final double lat;
  final double lng;
  final String type;
  final bool hasMaternity;
  final bool isOpen24h;
  final List<String> services;

  const _Hospital({
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    required this.distance,
    required this.lat,
    required this.lng,
    required this.type,
    required this.hasMaternity,
    required this.isOpen24h,
    required this.services,
  });
}

const _hospitals = [
  _Hospital(
    name: 'CHU Mustapha Pacha',
    address: 'Place du 1er Mai, Sidi M\'hamed',
    city: 'Algiers',
    phone: '+213 21 23 53 00',
    distance: 1.2,
    lat: 36.7538,
    lng: 3.0588,
    type: 'University Hospital',
    hasMaternity: true,
    isOpen24h: true,
    services: ['Maternity', 'NICU', 'Emergency', 'Gynecology'],
  ),
  _Hospital(
    name: 'Clinique El Azhar',
    address: '12 Rue des Frères Belhaffaf, Bab El Oued',
    city: 'Algiers',
    phone: '+213 21 96 10 10',
    distance: 2.8,
    lat: 36.7755,
    lng: 3.0530,
    type: 'Private Clinic',
    hasMaternity: true,
    isOpen24h: true,
    services: ['Maternity', 'Prenatal Care', 'Ultrasound'],
  ),
  _Hospital(
    name: 'Hôpital Parnet',
    address: 'Hussein Dey',
    city: 'Algiers',
    phone: '+213 21 77 16 00',
    distance: 4.5,
    lat: 36.7372,
    lng: 3.1012,
    type: 'Public Hospital',
    hasMaternity: true,
    isOpen24h: false,
    services: ['Maternity', 'Gynecology', 'Prenatal Care'],
  ),
  _Hospital(
    name: 'Clinique Amara',
    address: 'Cité Aïn Allah, Dely Ibrahim',
    city: 'Algiers',
    phone: '+213 21 37 08 20',
    distance: 6.1,
    lat: 36.7572,
    lng: 2.9877,
    type: 'Private Clinic',
    hasMaternity: false,
    isOpen24h: false,
    services: ['Gynecology', 'Ultrasound', 'Prenatal Care'],
  ),
  _Hospital(
    name: 'CHU Frantz Fanon',
    address: 'Route de Tlemcen',
    city: 'Blida',
    phone: '+213 25 41 12 00',
    distance: 45.0,
    lat: 36.4700,
    lng: 2.8300,
    type: 'University Hospital',
    hasMaternity: true,
    isOpen24h: true,
    services: ['Maternity', 'NICU', 'Emergency', 'Gynecology'],
  ),
];

class HospitalsScreen extends StatefulWidget {
  const HospitalsScreen({super.key});

  @override
  State<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  String _search = '';
  bool _maternityOnly = false;
  bool _open24hOnly = false;

  List<_Hospital> get _filtered => _hospitals.where((h) {
        final matchSearch = _search.isEmpty ||
            h.name.toLowerCase().contains(_search.toLowerCase()) ||
            h.city.toLowerCase().contains(_search.toLowerCase());
        final matchMaternity = !_maternityOnly || h.hasMaternity;
        final match24h = !_open24hOnly || h.isOpen24h;
        return matchSearch && matchMaternity && match24h;
      }).toList()
        ..sort((a, b) => a.distance.compareTo(b.distance));

  Future<void> _openMaps(_Hospital h) async {
    // Tries Google Maps first, falls back to generic geo: URI
    final googleUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${h.lat},${h.lng}&query_place_id=${Uri.encodeComponent(h.name)}');
    final geoUrl =
        Uri.parse('geo:${h.lat},${h.lng}?q=${Uri.encodeComponent(h.name)}');

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(geoUrl)) {
      await launchUrl(geoUrl);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open maps app')),
        );
      }
    }
  }

  Future<void> _callHospital(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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
        title: const Text('Nearby Hospitals', style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Search & filters ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _search = v),
                  decoration: InputDecoration(
                    hintText: 'Search hospitals...',
                    hintStyle: AppTextStyles.hintText,
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.textLight),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: AppColors.textLight),
                    Text('  Sorted by distance from you',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textLight)),
                    const Spacer(),
                    _FilterToggle(
                      label: '🤱 Maternity',
                      active: _maternityOnly,
                      onTap: () =>
                          setState(() => _maternityOnly = !_maternityOnly),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _FilterToggle(
                      label: '24h',
                      active: _open24hOnly,
                      onTap: () => setState(() => _open24hOnly = !_open24hOnly),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Hospital list ────────────────────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_hospital_outlined,
                            size: 48, color: AppColors.textLight),
                        SizedBox(height: AppSpacing.md),
                        Text('No hospitals found',
                            style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _HospitalCard(
                      hospital: _filtered[i],
                      onDirections: () => _openMaps(_filtered[i]),
                      onCall: () => _callHospital(_filtered[i].phone),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _HospitalDetailScreen(
                            hospital: _filtered[i],
                            onDirections: () => _openMaps(_filtered[i]),
                            onCall: () => _callHospital(_filtered[i].phone),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterToggle extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterToggle(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border:
              Border.all(color: active ? AppColors.primary : AppColors.border),
        ),
        child: Text(label,
            style: AppTextStyles.bodySmall.copyWith(
                color: active ? Colors.white : AppColors.textMedium,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _HospitalCard extends StatelessWidget {
  final _Hospital hospital;
  final VoidCallback onDirections;
  final VoidCallback onCall;
  final VoidCallback onTap;

  const _HospitalCard({
    required this.hospital,
    required this.onDirections,
    required this.onCall,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(Icons.local_hospital_outlined,
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(hospital.name,
                          style: AppTextStyles.bodyLarge
                              .copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(hospital.type,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.primary)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 12, color: AppColors.textLight),
                          Expanded(
                            child: Text(
                              ' ${hospital.address}, ${hospital.city}',
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: AppColors.textLight),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Distance badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${hospital.distance} km',
                        style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700)),
                    Text('away',
                        style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textLight, fontSize: 10)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // Tags
            Row(
              children: [
                if (hospital.hasMaternity)
                  const _Tag(label: '🤱 Maternity', color: Colors.purple),
                if (hospital.hasMaternity) const SizedBox(width: 6),
                if (hospital.isOpen24h)
                  const _Tag(label: '🕐 Open 24h', color: Colors.green),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.sm),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onCall,
                    icon: const Icon(Icons.phone_outlined, size: 16),
                    label: const Text('Call'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textDark,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onDirections,
                    icon: const Icon(Icons.directions,
                        size: 16, color: Colors.white),
                    label: const Text('Directions',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(label,
          style: AppTextStyles.bodySmall.copyWith(
              color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

// ── Hospital Detail Screen ────────────────────────────────────────────────────

class _HospitalDetailScreen extends StatelessWidget {
  final _Hospital hospital;
  final VoidCallback onDirections;
  final VoidCallback onCall;

  const _HospitalDetailScreen({
    super.key,
    required this.hospital,
    required this.onDirections,
    required this.onCall,
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
        title: Text(hospital.name, style: AppTextStyles.heading3),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map placeholder with GPS open button
            GestureDetector(
              onTap: onDirections,
              child: Container(
                height: 200,
                width: double.infinity,
                color: const Color(0xFFE8F4EA),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Simple map grid pattern
                    CustomPaint(
                      size: const Size(double.infinity, 200),
                      painter: _MapGridPainter(),
                    ),
                    // Pin
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: AppColors.primary),
                          child: const Icon(Icons.local_hospital,
                              color: Colors.white, size: 20),
                        ),
                        CustomPaint(
                          size: const Size(14, 8),
                          painter: _PinTailPainter(),
                        ),
                      ],
                    ),
                    // Open in maps button
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 6),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.open_in_new,
                                size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text('Open in Maps',
                                style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    // Coordinates overlay
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          '${hospital.lat.toStringAsFixed(4)}, ${hospital.lng.toStringAsFixed(4)}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & type
                  Text(hospital.name, style: AppTextStyles.heading2),
                  const SizedBox(height: 4),
                  Text(hospital.type,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.primary)),

                  const SizedBox(height: AppSpacing.md),

                  // Info rows
                  _InfoRow(
                      icon: Icons.location_on_outlined,
                      text: '${hospital.address}, ${hospital.city}'),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoRow(icon: Icons.phone_outlined, text: hospital.phone),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoRow(
                    icon: Icons.access_time,
                    text: hospital.isOpen24h
                        ? 'Open 24 hours'
                        : 'Not 24h — call to confirm',
                    color: hospital.isOpen24h ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoRow(
                    icon: Icons.directions,
                    text: '${hospital.distance} km from your location',
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Services
                  Text('Available Services',
                      style: AppTextStyles.bodyLarge
                          .copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: hospital.services
                        .map((s) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withValues(alpha: 0.08),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.full),
                                border: Border.all(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.2)),
                              ),
                              child: Text(s,
                                  style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500)),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // CTA buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onCall,
                          icon: const Icon(Icons.phone_outlined, size: 18),
                          label: const Text('Call Hospital'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.full)),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onDirections,
                          icon: const Icon(Icons.directions,
                              size: 18, color: Colors.white),
                          label: const Text('Get Directions',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.full)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  const _InfoRow({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color ?? AppColors.textLight),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: color ?? AppColors.textDark)),
        ),
      ],
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCCE5CC)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Road-like lines
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 8;
    canvas.drawLine(Offset(0, size.height * 0.4),
        Offset(size.width, size.height * 0.4), road);
    canvas.drawLine(Offset(size.width * 0.55, 0),
        Offset(size.width * 0.55, size.height), road);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _PinTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = AppColors.primary);
  }

  @override
  bool shouldRepaint(_) => false;
}
