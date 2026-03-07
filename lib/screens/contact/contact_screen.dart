// lib/screens/contact/contact_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

// forward-declare the type to avoid circular imports
class _MidwifeRef {
  final String name;
  final String speciality;
  final String price;
  const _MidwifeRef(
      {required this.name, required this.speciality, required this.price});
}

// Accept dynamic so we can pass both _Midwife and mock data
class ContactScreen extends StatefulWidget {
  final dynamic midwife;

  const ContactScreen({super.key, required this.midwife});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  int _step = 0; // 0=form, 1=payment, 2=confirmed
  final _messageController = TextEditingController();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  String _selectedSession = 'Video Call';
  DateTime? _selectedDate;
  bool _isProcessing = false;

  final _sessionTypes = [
    'Video Call',
    'Voice Call',
    'Home Visit',
    'Clinic Visit'
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted)
      setState(() {
        _isProcessing = false;
        _step = 2;
      });
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
          onPressed: () =>
              _step > 0 ? setState(() => _step--) : Navigator.pop(context),
        ),
        title: Text(
          ['Book Session', 'Payment', 'Confirmed'][_step],
          style: AppTextStyles.heading3,
        ),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: [
          _BookingForm(
            key: const ValueKey(0),
            midwife: widget.midwife,
            selectedSession: _selectedSession,
            sessionTypes: _sessionTypes,
            selectedDate: _selectedDate,
            messageController: _messageController,
            onSessionChanged: (v) => setState(() => _selectedSession = v),
            onDateChanged: (d) => setState(() => _selectedDate = d),
            onNext: () => setState(() => _step = 1),
          ),
          _PaymentForm(
            key: const ValueKey(1),
            midwife: widget.midwife,
            session: _selectedSession,
            selectedDate: _selectedDate,
            cardController: _cardController,
            expiryController: _expiryController,
            cvvController: _cvvController,
            isProcessing: _isProcessing,
            onPay: _processPayment,
          ),
          _ConfirmedView(
            key: const ValueKey(2),
            midwife: widget.midwife,
            session: _selectedSession,
            selectedDate: _selectedDate,
            onDone: () => Navigator.pop(context),
          ),
        ][_step],
      ),
    );
  }
}

// ── Step 1: Booking form ──────────────────────────────────────────────────────
class _BookingForm extends StatelessWidget {
  final dynamic midwife;
  final String selectedSession;
  final List<String> sessionTypes;
  final DateTime? selectedDate;
  final TextEditingController messageController;
  final ValueChanged<String> onSessionChanged;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onNext;

  const _BookingForm({
    super.key,
    required this.midwife,
    required this.selectedSession,
    required this.sessionTypes,
    required this.selectedDate,
    required this.messageController,
    required this.onSessionChanged,
    required this.onDateChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Midwife summary
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      AppColors.primaryLight.withValues(alpha: 0.4),
                  child: Text(
                    midwife.name.split(' ').last[0],
                    style: AppTextStyles.bodyLarge
                        .copyWith(color: AppColors.primary),
                  ),
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
                    ],
                  ),
                ),
                Text(midwife.price,
                    style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text('Session Type', style: AppTextStyles.labelText),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: sessionTypes.map((type) {
              final active = type == selectedSession;
              return GestureDetector(
                onTap: () => onSessionChanged(type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(
                        color: active ? AppColors.primary : AppColors.border),
                  ),
                  child: Text(type,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: active ? Colors.white : AppColors.textMedium,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text('Select Date', style: AppTextStyles.labelText),
          const SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme:
                        const ColorScheme.light(primary: AppColors.primary),
                  ),
                  child: child!,
                ),
              );
              if (date != null) onDateChanged(date);
            },
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    selectedDate == null
                        ? 'Choose a date'
                        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                    style: selectedDate == null
                        ? AppTextStyles.hintText
                        : AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text('Message (optional)', style: AppTextStyles.labelText),
          const SizedBox(height: AppSpacing.sm),
          CustomTextField(
            hintText: 'Describe your concern or question...',
            controller: messageController,
            maxLines: 3,
          ),

          const SizedBox(height: AppSpacing.xl),

          PrimaryButton(
            label: 'Continue to Payment',
            onPressed: selectedDate != null ? onNext : null,
          ),
        ],
      ),
    );
  }
}

// ── Step 2: Payment ───────────────────────────────────────────────────────────
class _PaymentForm extends StatelessWidget {
  final dynamic midwife;
  final String session;
  final DateTime? selectedDate;
  final TextEditingController cardController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final bool isProcessing;
  final VoidCallback onPay;

  const _PaymentForm({
    super.key,
    required this.midwife,
    required this.session,
    required this.selectedDate,
    required this.cardController,
    required this.expiryController,
    required this.cvvController,
    required this.isProcessing,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order summary
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                _SummaryRow(label: 'Midwife', value: midwife.name),
                _SummaryRow(label: 'Session', value: session),
                if (selectedDate != null)
                  _SummaryRow(
                      label: 'Date',
                      value:
                          '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                const Divider(height: AppSpacing.lg),
                _SummaryRow(
                  label: 'Total',
                  value: midwife.price,
                  highlight: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text('Payment Method', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.md),

          // Card number
          Text('Card Number', style: AppTextStyles.labelText),
          const SizedBox(height: AppSpacing.sm),
          CustomTextField(
            hintText: '1234 5678 9012 3456',
            controller: cardController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Expiry', style: AppTextStyles.labelText),
                    const SizedBox(height: AppSpacing.sm),
                    CustomTextField(
                      hintText: 'MM/YY',
                      controller: expiryController,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CVV', style: AppTextStyles.labelText),
                    const SizedBox(height: AppSpacing.sm),
                    CustomTextField(
                      hintText: '•••',
                      controller: cvvController,
                      isPassword: true,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Icons.lock_outline,
                  size: 14, color: AppColors.textLight),
              const SizedBox(width: 4),
              Text('Payments are encrypted and secure',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textLight)),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          PrimaryButton(
            label: 'Pay ${midwife.price}',
            onPressed: onPay,
            isLoading: isProcessing,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _SummaryRow(
      {required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textMedium)),
          const Spacer(),
          Text(value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
                color: highlight ? AppColors.primary : AppColors.textDark,
                fontSize: highlight ? 16 : 14,
              )),
        ],
      ),
    );
  }
}

// ── Step 3: Confirmed ─────────────────────────────────────────────────────────
class _ConfirmedView extends StatelessWidget {
  final dynamic midwife;
  final String session;
  final DateTime? selectedDate;
  final VoidCallback onDone;

  const _ConfirmedView({
    super.key,
    required this.midwife,
    required this.session,
    required this.selectedDate,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 40),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Booking Confirmed!', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.sm),
          Text('Your session with ${midwife.name} is booked',
              textAlign: TextAlign.center, style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                _SummaryRow(label: 'Session type', value: session),
                if (selectedDate != null)
                  _SummaryRow(
                      label: 'Date',
                      value:
                          '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                _SummaryRow(label: 'Amount paid', value: midwife.price),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.full)),
              ),
              child: Text('Back to Home', style: AppTextStyles.buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
