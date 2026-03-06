// lib/screens/onboarding/onboarding_screen.dart — FIXED
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../services/auth_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _birthdayController = TextEditingController();
  final _illnessesController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _pregnancyTimeController = TextEditingController();

  @override
  void dispose() {
    _birthdayController.dispose();
    _illnessesController.dispose();
    _allergiesController.dispose();
    _pregnancyTimeController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.updateProfile(
      birthday: _birthdayController.text.trim(),
      illnesses: _illnessesController.text.trim(),
      allergies: _allergiesController.text.trim(),
      timeOfPregnancy: _pregnancyTimeController.text.trim(),
    );
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── bg2.png pinned to top-right, behind everything ────────────────
          Positioned(
            top: 0,
            right: 0,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/bg2.png',
                width: screenWidth * 0.6,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // ── Scrollable form sits on top with transparent scaffold bg ──────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Push form down so the illustration is visible above it
                    SizedBox(height: screenHeight * 0.28),

                    _FormSection(
                      question: 'When is your birthday ?',
                      child: CustomTextField(
                        hintText: 'Your birthday',
                        controller: _birthdayController,
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime(1995),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                            builder: (ctx, child) => Theme(
                              data: Theme.of(ctx).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.primary,
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (date != null) {
                            _birthdayController.text =
                                '${date.day}/${date.month}/${date.year}';
                          }
                        },
                      ),
                    ),

                    _FormSection(
                      question: 'Do you have illnesses ?',
                      child: CustomTextField(
                        hintText: 'Your illnesses',
                        controller: _illnessesController,
                      ),
                    ),

                    _FormSection(
                      question: 'Do you have any allergies ?',
                      child: CustomTextField(
                        hintText: 'Your allergies',
                        controller: _allergiesController,
                      ),
                    ),

                    _FormSection(
                      question: 'Time of pregnancy',
                      child: CustomTextField(
                        hintText: 'e.g. 7 weeks',
                        controller: _pregnancyTimeController,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    Consumer<AuthProvider>(
                      builder: (_, auth, __) => PrimaryButton(
                        label: 'Sign in',
                        onPressed: _handleSubmit,
                        isLoading: auth.isLoading,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  final String question;
  final Widget child;

  const _FormSection({required this.question, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: AppTextStyles.labelText),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}
