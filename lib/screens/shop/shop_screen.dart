// lib/screens/shop/shop_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';
import '../../widgets/primary_button.dart';

class ShopScreen extends StatefulWidget {
  final bool showBackButton;

  const ShopScreen({super.key, this.showBackButton = true});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _selectedBundleIndex = 1; // default: Standard

  final _bundles = const [
    _Bundle(
      name: 'Basic',
      price: '12,900 DA',
      priceValue: 12900,
      description: 'Essential monitoring for your pregnancy',
      features: [
        'Mamaconnect Monitor device',
        'Heart rate sensor',
        'Movement detection',
        '1 year app subscription',
        'Email support',
      ],
      isPopular: false,
    ),
    _Bundle(
      name: 'Standard',
      price: '18,900 DA',
      priceValue: 18900,
      description: 'Complete care for peace of mind',
      features: [
        'Mamaconnect Monitor device',
        'Heart rate & SpO₂ sensor',
        'Temperature sensor',
        'Movement detection',
        '2 year app subscription',
        'Priority chat support',
        '1 free midwife session',
      ],
      isPopular: true,
    ),
    _Bundle(
      name: 'Premium',
      price: '29,900 DA',
      priceValue: 29900,
      description: 'Full suite with dedicated care',
      features: [
        'Mamaconnect Monitor Pro device',
        'All sensors included',
        'Unlimited app subscription',
        '24/7 midwife hotline',
        '3 free midwife sessions',
        'Personalized health reports',
        'Free home delivery',
      ],
      isPopular: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        automaticallyImplyLeading: widget.showBackButton,
        title: Text('Shop', style: AppTextStyles.heading3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined,
                color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFFD4614A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mamaconnect\nMonitor',
                            style: AppTextStyles.heading2
                                .copyWith(color: Colors.white, height: 1.2)),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                            'Smart wearable device for real-time baby health monitoring',
                            style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                height: 1.4)),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text('Free App Included',
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: const Icon(Icons.monitor_heart,
                        color: Colors.white, size: 48),
                  ),
                ],
              ),
            ),

            // Feature highlights
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: const [
                  Expanded(
                      child: _HighlightChip(
                          icon: Icons.favorite, label: 'Heart Rate')),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                      child: _HighlightChip(
                          icon: Icons.thermostat, label: 'Temperature')),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                      child:
                          _HighlightChip(icon: Icons.waves, label: 'Movement')),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                      child: _HighlightChip(icon: Icons.air, label: 'SpO₂')),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text('Choose Your Plan', style: AppTextStyles.heading3),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text('All plans include the physical device',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textLight)),
            ),

            const SizedBox(height: AppSpacing.md),

            // Bundle cards
            ...List.generate(
                _bundles.length,
                (i) => _BundleCard(
                      bundle: _bundles[i],
                      isSelected: i == _selectedBundleIndex,
                      onTap: () => setState(() => _selectedBundleIndex = i),
                    )),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  PrimaryButton(
                    label:
                        'Order ${_bundles[_selectedBundleIndex].name} — ${_bundles[_selectedBundleIndex].price}',
                    onPressed: () => _showOrderConfirmation(context),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_shipping_outlined,
                          size: 14, color: AppColors.textLight),
                      Text('  Free delivery within Algeria',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textLight)),
                    ],
                  ),
                ],
              ),
            ),

            // Reviews
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text('Customer Reviews', style: AppTextStyles.heading3),
            ),
            const SizedBox(height: AppSpacing.sm),
            const _ReviewCard(
              name: 'Amira B.',
              rating: 5,
              review:
                  'This device gave me so much peace of mind during my third trimester. The alerts are super helpful!',
            ),
            const _ReviewCard(
              name: 'Leila K.',
              rating: 4,
              review:
                  'Very easy to set up with the app. Battery lasts a long time. Highly recommend for any pregnant mother.',
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  void _showOrderConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _OrderSheet(bundle: _bundles[_selectedBundleIndex]),
    );
  }
}

class _HighlightChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HighlightChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall
                  .copyWith(fontSize: 10, color: AppColors.textMedium)),
        ],
      ),
    );
  }
}

class _BundleCard extends StatelessWidget {
  final _Bundle bundle;
  final bool isSelected;
  final VoidCallback onTap;

  const _BundleCard(
      {required this.bundle, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(bundle.name,
                    style: AppTextStyles.heading3.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textDark)),
                if (bundle.isPopular) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text('Most Popular',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.white, fontSize: 10)),
                  ),
                ],
                const Spacer(),
                Text(bundle.price,
                    style: AppTextStyles.heading3.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textDark)),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(bundle.description,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textMedium)),
            const SizedBox(height: AppSpacing.md),
            ...bundle.features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 14,
                          color: isSelected ? AppColors.primary : Colors.green),
                      const SizedBox(width: 8),
                      Text(f, style: AppTextStyles.bodySmall),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _Bundle {
  final String name;
  final String price;
  final int priceValue;
  final String description;
  final List<String> features;
  final bool isPopular;

  const _Bundle({
    required this.name,
    required this.price,
    required this.priceValue,
    required this.description,
    required this.features,
    required this.isPopular,
  });
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final int rating;
  final String review;

  const _ReviewCard(
      {required this.name, required this.rating, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
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
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.5),
                child: Text(name[0],
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(name,
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              Row(
                children: List.generate(
                    rating,
                    (_) =>
                        const Icon(Icons.star, color: Colors.amber, size: 14)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(review,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textMedium, height: 1.4)),
        ],
      ),
    );
  }
}

class _OrderSheet extends StatelessWidget {
  final _Bundle bundle;
  const _OrderSheet({required this.bundle});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

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
          Text('Complete Order', style: AppTextStyles.heading3),
          Text('${bundle.name} Plan — ${bundle.price}',
              style:
                  AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: addressCtrl,
            decoration: const InputDecoration(
              labelText: 'Delivery Address',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Order placed! We\'ll contact you to confirm delivery.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.full)),
              ),
              child: Text('Place Order', style: AppTextStyles.buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
