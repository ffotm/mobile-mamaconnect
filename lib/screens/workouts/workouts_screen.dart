// lib/screens/workouts/workouts_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

class _Workout {
  final String name;
  final String category;
  final String description;
  final List<String> steps;
  final String duration;
  final String intensity;
  final String emoji;
  final List<String> goals;
  final List<String> avoidIf; // physical conditions to avoid this
  final String trimesterOk;
  final List<String> benefits;

  const _Workout({
    required this.name,
    required this.category,
    required this.description,
    required this.steps,
    required this.duration,
    required this.intensity,
    required this.emoji,
    required this.goals,
    required this.avoidIf,
    required this.trimesterOk,
    required this.benefits,
  });
}

const _workouts = [
  _Workout(
    name: 'Prenatal Walking',
    category: 'Cardio',
    emoji: '🚶‍♀️',
    description:
        'Low-impact cardio that is safe at all stages. Improves circulation and mood.',
    duration: '20–30 min',
    intensity: 'Low',
    goals: ['Stay Active', 'Improve Mood', 'Manage Weight'],
    avoidIf: [],
    trimesterOk: 'All',
    benefits: [
      'Boosts circulation',
      'Improves sleep',
      'Reduces constipation',
      'Great for mood'
    ],
    steps: [
      'Wear supportive shoes',
      'Start at gentle pace for 5 min',
      'Maintain comfortable talking pace',
      'Avoid hills or rough terrain late in pregnancy',
      'Cool down with 5 min slow walk'
    ],
  ),
  _Workout(
    name: 'Prenatal Yoga',
    category: 'Flexibility & Relaxation',
    emoji: '🧘‍♀️',
    description:
        'Gentle stretching and breathing to ease pregnancy discomforts and reduce stress.',
    duration: '30–45 min',
    intensity: 'Low',
    goals: ['Reduce Stress', 'Improve Flexibility', 'Prepare for Labour'],
    avoidIf: ['Placenta previa', 'Risk of premature labour'],
    trimesterOk: 'All',
    benefits: [
      'Reduces back pain',
      'Improves breathing',
      'Mental calm',
      'Prepares for birth'
    ],
    steps: [
      'Cat-cow stretch: 10 reps',
      'Child\'s pose: hold 30 sec',
      'Seated side stretch: 30 sec each side',
      'Butterfly pose: 1 min',
      'Pelvic tilts: 15 reps',
      'Deep belly breathing: 5 min'
    ],
  ),
  _Workout(
    name: 'Pelvic Floor Exercises (Kegels)',
    category: 'Pelvic Health',
    emoji: '💪',
    description:
        'Strengthen pelvic floor muscles to support the uterus and ease delivery.',
    duration: '10 min',
    intensity: 'None',
    goals: ['Prepare for Labour', 'Prevent Incontinence'],
    avoidIf: ['Pelvic girdle pain (consult physio)'],
    trimesterOk: 'All',
    benefits: [
      'Prevents urinary incontinence',
      'Speeds recovery after birth',
      'Supports uterus/bowel/bladder',
      'Reduces risk of prolapse'
    ],
    steps: [
      'Identify pelvic floor muscles (stop urine mid-flow)',
      'Contract muscles for 5 seconds',
      'Relax for 5 seconds',
      'Repeat 10 times',
      'Do 3 sets per day (any position)',
      'Build to 10 second holds over time'
    ],
  ),
  _Workout(
    name: 'Swimming / Water Aerobics',
    category: 'Cardio',
    emoji: '🏊‍♀️',
    description:
        'Best full-body exercise in pregnancy. Water supports your belly weight.',
    duration: '30–40 min',
    intensity: 'Moderate',
    goals: ['Stay Active', 'Manage Weight', 'Reduce Swelling'],
    avoidIf: ['Waters have broken', 'Open sores'],
    trimesterOk: '1st & 2nd & 3rd',
    benefits: [
      'Relieves joint pressure',
      'Reduces swelling',
      'Full body workout',
      'Keeps cool in 3rd trimester'
    ],
    steps: [
      'Warm up with gentle laps for 5 min',
      'Flutter kicks holding pool edge: 2 min',
      'Arm circles in water: 2 min',
      'Side steps in pool: 5 min',
      'Floating relaxation: 5 min',
      'Cool down with slow breaststroke'
    ],
  ),
  _Workout(
    name: 'Seated Core & Back Strengthening',
    category: 'Strength',
    emoji: '🪑',
    description:
        'Safe seated exercises to reduce back pain common in 2nd and 3rd trimesters.',
    duration: '15–20 min',
    intensity: 'Low–Moderate',
    goals: ['Reduce Back Pain', 'Stay Active'],
    avoidIf: [
      'Diastasis recti (consult physio)',
      'Symphysis pubis dysfunction'
    ],
    trimesterOk: '2nd & 3rd',
    benefits: [
      'Reduces lower back pain',
      'Improves posture',
      'Supports growing belly',
      'Safe for all fitness levels'
    ],
    steps: [
      'Seated shoulder rolls: 10 each direction',
      'Seated pelvic tilts: 15 reps',
      'Seated marching (lift knees alternately): 30 sec',
      'Wall push-ups: 15 reps',
      'Arm raises with light weight: 10 reps each arm',
      'Hip circles standing: 10 each way'
    ],
  ),
  _Workout(
    name: 'Gentle Stretching Routine',
    category: 'Flexibility',
    emoji: '🤸‍♀️',
    description:
        'Simple full-body stretch to relieve tension, improve circulation and promote sleep.',
    duration: '15 min',
    intensity: 'None',
    goals: ['Improve Sleep', 'Reduce Stress', 'Improve Flexibility'],
    avoidIf: [],
    trimesterOk: 'All',
    benefits: [
      'Relieves muscle tension',
      'Improves sleep',
      'Reduces cramping',
      'Can be done before bed'
    ],
    steps: [
      'Neck rolls: 5 each direction',
      'Shoulder stretch across chest: 30 sec each',
      'Seated hamstring stretch: 30 sec each leg',
      'Hip flexor lunge stretch: 30 sec each side',
      'Calf stretch against wall: 30 sec each leg',
      'Full body relaxation lying on side: 3 min'
    ],
  ),
];

