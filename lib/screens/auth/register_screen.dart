import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';
import '../../widgets/auth_tab_switcher.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../services/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedRole = 'client';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      role: _selectedRole,
    );
    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Registration failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(children: [
          const Positioned(
            top: 0,
            right: 0,
            child: _TopDecoration(),
          ),
          SafeArea(
            child: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.xxxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.xl),
                      const Center(
                        child: Text('Hello Mamacita',
                            style: AppTextStyles.heading1),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AuthTabSwitcher(
                        activeIndex: 1,
                        onTabChanged: (index) {
                          if (index == 0) Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Full Name',
                                style: AppTextStyles.labelText),
                            const SizedBox(height: AppSpacing.sm),
                            CustomTextField(
                              hintText: 'Your full name',
                              controller: _nameController,
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Name is required'
                                  : null,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            const Text('Email address',
                                style: AppTextStyles.labelText),
                            const SizedBox(height: AppSpacing.sm),
                            CustomTextField(
                              hintText: 'Your email',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!v.contains('@')) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.md),
                            const Text('Password',
                                style: AppTextStyles.labelText),
                            const SizedBox(height: AppSpacing.sm),
                            CustomTextField(
                              hintText: 'Password',
                              controller: _passwordController,
                              isPassword: true,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Password is required';
                                }
                                if (v.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.md),
                            const Text('Confirm password',
                                style: AppTextStyles.labelText),
                            const SizedBox(height: AppSpacing.sm),
                            CustomTextField(
                              hintText: 'repeat password',
                              controller: _confirmPasswordController,
                              isPassword: true,
                              validator: (v) {
                                if (v != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.md),
                            const Text('What are you ?',
                                style: AppTextStyles.labelText),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                _RoleRadio(
                                  label: 'Client',
                                  value: 'client',
                                  groupValue: _selectedRole,
                                  onChanged: (v) =>
                                      setState(() => _selectedRole = v!),
                                ),
                                const SizedBox(width: AppSpacing.xl),
                                _RoleRadio(
                                  label: 'Midwife',
                                  value: 'midwife',
                                  groupValue: _selectedRole,
                                  onChanged: (v) =>
                                      setState(() => _selectedRole = v!),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Consumer<AuthProvider>(
                              builder: (_, auth, __) => PrimaryButton(
                                label: 'Continue',
                                onPressed: _handleRegister,
                                isLoading: auth.isLoading,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ]));
  }
}

class _RoleRadio extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _RoleRadio({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: AppColors.primary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(label, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}

class _TopDecoration extends StatelessWidget {
  const _TopDecoration();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Image.asset(
        'assets/images/bg1.png',
      ),
    );
  }
}
