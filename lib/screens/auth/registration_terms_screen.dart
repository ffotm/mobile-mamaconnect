import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import '../../services/auth_provider.dart';
import '../../widgets/primary_button.dart';

class RegistrationTermsScreen extends StatefulWidget {
  final String birthday;
  final String illnesses;
  final String allergies;
  final String timeOfPregnancy;

  const RegistrationTermsScreen({
    super.key,
    required this.birthday,
    required this.illnesses,
    required this.allergies,
    required this.timeOfPregnancy,
  });

  @override
  State<RegistrationTermsScreen> createState() =>
      _RegistrationTermsScreenState();
}

class _RegistrationTermsScreenState extends State<RegistrationTermsScreen> {
  bool _agreeDataSharing = false;
  bool _agreePolicies = false;

  Future<void> _handleFinish() async {
    if (!_agreeDataSharing || !_agreePolicies) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept all terms and conditions to continue.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.updateProfile(
      birthday: widget.birthday,
      illnesses: widget.illnesses,
      allergies: widget.allergies,
      timeOfPregnancy: widget.timeOfPregnancy,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Could not save profile information'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: const LinearProgressIndicator(
                  value: 1.0,
                  minHeight: 8,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Step 3 of 3',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textMedium),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Terms and Conditions',
                style:
                    AppTextStyles.heading2.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Please review and accept the required policies before finishing your registration.',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textMedium),
              ),
              const SizedBox(height: AppSpacing.lg),
              CheckboxListTile(
                value: _agreeDataSharing,
                onChanged: (value) {
                  setState(() => _agreeDataSharing = value ?? false);
                },
                title: const Text('I agree on sharing my data.'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
              ),
              CheckboxListTile(
                value: _agreePolicies,
                onChanged: (value) {
                  setState(() => _agreePolicies = value ?? false);
                },
                title: const Text('I agree on all licenses and policies.'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
              ),
              const Spacer(),
              Consumer<AuthProvider>(
                builder: (_, auth, __) => PrimaryButton(
                  label: 'Finish Registration',
                  onPressed: _handleFinish,
                  isLoading: auth.isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
