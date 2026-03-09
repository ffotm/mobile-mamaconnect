// lib/screens/symptoms/symptom_tracker_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

class _Symptom {
  final String name;
  final String emoji;
  final String category;
  bool selected;
  _Symptom(
      {required this.name,
      required this.emoji,
      required this.category,
      this.selected = false});
}

class _Recommendation {
  final String type; // 'workout', 'food', 'medicine'
  final String emoji;
  final String title;
  final String reason;
  const _Recommendation(
      {required this.type,
      required this.emoji,
      required this.title,
      required this.reason});
}

final _allSymptoms = [
  _Symptom(name: 'Nausea', emoji: '🤢', category: 'Digestive'),
  _Symptom(name: 'Back Pain', emoji: '🔙', category: 'Pain'),
  _Symptom(name: 'Fatigue', emoji: '😴', category: 'Energy'),
  _Symptom(name: 'Heartburn', emoji: '🔥', category: 'Digestive'),
  _Symptom(name: 'Swollen Feet', emoji: '🦶', category: 'Circulation'),
  _Symptom(name: 'Headache', emoji: '🤕', category: 'Pain'),
  _Symptom(name: 'Constipation', emoji: '💤', category: 'Digestive'),
  _Symptom(name: 'Insomnia', emoji: '🌙', category: 'Sleep'),
  _Symptom(name: 'Leg Cramps', emoji: '⚡', category: 'Pain'),
  _Symptom(name: 'Mood Swings', emoji: '🎭', category: 'Mental'),
  _Symptom(name: 'Shortness of Breath', emoji: '💨', category: 'Respiratory'),
  _Symptom(name: 'Pelvic Pressure', emoji: '🔻', category: 'Pain'),
  _Symptom(name: 'Dizziness', emoji: '💫', category: 'Circulation'),
  _Symptom(name: 'Breast Tenderness', emoji: '💗', category: 'Physical'),
  _Symptom(name: 'Frequent Urination', emoji: '🚽', category: 'Urinary'),
  _Symptom(name: 'Anxiety', emoji: '😰', category: 'Mental'),
];

