// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';
import '../../widgets/primary_button.dart';
import '../../services/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  final bool showBackButton;

  const ProfileScreen({super.key, this.showBackButton = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editing = false;

  final _nameController = TextEditingController(text: 'Yasmine Bensalem');
  final _emailController = TextEditingController(text: 'yasmine@example.com');
  final _phoneController = TextEditingController(text: '+213 555 123 456');
  final _weightController = TextEditingController(text: '68');
  final _heightController = TextEditingController(text: '165');
  final _bloodTypeController = TextEditingController(text: 'A+');

  double get _bmi {
    final weight = double.tryParse(_weightController.text) ?? 0;
    final heightM = (double.tryParse(_heightController.text) ?? 1) / 100;
    if (heightM == 0) return 0;
    return weight / (heightM * heightM);
  }

  String get _bmiLabel {
    final b = _bmi;
    if (b < 18.5) return 'Underweight';
    if (b < 25) return 'Normal';
    if (b < 30) return 'Overweight';
    return 'Obese';
  }

  Color get _bmiColor {
    final b = _bmi;
    if (b < 18.5) return Colors.blue;
    if (b < 25) return Colors.green;
    if (b < 30) return Colors.orange;
    return Colors.red;
  }

  String get _bmiAdvice {
    final b = _bmi;
    if (b < 18.5)
      return 'Your weight is below normal. Consult your midwife for nutrition advice.';
    if (b < 25)
      return 'Your weight is in the healthy range for pregnancy. Keep it up!';
    if (b < 30)
      return 'Your weight is slightly high. A balanced diet and light exercise are recommended.';
    return 'Your weight may require special monitoring. Please consult your midwife.';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _bloodTypeController.dispose();
    super.dispose();
  }

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
        title: const Text('My Profile', style: AppTextStyles.heading3),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => setState(() => _editing = !_editing),
            child: Text(
              _editing ? 'Cancel' : 'Edit',
              style:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor:
                        AppColors.primaryLight.withValues(alpha: 0.4),
                    child: Text('Y',
                        style: AppTextStyles.heading1
                            .copyWith(color: AppColors.primary)),
                  ),
                  if (_editing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.primary),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 14),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Personal info section
            const _SectionTitle(title: 'Personal Information'),
            const SizedBox(height: AppSpacing.md),
            _FieldRow(
                label: 'Full Name',
                controller: _nameController,
                enabled: _editing),
            _FieldRow(
                label: 'Email',
                controller: _emailController,
                enabled: _editing,
                keyboardType: TextInputType.emailAddress),
            _FieldRow(
                label: 'Phone',
                controller: _phoneController,
                enabled: _editing,
                keyboardType: TextInputType.phone),
            _FieldRow(
                label: 'Blood Type',
                controller: _bloodTypeController,
                enabled: _editing),

            const SizedBox(height: AppSpacing.lg),

            // Health metrics section
            const _SectionTitle(title: 'Health Metrics'),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: _FieldRow(
                      label: 'Weight (kg)',
                      controller: _weightController,
                      enabled: _editing,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {})),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _FieldRow(
                      label: 'Height (cm)',
                      controller: _heightController,
                      enabled: _editing,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {})),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // BMI card
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: _bmiColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: _bmiColor.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.monitor_weight_outlined,
                          color: _bmiColor, size: 20),
                      const SizedBox(width: 8),
                      Text('BMI Calculator',
                          style: AppTextStyles.bodyLarge
                              .copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _bmiColor,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(_bmiLabel,
                            style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('BMI: ${_bmi.toStringAsFixed(1)}',
                      style: AppTextStyles.heading2.copyWith(color: _bmiColor)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(_bmiAdvice,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textMedium, height: 1.4)),

                  const SizedBox(height: AppSpacing.md),

                  // BMI scale bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: Container(
                      height: 8,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.green,
                            Colors.orange,
                            Colors.red
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('18.5',
                          style:
                              TextStyle(fontSize: 9, color: Color(0xFF9E9E9E))),
                      Text('25',
                          style:
                              TextStyle(fontSize: 9, color: Color(0xFF9E9E9E))),
                      Text('30',
                          style:
                              TextStyle(fontSize: 9, color: Color(0xFF9E9E9E))),
                      Text('40',
                          style:
                              TextStyle(fontSize: 9, color: Color(0xFF9E9E9E))),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            if (_editing)
              PrimaryButton(
                label: 'Save Changes',
                onPressed: () {
                  setState(() => _editing = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Profile updated successfully')),
                  );
                },
              ),

            const SizedBox(height: AppSpacing.lg),

            // Logout
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => context.read<AuthProvider>().logout().then(
                      (_) => Navigator.pushReplacementNamed(
                          context, AppRoutes.login),
                    ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full)),
                ),
                child: Text('Log Out',
                    style: AppTextStyles.buttonText
                        .copyWith(color: AppColors.error)),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700));
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const _FieldRow({
    required this.label,
    required this.controller,
    required this.enabled,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
          const SizedBox(height: 4),
          enabled
              ? TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  style: AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
                  decoration: BoxDecoration(
                    color: AppColors.divider.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Text(controller.text, style: AppTextStyles.bodyMedium),
                ),
        ],
      ),
    );
  }
}