const _goals = [
  'All',
  'Stay Active',
  'Reduce Stress',
  'Manage Weight',
  'Reduce Back Pain',
  'Prepare for Labour',
  'Improve Sleep',
  'Improve Mood'
];
const _conditions = [
  'None',
  'Back Pain',
  'Pelvic Pain',
  'Placenta previa',
  'Risk of premature labour',
  'Diastasis recti',
  'Joint pain'
];

// ── Screen ────────────────────────────────────────────────────────────────────

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  bool _setup = true; // show goal selection first
  String _goal = 'Stay Active';
  String _condition = 'None';

  List<_Workout> get _filtered {
    return _workouts.where((w) {
      final matchGoal = _goal == 'All' || w.goals.contains(_goal);
      final matchCondition = _condition == 'None' ||
          !w.avoidIf
              .any((a) => a.toLowerCase().contains(_condition.toLowerCase()));
      return matchGoal && matchCondition;
    }).toList();
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
            if (!_setup) {
              setState(() => _setup = true);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(_setup ? 'Personalise Workouts' : 'Your Workouts',
            style: AppTextStyles.heading3),
        centerTitle: true,
        actions: [
          if (!_setup)
            TextButton(
              onPressed: () => setState(() => _setup = true),
              child: Text('Change',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.primary)),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _setup
            ? _SetupView(
                key: const ValueKey('setup'),
                selectedGoal: _goal,
                selectedCondition: _condition,
                onGoalChanged: (v) => setState(() => _goal = v),
                onConditionChanged: (v) => setState(() => _condition = v),
                onStart: () => setState(() => _setup = false),
              )
            : _WorkoutListView(
                key: const ValueKey('list'),
                workouts: _filtered,
                goal: _goal,
              ),
      ),
    );
  }
}

// ── Setup view ────────────────────────────────────────────────────────────────

class _SetupView extends StatelessWidget {
  final String selectedGoal, selectedCondition;
  final ValueChanged<String> onGoalChanged, onConditionChanged;
  final VoidCallback onStart;

