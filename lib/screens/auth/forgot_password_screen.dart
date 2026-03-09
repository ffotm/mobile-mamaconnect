// lib/screens/auth/forgot_password_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Forgot-password — 4 steps:
//   0  Enter email
//   1  6-digit OTP (with resend countdown)
//   2  New password + strength meter
//   3  Success
// ─────────────────────────────────────────────────────────────────────────────

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _step = 0;
  bool _loading = false;

  // Step 0 – email
  final _emailCtrl = TextEditingController();
  String? _emailErr;

  // Step 1 – OTP
  final _otpCtrls = List.generate(6, (_) => TextEditingController());
  final _otpFocus = List.generate(6, (_) => FocusNode());
  String? _otpErr;
  int _resendSec = 30;
  bool _resendActive = false;

  // Step 2 – new password
  final _pw1Ctrl = TextEditingController();
  final _pw2Ctrl = TextEditingController();
  bool _obs1 = true;
  bool _obs2 = true;
  String? _pwErr;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pw1Ctrl.dispose();
    _pw2Ctrl.dispose();
    for (final c in _otpCtrls) c.dispose();
    for (final f in _otpFocus) f.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool _isEmailValid(String e) =>
      RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-z]{2,}$').hasMatch(e.trim());

  Future<void> _sendCode() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _emailErr = 'Please enter your email address');
      return;
    }
    if (!_isEmailValid(email)) {
      setState(() => _emailErr = 'Please enter a valid email address');
      return;
    }
    setState(() {
      _emailErr = null;
      _loading = true;
    });
    await Future.delayed(const Duration(seconds: 1)); // TODO: API call
    if (!mounted) return;
    setState(() {
      _loading = false;
      _step = 1;
    });
    _startCountdown();
  }

  void _startCountdown() async {
    if (_resendActive) return;
    _resendActive = true;
    for (int i = 30; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _resendSec = i);
    }
    _resendActive = false;
  }

  Future<void> _verifyOtp() async {
    final code = _otpCtrls.map((c) => c.text).join();
    if (code.length < 6) {
      setState(() => _otpErr = 'Please enter all 6 digits');
      return;
    }
    setState(() {
      _otpErr = null;
      _loading = true;
    });
    await Future.delayed(const Duration(seconds: 1)); // TODO: API call
    if (!mounted) return;
    setState(() {
      _loading = false;
      _step = 2;
    });
  }

  Future<void> _resetPassword() async {
    final p1 = _pw1Ctrl.text;
    final p2 = _pw2Ctrl.text;
    if (p1.length < 8) {
      setState(() => _pwErr = 'Password must be at least 8 characters');
      return;
    }
    if (p1 != p2) {
      setState(() => _pwErr = 'Passwords do not match');
      return;
    }
    setState(() {
      _pwErr = null;
      _loading = true;
    });
    await Future.delayed(const Duration(seconds: 1)); // TODO: API call
    if (!mounted) return;
    setState(() {
      _loading = false;
      _step = 3;
    });
  }

  void _goBack() {
    if (_step > 0 && _step < 3) {
      setState(() => _step--);
    } else {
      Navigator.pop(context);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _step < 3
          ? AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                onPressed: _goBack,
              ),
            )
          : null,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: anim, curve: Curves.easeOutCubic)),
              child: child,
            ),
          ),
          child: switch (_step) {
            0 => _StepEmail(
                key: const ValueKey(0),
                ctrl: _emailCtrl,
                error: _emailErr,
                loading: _loading,
                onSend: _sendCode),
            1 => _StepOtp(
                key: const ValueKey(1),
                email: _emailCtrl.text.trim(),
                ctrls: _otpCtrls,
                focusNodes: _otpFocus,
                error: _otpErr,
                loading: _loading,
                countdown: _resendSec,
                onVerify: _verifyOtp,
                onResend: _resendSec == 0
                    ? () {
                        setState(() => _resendSec = 30);
                        _startCountdown();
                      }
                    : null),
            2 => _StepNewPassword(
                key: const ValueKey(2),
                ctrl1: _pw1Ctrl,
                ctrl2: _pw2Ctrl,
                obs1: _obs1,
                obs2: _obs2,
                error: _pwErr,
                loading: _loading,
                onToggle1: () => setState(() => _obs1 = !_obs1),
                onToggle2: () => setState(() => _obs2 = !_obs2),
                onReset: _resetPassword),
            _ => _StepSuccess(
                key: const ValueKey(3),
                onDone: () => Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.login, (_) => false)),
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 0 – Email
// ─────────────────────────────────────────────────────────────────────────────