// Map symptoms → recommendations
Map<String, List<_Recommendation>> _symptomRecommendations = {
  'Nausea': [
    _Recommendation(
        type: 'food',
        emoji: '🍌',
        title: 'Banana Oat Smoothie',
        reason:
            'Vitamin B6 in bananas is clinically shown to reduce pregnancy nausea.'),
    _Recommendation(
        type: 'food',
        emoji: '🫚',
        title: 'Ginger Tea',
        reason:
            'Ginger reduces nausea effectively — a well-studied pregnancy remedy.'),
    _Recommendation(
        type: 'medicine',
        emoji: '💊',
        title: 'Vitamin B6 supplement',
        reason:
            'Often prescribed for morning sickness. Consult your doctor first.'),
  ],
  'Back Pain': [
    _Recommendation(
        type: 'workout',
        emoji: '🧘‍♀️',
        title: 'Prenatal Yoga',
        reason:
            'Cat-cow and child\'s pose specifically target pregnancy back pain.'),
    _Recommendation(
        type: 'workout',
        emoji: '🪑',
        title: 'Seated Back Exercises',
        reason: 'Gentle seated core work reduces lumbar strain.'),
    _Recommendation(
        type: 'medicine',
        emoji: '💊',
        title: 'Paracetamol (if needed)',
        reason: 'Safe pain relief during pregnancy. Max 4g/day.'),
  ],
  'Fatigue': [
    _Recommendation(
        type: 'food',
        emoji: '🥣',
        title: 'Lentil & Spinach Soup',
        reason: 'High iron content combats anaemia-related fatigue.'),
    _Recommendation(
        type: 'workout',
        emoji: '🚶‍♀️',
        title: 'Gentle Walk (10–15 min)',
        reason: 'Light movement boosts energy better than rest alone.'),
    _Recommendation(
        type: 'food',
        emoji: '🟤',
        title: 'Date & Walnut Snack',
        reason: 'Natural sugars provide quick energy without crash.'),
  ],
  'Heartburn': [
    _Recommendation(
        type: 'medicine',
        emoji: '💊',
        title: 'Omeprazole (if prescribed)',
        reason: 'Safe PPI for pregnancy heartburn. Consult your midwife.'),
    _Recommendation(
        type: 'food',
        emoji: '🥛',
        title: 'Small Frequent Meals',
        reason: 'Avoid large meals. Eat slowly and stay upright 30 min after.'),
  ],
  'Swollen Feet': [
    _Recommendation(
        type: 'workout',
        emoji: '🏊‍♀️',
        title: 'Swimming / Water Walking',
        reason: 'Water pressure reduces oedema and relieves swollen legs.'),
    _Recommendation(
        type: 'workout',
        emoji: '🚶‍♀️',
        title: 'Gentle Walking',
        reason: 'Activates calf pump to push fluid back up.'),
  ],
  'Headache': [
    _Recommendation(
        type: 'medicine',
        emoji: '💊',
        title: 'Paracetamol',
        reason: 'Safe first-line treatment for headaches in pregnancy.'),
    _Recommendation(
        type: 'workout',
        emoji: '🤸‍♀️',
        title: 'Gentle Neck Stretches',
        reason:
            'Tension headaches often respond well to neck and shoulder stretching.'),
  ],
  'Constipation': [
    _Recommendation(
        type: 'food',
        emoji: '🥣',
        title: 'High-Fibre Lentil Soup',
        reason: 'Soluble and insoluble fibre promotes regular bowel movement.'),
    _Recommendation(
        type: 'workout',
        emoji: '🚶‍♀️',
        title: 'Daily Walking',
        reason: 'Even 20 min of walking stimulates intestinal motility.'),
    _Recommendation(
        type: 'food',
        emoji: '💧',
        title: 'Increase Water Intake',
        reason: 'Dehydration is a main cause of constipation. Aim for 2L/day.'),
  ],
  'Insomnia': [
    _Recommendation(
        type: 'workout',
        emoji: '🤸‍♀️',
        title: 'Bedtime Stretching',
        reason:
            'Gentle stretches before bed reduce tension and promote sleep.'),
    _Recommendation(
        type: 'workout',
        emoji: '🧘‍♀️',
        title: 'Prenatal Yoga (evening)',
        reason: 'Breathing and relaxation techniques improve sleep quality.'),
    _Recommendation(
        type: 'food',
        emoji: '🥛',
        title: 'Warm Milk or Chamomile Tea',
        reason: 'Tryptophan in milk and chamomile support sleep.'),
  ],
  'Leg Cramps': [
    _Recommendation(
        type: 'food',
        emoji: '🍌',
        title: 'Banana (Potassium)',
        reason: 'Potassium deficiency is linked to leg cramps.'),
    _Recommendation(
        type: 'workout',
        emoji: '🤸‍♀️',
        title: 'Calf Stretches Before Bed',
        reason: 'Regular calf stretching prevents nocturnal leg cramps.'),
  ],
  'Mood Swings': [
    _Recommendation(
        type: 'workout',
        emoji: '🚶‍♀️',
        title: 'Daily Walk Outdoors',
        reason: 'Exercise releases endorphins and serotonin, improving mood.'),
    _Recommendation(
        type: 'workout',
        emoji: '🧘‍♀️',
        title: 'Prenatal Yoga',
        reason: 'Mindfulness and breathing reduce emotional reactivity.'),
  ],
  'Anxiety': [
    _Recommendation(
        type: 'workout',
        emoji: '🧘‍♀️',
        title: 'Prenatal Yoga & Breathing',
        reason: 'Deep breathing activates the parasympathetic nervous system.'),
    _Recommendation(
        type: 'food',
        emoji: '🫐',
        title: 'Yogurt & Berry Parfait',
        reason: 'Gut-brain axis: probiotics may reduce anxiety symptoms.'),
  ],
  'Dizziness': [
    _Recommendation(
        type: 'food',
        emoji: '🧃',
        title: 'Eat Small Frequent Meals',
        reason: 'Low blood sugar is a common cause of dizziness in pregnancy.'),
    _Recommendation(
        type: 'food',
        emoji: '💧',
        title: 'Stay Hydrated',
        reason:
            'Dehydration causes blood pressure drops leading to dizziness.'),
  ],
};

// ── Screen ────────────────────────────────────────────────────────────────────

class SymptomTrackerScreen extends StatefulWidget {
  const SymptomTrackerScreen({super.key});

  @override
  State<SymptomTrackerScreen> createState() => _SymptomTrackerScreenState();
}

class _SymptomTrackerScreenState extends State<SymptomTrackerScreen> {
  final List<_Symptom> _symptoms = _allSymptoms
      .map((s) => _Symptom(name: s.name, emoji: s.emoji, category: s.category))
      .toList();
  int _severity = 2; // 1-5
  bool _showResults = false;
  bool _aiLoading = false;
  String? _aiResponse;
  final _noteCtrl = TextEditingController();

  List<_Symptom> get _selected => _symptoms.where((s) => s.selected).toList();

