// lib/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../services/auth_provider.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

const List<String> _commonIllnesses = [
  'Diabetes',
  'Hypertension',
  'Asthma',
  'Anemia',
  'Thyroid disorder',
  'Heart disease',
  'Epilepsy',
  'Others',
];

const List<String> _commonAllergies = [
  'Penicillin',
  'Aspirin',
  'Ibuprofen',
  'Latex',
  'Pollen',
  'Dust',
  'Shellfish',
  'Nuts',
  'Others',
];

// ── Screen ────────────────────────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _birthdayController = TextEditingController();
  final _illnessOtherController = TextEditingController();
  final _allergyOtherController = TextEditingController();

  // Illness state
  bool? _hasIllness;
  final Set<String> _selectedIllnesses = {};

  // Allergy state
  bool? _hasAllergy;
  final Set<String> _selectedAllergies = {};

  // Pregnancy date — stored as weeks from LMP
  int _pregnancyWeeks = 1;

  @override
  void dispose() {
    _birthdayController.dispose();
    _illnessOtherController.dispose();
    _allergyOtherController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final illnesses = _hasIllness == true
        ? [
            ..._selectedIllnesses.where((e) => e != 'Others'),
            if (_selectedIllnesses.contains('Others') &&
                _illnessOtherController.text.trim().isNotEmpty)
              _illnessOtherController.text.trim(),
          ].join(', ')
        : 'None';

    final allergies = _hasAllergy == true
        ? [
            ..._selectedAllergies.where((e) => e != 'Others'),
            if (_selectedAllergies.contains('Others') &&
                _allergyOtherController.text.trim().isNotEmpty)
              _allergyOtherController.text.trim(),
          ].join(', ')
        : 'None';

    final auth = context.read<AuthProvider>();
    await auth.updateProfile(
      birthday: _birthdayController.text.trim(),
      illnesses: illnesses,
      allergies: allergies,
      timeOfPregnancy: '$_pregnancyWeeks weeks',
    );
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background illustration
          Positioned(
            bottom: 100,
            right: -35,
            child: IgnorePointer(
              child: Image.asset('assets/images/bg2.png'),
            ),
          ),

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
                    SizedBox(height: screenHeight * 0.28),

                    // Birthday
                    _FormLabel(text: 'When is your birthday?'),
                    const SizedBox(height: AppSpacing.sm),
                    CustomTextField(
                      hintText: 'Your birthday',
                      controller: _birthdayController,
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

                    const SizedBox(height: AppSpacing.lg),

                    // Chronic illnesses
                    _YesNoSection(
                      question: 'Do you have chronic illnesses?',
                      value: _hasIllness,
                      onChanged: (v) => setState(() {
                        _hasIllness = v;
                        _selectedIllnesses.clear();
                      }),
                    ),
                    if (_hasIllness == true) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _ChipSelector(
                        options: _commonIllnesses,
                        selected: _selectedIllnesses,
                        onToggle: (val) => setState(() =>
                            _selectedIllnesses.contains(val)
                                ? _selectedIllnesses.remove(val)
                                : _selectedIllnesses.add(val)),
                      ),
                      if (_selectedIllnesses.contains('Others')) ...[
                        const SizedBox(height: AppSpacing.sm),
                        CustomTextField(
                          hintText: 'Please specify your illness',
                          controller: _illnessOtherController,
                        ),
                      ],
                    ],

                    const SizedBox(height: AppSpacing.lg),

                    // Allergies
                    _YesNoSection(
                      question: 'Do you have any allergies?',
                      value: _hasAllergy,
                      onChanged: (v) => setState(() {
                        _hasAllergy = v;
                        _selectedAllergies.clear();
                      }),
                    ),
                    if (_hasAllergy == true) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _ChipSelector(
                        options: _commonAllergies,
                        selected: _selectedAllergies,
                        onToggle: (val) => setState(() =>
                            _selectedAllergies.contains(val)
                                ? _selectedAllergies.remove(val)
                                : _selectedAllergies.add(val)),
                      ),
                      if (_selectedAllergies.contains('Others')) ...[
                        const SizedBox(height: AppSpacing.sm),
                        CustomTextField(
                          hintText: 'Please specify your allergy',
                          controller: _allergyOtherController,
                        ),
                      ],
                    ],

                    const SizedBox(height: AppSpacing.lg),

                    // Pregnancy week picker
                    _FormLabel(text: 'How many weeks pregnant are you?'),
                    const SizedBox(height: AppSpacing.sm),
                    _WeekSliderPicker(
                      value: _pregnancyWeeks,
                      onChanged: (v) => setState(() => _pregnancyWeeks = v),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    Consumer<AuthProvider>(
                      builder: (_, auth, __) => PrimaryButton(
                        label: 'Continue',
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

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _FormLabel extends StatelessWidget {
  final String text;
  const _FormLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.labelText);
  }
}

/// Yes / No toggle row
class _YesNoSection extends StatelessWidget {
  final String question;
  final bool? value;
  final ValueChanged<bool> onChanged;

  const _YesNoSection({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(question, style: AppTextStyles.labelText),
        ),
        const SizedBox(width: AppSpacing.md),
        _ToggleChip(
          label: 'Yes',
          active: value == true,
          onTap: () => onChanged(true),
        ),
        const SizedBox(width: AppSpacing.sm),
        _ToggleChip(
          label: 'No',
          active: value == false,
          onTap: () => onChanged(false),
        ),
      ],
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: active ? Colors.white : AppColors.textMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Multi-select chip grid
class _ChipSelector extends StatelessWidget {
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _ChipSelector({
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: options.map((opt) {
        final isSelected = selected.contains(opt);
        return GestureDetector(
          onTap: () => onToggle(opt),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              opt,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textMedium,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Practical week picker: - / week number / +  with a progress bar
class _WeekSliderPicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _WeekSliderPicker({required this.value, required this.onChanged});

  static const int _maxWeeks = 42;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Counter row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Decrement
              _CircleButton(
                icon: Icons.remove,
                onTap: value > 1 ? () => onChanged(value - 1) : null,
              ),

              // Week display
              Column(
                children: [
                  Text(
                    'Week $value',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    _trimester(value),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),

              // Increment
              _CircleButton(
                icon: Icons.add,
                onTap: value < _maxWeeks ? () => onChanged(value + 1) : null,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: value / _maxWeeks,
              minHeight: 6,
              backgroundColor: AppColors.divider,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Week 1',
                  style: AppTextStyles.bodySmall
                      .copyWith(fontSize: 10, color: AppColors.textLight)),
              Text('Week 42',
                  style: AppTextStyles.bodySmall
                      .copyWith(fontSize: 10, color: AppColors.textLight)),
            ],
          ),
        ],
      ),
    );
  }

  String _trimester(int week) {
    if (week <= 13) return '1st Trimester';
    if (week <= 26) return '2nd Trimester';
    return '3rd Trimester';
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.divider,
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.primary : AppColors.textLight,
        ),
      ),
    );
  }
}