  const _SetupView({
    super.key,
    required this.selectedGoal,
    required this.selectedCondition,
    required this.onGoalChanged,
    required this.onConditionChanged,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: Column(children: [
            const Text('🏃‍♀️', style: TextStyle(fontSize: 56)),
            const SizedBox(height: AppSpacing.md),
            Text('Let\'s personalise your\nworkout plan',
                textAlign: TextAlign.center, style: AppTextStyles.heading2),
            const SizedBox(height: AppSpacing.sm),
            Text(
                'We\'ll recommend safe exercises based on your goal and physical condition.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textLight, height: 1.5)),
          ]),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('What is your main goal?',
            style:
                AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _goals
              .skip(1)
              .map((g) => GestureDetector(
                    onTap: () => onGoalChanged(g),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedGoal == g
                            ? AppColors.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                            color: selectedGoal == g
                                ? AppColors.primary
                                : AppColors.border),
                      ),
                      child: Text(g,
                          style: AppTextStyles.bodySmall.copyWith(
                              color: selectedGoal == g
                                  ? Colors.white
                                  : AppColors.textMedium,
                              fontWeight: FontWeight.w600)),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Any physical conditions?',
            style:
                AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.sm),
        Text('We\'ll exclude exercises that could be harmful.',
            style:
                AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _conditions
              .map((c) => GestureDetector(
                    onTap: () => onConditionChanged(c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedCondition == c
                            ? Colors.orange
                            : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                            color: selectedCondition == c
                                ? Colors.orange
                                : AppColors.border),
                      ),
                      child: Text(c,
                          style: AppTextStyles.bodySmall.copyWith(
                              color: selectedCondition == c
                                  ? Colors.white
                                  : AppColors.textMedium,
                              fontWeight: FontWeight.w600)),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full)),
            ),
            child: Text('Show My Workouts', style: AppTextStyles.buttonText),
          ),
        ),
      ]),
    );
  }
}

// ── Workout list view ─────────────────────────────────────────────────────────

class _WorkoutListView extends StatelessWidget {
  final List<_Workout> workouts;
  final String goal;
  const _WorkoutListView(
      {super.key, required this.workouts, required this.goal});

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🤷‍♀️', style: TextStyle(fontSize: 48)),
          const SizedBox(height: AppSpacing.md),
          Text('No matching workouts', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.sm),
          Text('Try changing your goal or condition settings.',
              textAlign: TextAlign.center,
              style:
                  AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
        ]),
      ));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: workouts.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border:
                    Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(children: [
                const Icon(Icons.check_circle,
                    color: AppColors.primary, size: 16),
                const SizedBox(width: 8),
                Text('${workouts.length} workouts for "$goal"',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w600)),
              ]),
            ),
          );
        }
        return _WorkoutCard(workout: workouts[i - 1]);
      },
    );
  }
}

class _WorkoutCard extends StatefulWidget {
  final _Workout workout;
  const _WorkoutCard({required this.workout});
  @override
  State<_WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<_WorkoutCard> {
  bool _expanded = false;

  Color get _intensityColor => switch (widget.workout.intensity) {
        'None' => Colors.green,
        'Low' => Colors.teal,
        'Low–Moderate' => Colors.blue,
        'Moderate' => Colors.orange,
        _ => Colors.red,
      };

  @override
  Widget build(BuildContext context) {
    final w = widget.workout;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Center(
                    child: Text(w.emoji, style: const TextStyle(fontSize: 26))),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(w.name,
                        style: AppTextStyles.bodyLarge
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text(w.category,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.schedule,
                          size: 12, color: AppColors.textLight),
                      Text('  ${w.duration}',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textLight)),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _intensityColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(w.intensity,
                            style: AppTextStyles.bodySmall.copyWith(
                                color: _intensityColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ])),
              Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textLight,
                  size: 20),
            ]),
          ),
          if (_expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(w.description,
                        style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMedium, height: 1.5)),
                    const SizedBox(height: AppSpacing.md),
                    Text('Benefits',
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: AppSpacing.sm),
                    ...w.benefits.map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(children: [
                            const Text('💚 ', style: TextStyle(fontSize: 12)),
                            Expanded(
                                child: Text(b, style: AppTextStyles.bodySmall)),
                          ]),
                        )),
                    const SizedBox(height: AppSpacing.md),
                    Text('How to do it',
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: AppSpacing.sm),
                    ...w.steps.asMap().entries.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  margin:
                                      const EdgeInsets.only(right: 8, top: 1),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary
                                          .withValues(alpha: 0.12)),
                                  child: Center(
                                      child: Text('${e.key + 1}',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                  color: AppColors.primary,
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w700))),
                                ),
                                Expanded(
                                    child: Text(e.value,
                                        style: AppTextStyles.bodySmall
                                            .copyWith(height: 1.4))),
                              ]),
                        )),
                    if (w.avoidIf.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(
                              color: Colors.orange.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                const Icon(Icons.warning_amber_outlined,
                                    color: Colors.orange, size: 14),
                                const SizedBox(width: 4),
                                Text('Avoid if:',
                                    style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w700)),
                              ]),
                              ...w.avoidIf.map((c) => Text('• $c',
                                  style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.orange.shade800,
                                      height: 1.6))),
                            ]),
                      ),
                    ],
                  ]),
            ),
          ],
        ]),
      ),
    );
  }
}