  List<_Recommendation> get _recommendations {
    final recs = <_Recommendation>[];
    for (final sym in _selected) {
      final r = _symptomRecommendations[sym.name];
      if (r != null) recs.addAll(r);
    }
    // Deduplicate by title
    final seen = <String>{};
    return recs.where((r) => seen.add(r.title)).toList();
  }

  void _submit() {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one symptom')),
      );
      return;
    }
    setState(() => _showResults = true);
  }

  Future<void> _askAI() async {
    setState(() {
      _aiLoading = true;
      _aiResponse = null;
    });
    // Simulate AI call (backend not connected yet)
    await Future.delayed(const Duration(seconds: 2));
    final symptomList = _selected.map((s) => s.name).join(', ');
    setState(() {
      _aiLoading = false;
      _aiResponse =
          'Based on your symptoms ($symptomList) at severity level $_severity/5:\n\n'
          '${_selected.any((s) => s.name == 'Nausea' || s.name == 'Fatigue') ? '🌿 Your symptoms suggest early pregnancy discomforts. Ensure you\'re eating small frequent meals and resting well.\n\n' : ''}'
          '${_selected.any((s) => s.name == 'Back Pain' || s.name == 'Pelvic Pressure') ? '⚠️ Pelvic and back pain in later pregnancy can be normal but should be monitored. Avoid heavy lifting and try a pregnancy support belt.\n\n' : ''}'
          '${_selected.any((s) => s.name == 'Headache' || s.name == 'Dizziness') ? '💧 Headaches and dizziness can indicate dehydration or blood pressure changes. Drink water and rest in a cool place.\n\n' : ''}'
          'If symptoms are severe or sudden, please contact your midwife immediately. This advice does not replace professional medical care.';
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
          onPressed: () {
            if (_showResults)
              setState(() {
                _showResults = false;
                _aiResponse = null;
              });
            else
              Navigator.pop(context);
          },
        ),
        title: Text(_showResults ? 'Recommendations' : 'Symptom Tracker',
            style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _showResults
            ? _ResultsView(
                key: const ValueKey('results'),
                selected: _selected,
                recommendations: _recommendations,
                aiLoading: _aiLoading,
                aiResponse: _aiResponse,
                onAskAI: _askAI,
                onBack: () => setState(() {
                  _showResults = false;
                  _aiResponse = null;
                }),
              )
            : _InputView(
                key: const ValueKey('input'),
                symptoms: _symptoms,
                severity: _severity,
                noteCtrl: _noteCtrl,
                onToggle: (s) => setState(() => s.selected = !s.selected),
                onSeverityChanged: (v) => setState(() => _severity = v),
                onSubmit: _submit,
              ),
      ),
    );
  }
}

// ── Input view ────────────────────────────────────────────────────────────────

class _InputView extends StatelessWidget {
  final List<_Symptom> symptoms;
  final int severity;
  final TextEditingController noteCtrl;
  final void Function(_Symptom) onToggle;
  final ValueChanged<int> onSeverityChanged;
  final VoidCallback onSubmit;

  const _InputView({
    super.key,
    required this.symptoms,
    required this.severity,
    required this.noteCtrl,
    required this.onToggle,
    required this.onSeverityChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final categories = symptoms.map((s) => s.category).toSet().toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE8856A), Color(0xFFD4614A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('How are you feeling?',
                      style:
                          AppTextStyles.heading3.copyWith(color: Colors.white)),
                  Text('Select all symptoms you\'re experiencing today.',
                      style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.9))),
                ])),
            const Text('🩺', style: TextStyle(fontSize: 36)),
          ]),
        ),
        const SizedBox(height: AppSpacing.lg),
        ...categories.map((cat) {
          final catSymptoms = symptoms.where((s) => s.category == cat).toList();
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cat,
                    style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMedium)),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: catSymptoms
                      .map((s) => GestureDetector(
                            onTap: () => onToggle(s),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: s.selected
                                    ? AppColors.primary
                                    : Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.full),
                                border: Border.all(
                                    color: s.selected
                                        ? AppColors.primary
                                        : AppColors.border),
                                boxShadow: s.selected
                                    ? [
                                        BoxShadow(
                                            color: AppColors.primary
                                                .withValues(alpha: 0.3),
                                            blurRadius: 6)
                                      ]
                                    : [],
                              ),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(s.emoji,
                                        style: const TextStyle(fontSize: 14)),
                                    const SizedBox(width: 6),
                                    Text(s.name,
                                        style: AppTextStyles.bodySmall.copyWith(
                                            color: s.selected
                                                ? Colors.white
                                                : AppColors.textDark,
                                            fontWeight: FontWeight.w500)),
                                  ]),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
              ]);
        }),
        Text('Severity (1 = Mild, 5 = Severe)',
            style:
                AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: List.generate(5, (i) {
            final val = i + 1;
            final active = val <= severity;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSeverityChanged(val),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 40,
                  decoration: BoxDecoration(
                    color: active ? _severityColor(severity) : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                        color: active
                            ? _severityColor(severity)
                            : AppColors.border),
                  ),
                  child: Center(
                      child: Text('$val',
                          style: AppTextStyles.bodyMedium.copyWith(
                              color:
                                  active ? Colors.white : AppColors.textLight,
                              fontWeight: FontWeight.w700))),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Additional Notes (optional)',
            style:
                AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: noteCtrl,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Any extra details about how you\'re feeling...',
            hintStyle: AppTextStyles.hintText,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.primary)),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full)),
            ),
            child: Text('Get Recommendations', style: AppTextStyles.buttonText),
          ),
        ),
      ]),
    );
  }

  Color _severityColor(int s) {
    if (s <= 2) return Colors.green;
    if (s == 3) return Colors.orange;
    return Colors.red;
  }
}