class _StepEmail extends StatelessWidget {
  final TextEditingController ctrl;
  final String? error;
  final bool loading;
  final VoidCallback onSend;
  const _StepEmail(
      {super.key,
      required this.ctrl,
      this.error,
      required this.loading,
      required this.onSend});

  @override
  Widget build(BuildContext context) {
    return _PageShell(
      icon: '🔐',
      title: 'Forgot\nPassword?',
      subtitle:
          'No worries! Enter your registered email and we\'ll send you a 6-digit reset code.',
      stepIndex: 0,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const _FieldLabel('Email address'),
        _InputField(
          ctrl: ctrl,
          hint: 'your@email.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          error: error,
        ),
        const SizedBox(height: AppSpacing.xl),
        _CTA(label: 'Send Reset Code', loading: loading, onTap: onSend),
        const SizedBox(height: AppSpacing.lg),
        Center(
            child: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Back to Sign In',
              style:
                  AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
        )),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1 – OTP
// ─────────────────────────────────────────────────────────────────────────────

class _StepOtp extends StatelessWidget {
  final String email;
  final List<TextEditingController> ctrls;
  final List<FocusNode> focusNodes;
  final String? error;
  final bool loading;
  final int countdown;
  final VoidCallback onVerify;
  final VoidCallback? onResend;

  const _StepOtp(
      {super.key,
      required this.email,
      required this.ctrls,
      required this.focusNodes,
      this.error,
      required this.loading,
      required this.countdown,
      required this.onVerify,
      this.onResend});

  @override
  Widget build(BuildContext context) {
    return _PageShell(
      icon: '📨',
      title: 'Check Your\nEmail',
      subtitle: 'We sent a 6-digit code to:\n$email',
      stepIndex: 1,
      child: Column(children: [
        // OTP boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              6,
              (i) => _OtpBox(
                    ctrl: ctrls[i],
                    focusNode: focusNodes[i],
                    onChanged: (v) {
                      if (v.isNotEmpty && i < 5) {
                        focusNodes[i + 1].requestFocus();
                      } else if (v.isEmpty && i > 0) {
                        focusNodes[i - 1].requestFocus();
                      }
                    },
                  )),
        ),

        if (error != null) ...[
          const SizedBox(height: 8),
          Text(error!,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
        ],

        const SizedBox(height: AppSpacing.md),

        // Resend row
        countdown > 0
            ? Text('Resend code in ${countdown}s',
                style: AppTextStyles.bodySmall)
            : TextButton(
                onPressed: onResend,
                child: Text('Resend Code',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),

        const SizedBox(height: AppSpacing.xl),
        _CTA(label: 'Verify Code', loading: loading, onTap: onVerify),
      ]),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController ctrl;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  const _OtpBox(
      {required this.ctrl, required this.focusNode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        controller: ctrl,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            fontFamily: 'Poppins'),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 2 – New password
// ─────────────────────────────────────────────────────────────────────────────

class _StepNewPassword extends StatefulWidget {
  final TextEditingController ctrl1, ctrl2;
  final bool obs1, obs2;
  final String? error;
  final bool loading;
  final VoidCallback onToggle1, onToggle2, onReset;
  const _StepNewPassword(
      {super.key,
      required this.ctrl1,
      required this.ctrl2,
      required this.obs1,
      required this.obs2,
      this.error,
      required this.loading,
      required this.onToggle1,
      required this.onToggle2,
      required this.onReset});
  @override
  State<_StepNewPassword> createState() => _StepNewPasswordState();
}

class _StepNewPasswordState extends State<_StepNewPassword> {
  @override
  void initState() {
    super.initState();
    widget.ctrl1.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return _PageShell(
      icon: '🔑',
      title: 'New\nPassword',
      subtitle: 'Create a strong password for your Mamacita account.',
      stepIndex: 2,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const _FieldLabel('New password'),
        _InputField(
          ctrl: widget.ctrl1,
          hint: 'Minimum 8 characters',
          icon: Icons.lock_outline,
          obscure: widget.obs1,
          onToggleObscure: widget.onToggle1,
        ),
        const SizedBox(height: 8),
        _PasswordStrength(password: widget.ctrl1.text),
        const SizedBox(height: AppSpacing.md),
        const _FieldLabel('Confirm password'),
        _InputField(
          ctrl: widget.ctrl2,
          hint: 'Repeat your new password',
          icon: Icons.lock_outline,
          obscure: widget.obs2,
          onToggleObscure: widget.onToggle2,
          error: widget.error,
        ),
        const SizedBox(height: AppSpacing.xl),
        _CTA(
            label: 'Reset Password',
            loading: widget.loading,
            onTap: widget.onReset),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 3 – Success
// ─────────────────────────────────────────────────────────────────────────────

class _StepSuccess extends StatelessWidget {
  final VoidCallback onDone;
  const _StepSuccess({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Animated check circle
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withValues(alpha: 0.1),
              border: Border.all(
                  color: Colors.green.withValues(alpha: 0.35), width: 2),
            ),
            child:
                const Icon(Icons.check_rounded, color: Colors.green, size: 52),
          ),

          const SizedBox(height: AppSpacing.xl),
          const Text('Password Reset!', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Your password has been changed successfully.\n'
            'You can now sign in with your new password.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.full)),
              ),
              child: const Text('Back to Sign In',
                  style: AppTextStyles.buttonText),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared page shell
// ─────────────────────────────────────────────────────────────────────────────

class _PageShell extends StatelessWidget {
  final String icon, title, subtitle;
  final int stepIndex; // 0, 1, 2
  final Widget child;
  const _PageShell(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.stepIndex,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Icon bubble
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF9690), Color(0xFFA53A2D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFFA53A2D).withValues(alpha: 0.22),
                  blurRadius: 14,
                  offset: const Offset(0, 5))
            ],
          ),
          child:
              Center(child: Text(icon, style: const TextStyle(fontSize: 28))),
        ),

        const SizedBox(height: AppSpacing.lg),

        // Step dots
        _StepDots(current: stepIndex),

        const SizedBox(height: AppSpacing.lg),

        Text(title, style: AppTextStyles.heading1.copyWith(height: 1.15)),
        const SizedBox(height: AppSpacing.sm),
        Text(subtitle, style: AppTextStyles.bodyMedium.copyWith(height: 1.55)),
        const SizedBox(height: AppSpacing.xl),

        child,
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step dots (animated pill indicator)
// ─────────────────────────────────────────────────────────────────────────────

class _StepDots extends StatelessWidget {
  final int current; // 0–2
  const _StepDots({required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final done = i < current;
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(right: 6),
          width: active ? 28 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: done
                ? Colors.green
                : active
                    ? AppColors.primary
                    : AppColors.divider,
            borderRadius: BorderRadius.circular(5),
          ),
          child: done
              ? const Center(
                  child: Icon(Icons.check, color: Colors.white, size: 7))
              : null,
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared form widgets
// ─────────────────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: AppTextStyles.labelText),
      );
}

class _InputField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final IconData icon;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final String? error;
  final TextInputType? keyboardType;

  const _InputField(
      {required this.ctrl,
      required this.hint,
      required this.icon,
      this.obscure = false,
      this.onToggleObscure,
      this.error,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextField(
        controller: ctrl,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.hintText,
          prefixIcon: Icon(icon, color: AppColors.textLight, size: 20),
          suffixIcon: onToggleObscure != null
              ? IconButton(
                  icon: Icon(
                      obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textLight,
                      size: 20),
                  onPressed: onToggleObscure,
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.md),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                  color: hasError ? AppColors.error : AppColors.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                  color: hasError ? AppColors.error : AppColors.primary,
                  width: 1.5)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md)),
        ),
      ),
      if (hasError) ...[
        const SizedBox(height: 5),
        Row(children: [
          const Icon(Icons.error_outline, size: 13, color: AppColors.error),
          const SizedBox(width: 4),
          Text(error!,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.error, fontSize: 12)),
        ]),
      ],
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Password strength meter
// ─────────────────────────────────────────────────────────────────────────────

class _PasswordStrength extends StatelessWidget {
  final String password;
  const _PasswordStrength({required this.password});

  ({int score, String label, Color color}) get _strength {
    int s = 0;
    if (password.length >= 8) s++;
    if (password.contains(RegExp(r'[A-Z]'))) s++;
    if (password.contains(RegExp(r'[0-9]'))) s++;
    if (password.contains(RegExp(r'[!@#\$%^&*()_+\-=]'))) s++;
    if (s <= 1) return (score: s, label: 'Weak', color: Colors.red);
    if (s == 2) return (score: s, label: 'Fair', color: Colors.orange);
    if (s == 3) return (score: s, label: 'Good', color: Colors.blue);
    return (score: 4, label: 'Strong', color: Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();
    final st = _strength;
    return Row(children: [
      ...List.generate(
          4,
          (i) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  height: 4,
                  margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: i < st.score ? st.color : AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              )),
      const SizedBox(width: 10),
      Text(st.label,
          style: AppTextStyles.bodySmall.copyWith(
              color: st.color, fontWeight: FontWeight.w700, fontSize: 11)),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Primary CTA button
// ─────────────────────────────────────────────────────────────────────────────

class _CTA extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onTap;
  const _CTA({required this.label, required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: loading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.primaryLight,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full)),
          ),
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5))
              : Text(label, style: AppTextStyles.buttonText),
        ),
      );
}
