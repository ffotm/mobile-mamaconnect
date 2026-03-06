// lib/screens/auth/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';
import '../../widgets/auth_tab_switcher.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../services/auth_provider.dart';
import 'register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _activeTab = 0; // 0 = Sign In, 1 = Register

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.xl),
                      const Text('Hello Mamacita',
                          style: AppTextStyles.heading1),
                      const SizedBox(height: AppSpacing.xl),

                      // Tab switcher
                      AuthTabSwitcher(
                        activeIndex: _activeTab,
                        onTabChanged: (index) {
                          if (index == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          } else {
                            setState(() => _activeTab = index);
                          }
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Login form
                      const _LoginForm(),

                      const SizedBox(height: AppSpacing.xl),

                      // Other sign in options
                      const Text('Other sign in options',
                          style: AppTextStyles.bodySmall),
                      const SizedBox(height: AppSpacing.md),
                      _GoogleSignInButton(),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Login failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Email address', style: AppTextStyles.labelText),
          const SizedBox(height: AppSpacing.sm),
          CustomTextField(
            hintText: 'Your email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Password', style: AppTextStyles.labelText),
          const SizedBox(height: AppSpacing.sm),
          CustomTextField(
            hintText: 'Password',
            controller: _passwordController,
            isPassword: true,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                //TODO: navigate to forgot password
              },
              child: Text(
                'Forgot password?',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Consumer<AuthProvider>(
            builder: (_, auth, __) => PrimaryButton(
              label: 'Sign in',
              onPressed: _handleLogin,
              isLoading: auth.isLoading,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Demo login: mama@example.com / 123456\nDemo midwife: midwife@example.com / 123456',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
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

class _GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: implement Google Sign In
      },
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google G icon
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  'G',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text('Sign in with Google', style: AppTextStyles.bodyLarge),
          ],
        ),
      ),
    );
  }
}