// ── Results view ──────────────────────────────────────────────────────────────

class _ResultsView extends StatelessWidget {
  final List<_Symptom> selected;
  final List<_Recommendation> recommendations;
  final bool aiLoading;
  final String? aiResponse;
  final VoidCallback onAskAI;
  final VoidCallback onBack;

  const _ResultsView({
    super.key,
    required this.selected,
    required this.recommendations,
    required this.aiLoading,
    this.aiResponse,
    required this.onAskAI,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final workouts = recommendations.where((r) => r.type == 'workout').toList();
    final foods = recommendations.where((r) => r.type == 'food').toList();
    final meds = recommendations.where((r) => r.type == 'medicine').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Selected symptoms chips
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: selected
              .map((s) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text('${s.emoji} ${s.name}',
                        style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500)),
                  ))
              .toList(),
        ),
        const SizedBox(height: AppSpacing.lg),

        // AI ask button
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Text('✨', style: TextStyle(fontSize: 20)),
              const SizedBox(width: AppSpacing.sm),
              Text('Ask AI for Personalised Advice',
                  style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 6),
            Text('Get a detailed explanation of your symptoms and what to do.',
                style: AppTextStyles.bodySmall
                    .copyWith(color: Colors.white.withValues(alpha: 0.9))),
            const SizedBox(height: AppSpacing.md),
            if (aiLoading)
              const Center(
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
            else if (aiResponse != null)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(aiResponse!,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: Colors.white, height: 1.5)),
              )
            else
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onAskAI,
                  icon: const Icon(Icons.auto_awesome,
                      color: Colors.white, size: 16),
                  label: const Text('Ask AI',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.full)),
                  ),
                ),
              ),
          ]),
        ),

        const SizedBox(height: AppSpacing.lg),

        if (workouts.isNotEmpty) ...[
          _SectionHeader(icon: '🏃‍♀️', title: 'Recommended Workouts'),
          const SizedBox(height: AppSpacing.sm),
          ...workouts.map((r) => _RecCard(rec: r, color: AppColors.primary)),
          const SizedBox(height: AppSpacing.md),
        ],
        if (foods.isNotEmpty) ...[
          _SectionHeader(icon: '🥗', title: 'Recommended Foods & Recipes'),
          const SizedBox(height: AppSpacing.sm),
          ...foods.map((r) => _RecCard(rec: r, color: Colors.green)),
          const SizedBox(height: AppSpacing.md),
        ],
        if (meds.isNotEmpty) ...[
          _SectionHeader(icon: '💊', title: 'Medicine Suggestions'),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Row(children: [
              const Icon(Icons.info_outline, color: Colors.orange, size: 14),
              const SizedBox(width: 6),
              Expanded(
                  child: Text(
                      'Always consult your midwife or doctor before taking medicines.',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: Colors.orange.shade800))),
            ]),
          ),
          ...meds.map((r) => _RecCard(rec: r, color: Colors.orange)),
        ],

        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: onBack,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full)),
            ),
            child: const Text('Track New Symptoms'),
          ),
        ),
      ]),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String icon, title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) => Row(children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text(title,
            style:
                AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
      ]);
}

class _RecCard extends StatelessWidget {
  final _Recommendation rec;
  final Color color;
  const _RecCard({required this.rec, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(children: [
          Text(rec.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(rec.title,
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(rec.reason,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textMedium, height: 1.4)),
              ])),
          Icon(Icons.chevron_right, color: color, size: 18),
        ]),
      );
}
