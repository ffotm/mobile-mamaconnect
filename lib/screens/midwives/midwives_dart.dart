// lib/screens/midwives/midwives_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';
import '../contact/contact_screen.dart';

class _Midwife {
  final String id;
  final String name;
  final String speciality;
  final String location;
  final double rating;
  final int reviews;
  final String experience;
  final String price;
  final bool available;
  final List<String> languages;
  final String bio;

  const _Midwife({
    required this.id,
    required this.name,
    required this.speciality,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.experience,
    required this.price,
    required this.available,
    required this.languages,
    required this.bio,
  });
}

const _midwives = [
  _Midwife(
    id: '1',
    name: 'Dr. Sarah Benali',
    speciality: 'Certified Nurse-Midwife',
    location: 'Algiers',
    rating: 4.9,
    reviews: 128,
    experience: '12 years',
    price: '2500 DA',
    available: true,
    languages: ['Arabic', 'French', 'English'],
    bio:
        'Specialized in high-risk pregnancies and natural births. Available for both in-clinic and home visits.',
  ),
  _Midwife(
    id: '2',
    name: 'Mme. Fatima Ouali',
    speciality: 'Licensed Midwife',
    location: 'Oran',
    rating: 4.7,
    reviews: 94,
    experience: '8 years',
    price: '2000 DA',
    available: true,
    languages: ['Arabic', 'French'],
    bio:
        'Expert in prenatal care and postnatal support. Passionate about empowering mothers through their journey.',
  ),
  _Midwife(
    id: '3',
    name: 'Dr. Amina Khelil',
    speciality: 'Obstetric Midwife',
    location: 'Constantine',
    rating: 4.8,
    reviews: 76,
    experience: '15 years',
    price: '3000 DA',
    available: false,
    languages: ['Arabic', 'French'],
    bio:
        'Senior midwife with expertise in water births and pain management techniques.',
  ),
  _Midwife(
    id: '4',
    name: 'Mme. Nadia Messaoud',
    speciality: 'Community Midwife',
    location: 'Blida',
    rating: 4.6,
    reviews: 52,
    experience: '6 years',
    price: '1800 DA',
    available: true,
    languages: ['Arabic'],
    bio:
        'Dedicated community midwife focused on accessible care. Offers flexible appointment scheduling.',
  ),
];

class MidwivesScreen extends StatefulWidget {
  const MidwivesScreen({super.key});

  @override
  State<MidwivesScreen> createState() => _MidwivesScreenState();
}

class _MidwivesScreenState extends State<MidwivesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showAvailableOnly = false;

  List<_Midwife> get _filtered => _midwives.where((m) {
        final matchSearch = _searchQuery.isEmpty ||
            m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            m.location.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchAvail = !_showAvailableOnly || m.available;
        return matchSearch && matchAvail;
      }).toList();

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
        title: Text('Midwives', style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: Column(
              children: [
                // Search
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search by name or city...',
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
                // Filter
                Row(
                  children: [
                    Text('${_filtered.length} midwives found',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textLight)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(
                          () => _showAvailableOnly = !_showAvailableOnly),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _showAvailableOnly
                                  ? AppColors.primary
                                  : Colors.white,
                              border: Border.all(
                                color: _showAvailableOnly
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: _showAvailableOnly
                                ? const Icon(Icons.check,
                                    size: 12, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 6),
                          Text('Available only',
                              style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _MidwifeCard(
                midwife: _filtered[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MidwifeProfileScreen(midwife: _filtered[i]),
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

class _MidwifeCard extends StatelessWidget {
  final _Midwife midwife;
  final VoidCallback onTap;

  const _MidwifeCard({required this.midwife, required this.onTap});

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
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      AppColors.primaryLight.withValues(alpha: 0.4),
                  child: Text(
                    midwife.name.split(' ').last[0],
                    style: AppTextStyles.heading3
                        .copyWith(color: AppColors.primary),
                  ),
                ),
                if (midwife.available)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(midwife.name,
                      style: AppTextStyles.bodyLarge
                          .copyWith(fontWeight: FontWeight.w600)),
                  Text(midwife.speciality,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.primary)),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: AppColors.textLight),
                      Text(' ${midwife.location}',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textLight)),
                      const SizedBox(width: AppSpacing.sm),
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      Text(' ${midwife.rating}',
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(midwife.price,
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w600)),
                Text('/session',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textLight, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Midwife Profile ───────────────────────────────────────────────────────────
class MidwifeProfileScreen extends StatelessWidget {
  final _Midwife midwife;

  const MidwifeProfileScreen({super.key, required this.midwife});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200,
            backgroundColor: AppColors.primary,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      child: Text(
                        midwife.name.split(' ').last[0],
                        style: AppTextStyles.heading1
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(midwife.name,
                        style: AppTextStyles.heading3
                            .copyWith(color: Colors.white)),
                    Text(midwife.speciality,
                        style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.8))),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      Expanded(
                          child: _StatChip(
                              icon: Icons.star,
                              color: Colors.amber,
                              label: '${midwife.rating}',
                              sub: '${midwife.reviews} reviews')),
                      Expanded(
                          child: _StatChip(
                              icon: Icons.work_outline,
                              color: Colors.blue,
                              label: midwife.experience,
                              sub: 'Experience')),
                      Expanded(
                          child: _StatChip(
                              icon: Icons.circle,
                              color: midwife.available
                                  ? Colors.green
                                  : Colors.grey,
                              label: midwife.available ? 'Available' : 'Busy',
                              sub: 'Status')),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Text('About', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  Text(midwife.bio,
                      style: AppTextStyles.bodyMedium.copyWith(height: 1.6)),

                  const SizedBox(height: AppSpacing.lg),

                  Text('Languages', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: midwife.languages
                        .map((l) => Chip(
                              label: Text(l, style: AppTextStyles.bodySmall),
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.1),
                              side: BorderSide.none,
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Text('Location', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 4),
                      Text(midwife.location, style: AppTextStyles.bodyMedium),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Book button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ContactScreen(midwife: midwife),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                      ),
                      child: Text('Book a Session — ${midwife.price}',
                          style: AppTextStyles.buttonText),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String sub;

  const _StatChip(
      {required this.icon,
      required this.color,
      required this.label,
      required this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(label,
            style:
                AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        Text(sub,
            style:
                AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
      ],
    );
  }
}
