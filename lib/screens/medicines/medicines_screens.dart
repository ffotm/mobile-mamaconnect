// lib/screens/medicines/medicines_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

enum SafetyLevel { safe, caution, unsafe }

class _Medicine {
  final String name;
  final String category;
  final SafetyLevel safety;
  final String use;
  final String sideEffects;
  final String note;
  final String trimesterAdvice;

  const _Medicine({
    required this.name,
    required this.category,
    required this.safety,
    required this.use,
    required this.sideEffects,
    required this.note,
    required this.trimesterAdvice,
  });
}

const _medicines = [
  _Medicine(
      name: 'Paracetamol (Acetaminophen)',
      category: 'Pain Relief',
      safety: SafetyLevel.safe,
      use: 'Fever, mild to moderate pain relief',
      sideEffects: 'Rare at recommended doses. Liver damage if overdosed.',
      note: 'Preferred pain reliever during pregnancy. Do not exceed 4g/day.',
      trimesterAdvice: 'Safe in all trimesters at recommended doses.'),
  _Medicine(
      name: 'Ibuprofen',
      category: 'Pain Relief / NSAID',
      safety: SafetyLevel.unsafe,
      use: 'Pain, inflammation, fever',
      sideEffects:
          'Can cause premature closure of ductus arteriosus, reduced amniotic fluid.',
      note:
          'Avoid especially after 20 weeks. Can cause serious fetal complications.',
      trimesterAdvice:
          'Avoid in 2nd and 3rd trimester. Consult doctor if needed in 1st.'),
  _Medicine(
      name: 'Aspirin (low dose 75–100mg)',
      category: 'Antiplatelet',
      safety: SafetyLevel.caution,
      use: 'Prevention of pre-eclampsia when prescribed',
      sideEffects: 'Bleeding risk, can affect platelet function in newborn.',
      note: 'Only take if prescribed by your doctor for specific conditions.',
      trimesterAdvice:
          'Low dose may be prescribed from 12 weeks. High doses unsafe.'),
  _Medicine(
      name: 'Amoxicillin',
      category: 'Antibiotic',
      safety: SafetyLevel.safe,
      use: 'Bacterial infections (UTI, respiratory)',
      sideEffects:
          'Nausea, diarrhoea, allergic reaction in penicillin-allergic patients.',
      note: 'Considered safe. Inform doctor of any penicillin allergy.',
      trimesterAdvice: 'Safe in all trimesters.'),
  _Medicine(
      name: 'Metronidazole',
      category: 'Antibiotic / Antiprotozoal',
      safety: SafetyLevel.caution,
      use: 'Bacterial vaginosis, Trichomonas, anaerobic infections',
      sideEffects: 'Metallic taste, nausea, headache.',
      note: 'Avoid in first trimester if possible. Usually safe after that.',
      trimesterAdvice:
          'Avoid in 1st trimester. Safe in 2nd and 3rd with prescription.'),
  _Medicine(
      name: 'Omeprazole',
      category: 'Antacid / PPI',
      safety: SafetyLevel.safe,
      use: 'Acid reflux, heartburn, GERD',
      sideEffects: 'Headache, diarrhoea, nausea — generally mild.',
      note: 'Commonly prescribed during pregnancy for heartburn.',
      trimesterAdvice: 'Safe in all trimesters.'),
  _Medicine(
      name: 'Vitamin D3 (Cholecalciferol)',
      category: 'Supplement',
      safety: SafetyLevel.safe,
      use: 'Bone health, immune support',
      sideEffects: 'Toxicity only at very high doses (>4000 IU/day).',
      note: 'Recommended for all pregnant women. 400–1000 IU/day.',
      trimesterAdvice: 'Safe and recommended in all trimesters.'),
  _Medicine(
      name: 'Folic Acid',
      category: 'Supplement',
      safety: SafetyLevel.safe,
      use: 'Neural tube defect prevention',
      sideEffects: 'Rarely causes side effects at recommended doses.',
      note:
          'Essential — start before conception and continue through 1st trimester.',
      trimesterAdvice:
          'Critical in 1st trimester. Continue throughout pregnancy.'),
  _Medicine(
      name: 'Tetracycline',
      category: 'Antibiotic',
      safety: SafetyLevel.unsafe,
      use: 'Bacterial infections',
      sideEffects:
          'Inhibits bone and teeth development in fetus, liver toxicity.',
      note:
          'Contraindicated in pregnancy. Can cause permanent yellow staining of baby\'s teeth.',
      trimesterAdvice: 'Do not use at any stage of pregnancy.'),
  _Medicine(
      name: 'Cetirizine (Zyrtec)',
      category: 'Antihistamine',
      safety: SafetyLevel.caution,
      use: 'Allergies, hay fever, hives',
      sideEffects: 'Drowsiness, dry mouth.',
      note: 'Generally considered low risk but use only if needed.',
      trimesterAdvice: 'Preferred antihistamine in pregnancy. Consult doctor.'),
  _Medicine(
      name: 'Codeine',
      category: 'Opioid Analgesic',
      safety: SafetyLevel.unsafe,
      use: 'Pain relief, cough suppression',
      sideEffects:
          'Neonatal opioid withdrawal syndrome, breathing problems in newborn.',
      note: 'Avoid during pregnancy especially near delivery.',
      trimesterAdvice:
          'Avoid in all trimesters. Very dangerous near due date.'),
  _Medicine(
      name: 'Iron Supplements (Ferrous Sulfate)',
      category: 'Supplement',
      safety: SafetyLevel.safe,
      use: 'Iron deficiency anaemia',
      sideEffects: 'Constipation, dark stools, nausea — take with food.',
      note:
          'Very commonly prescribed in pregnancy. Essential for blood production.',
      trimesterAdvice: 'Safe and often recommended from 2nd trimester onward.'),
];

// All known drug names that map to safety
final _searchDatabase = {
  'paracetamol': SafetyLevel.safe,
  'acetaminophen': SafetyLevel.safe,
  'tylenol': SafetyLevel.safe,
  'doliprane': SafetyLevel.safe,
  'ibuprofen': SafetyLevel.unsafe,
  'advil': SafetyLevel.unsafe,
  'nurofen': SafetyLevel.unsafe,
  'aspirin': SafetyLevel.caution,
  'aspegic': SafetyLevel.caution,
  'amoxicillin': SafetyLevel.safe,
  'augmentin': SafetyLevel.safe,
  'clamoxyl': SafetyLevel.safe,
  'metronidazole': SafetyLevel.caution,
  'flagyl': SafetyLevel.caution,
  'omeprazole': SafetyLevel.safe,
  'pantoprazole': SafetyLevel.safe,
  'mopral': SafetyLevel.safe,
  'vitamin d': SafetyLevel.safe,
  'folic acid': SafetyLevel.safe,
  'folate': SafetyLevel.safe,
  'tetracycline': SafetyLevel.unsafe,
  'doxycycline': SafetyLevel.unsafe,
  'cetirizine': SafetyLevel.caution,
  'zyrtec': SafetyLevel.caution,
  'loratadine': SafetyLevel.caution,
  'claritin': SafetyLevel.caution,
  'codeine': SafetyLevel.unsafe,
  'tramadol': SafetyLevel.unsafe,
  'iron': SafetyLevel.safe,
  'ferrous': SafetyLevel.safe,
};

// ── Screen ────────────────────────────────────────────────────────────────────

class MedicinesScreen extends StatefulWidget {
  const MedicinesScreen({super.key});

  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _filterCategory = 'All';
  SafetyLevel? _filterSafety;

  // Checker tab
  final _checkerCtrl = TextEditingController();
  String _checkerQuery = '';
  _CheckerResult? _checkerResult;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    _searchCtrl.dispose();
    _checkerCtrl.dispose();
    super.dispose();
  }

  List<_Medicine> get _filtered {
    return _medicines.where((m) {
      final matchQ =
          _query.isEmpty || m.name.toLowerCase().contains(_query.toLowerCase());
      final matchCat =
          _filterCategory == 'All' || m.category.contains(_filterCategory);
      final matchSafety = _filterSafety == null || m.safety == _filterSafety;
      return matchQ && matchCat && matchSafety;
    }).toList();
  }

  void _checkMedicine() {
    final q = _checkerCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return;
    setState(() {
      _checkerQuery = _checkerCtrl.text.trim();
      // Try exact or partial match
      SafetyLevel? found;
      String? matchedKey;
      for (final entry in _searchDatabase.entries) {
        if (q.contains(entry.key) || entry.key.contains(q)) {
          found = entry.value;
          matchedKey = entry.key;
          break;
        }
      }
      _checkerResult = _CheckerResult(
        query: _checkerQuery,
        level: found,
        matchedKey: matchedKey,
      );
    });
    FocusScope.of(context).unfocus();
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Safe Medicines', style: AppTextStyles.heading3),
        centerTitle: true,
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textLight,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [Tab(text: 'Medicine List'), Tab(text: 'Safety Checker')],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          // ── Tab 1: List ────────────────────────────────────────────────
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
                child: Column(
                  children: [
                    // Search
                    TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: 'Search medicines...',
                        hintStyle: AppTextStyles.hintText,
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.textLight),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            borderSide:
                                const BorderSide(color: AppColors.border)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            borderSide:
                                const BorderSide(color: AppColors.border)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            borderSide:
                                const BorderSide(color: AppColors.primary)),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Safety filter
                    Row(
                      children: [
                        _SafetyFilterChip(
                            label: 'All',
                            active: _filterSafety == null,
                            onTap: () => setState(() => _filterSafety = null)),
                        const SizedBox(width: 6),
                        _SafetyFilterChip(
                            label: '✅ Safe',
                            color: Colors.green,
                            active: _filterSafety == SafetyLevel.safe,
                            onTap: () => setState(() => _filterSafety =
                                _filterSafety == SafetyLevel.safe
                                    ? null
                                    : SafetyLevel.safe)),
                        const SizedBox(width: 6),
                        _SafetyFilterChip(
                            label: '⚠️ Caution',
                            color: Colors.orange,
                            active: _filterSafety == SafetyLevel.caution,
                            onTap: () => setState(() => _filterSafety =
                                _filterSafety == SafetyLevel.caution
                                    ? null
                                    : SafetyLevel.caution)),
                        const SizedBox(width: 6),
                        _SafetyFilterChip(
                            label: '❌ Unsafe',
                            color: Colors.red,
                            active: _filterSafety == SafetyLevel.unsafe,
                            onTap: () => setState(() => _filterSafety =
                                _filterSafety == SafetyLevel.unsafe
                                    ? null
                                    : SafetyLevel.unsafe)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) => _MedicineCard(medicine: _filtered[i]),
                ),
              ),
            ],
          ),

          // ── Tab 2: Checker ─────────────────────────────────────────────
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Type any medicine name to check if it\'s safe during pregnancy.',
                          style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMedium, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Medicine Name', style: AppTextStyles.labelText),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _checkerCtrl,
                        onSubmitted: (_) => _checkMedicine(),
                        decoration: InputDecoration(
                          hintText: 'e.g. Paracetamol, Ibuprofen, Flagyl...',
                          hintStyle: AppTextStyles.hintText,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              borderSide:
                                  const BorderSide(color: AppColors.border)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              borderSide:
                                  const BorderSide(color: AppColors.border)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              borderSide:
                                  const BorderSide(color: AppColors.primary)),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _checkMedicine,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.md)),
                        ),
                        child: const Text('Check',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                if (_checkerResult != null)
                  _CheckerResultCard(result: _checkerResult!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyFilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color? color;
  const _SafetyFilterChip(
      {required this.label,
      required this.active,
      required this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: active
                ? (color ?? AppColors.primary).withValues(alpha: 0.15)
                : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
                color:
                    active ? (color ?? AppColors.primary) : AppColors.border),
          ),
          child: Text(label,
              style: AppTextStyles.bodySmall.copyWith(
                  color: active
                      ? (color ?? AppColors.primary)
                      : AppColors.textMedium,
                  fontWeight: FontWeight.w600,
                  fontSize: 11)),
        ),
      );
}

class _MedicineCard extends StatefulWidget {
  final _Medicine medicine;
  const _MedicineCard({required this.medicine});
  @override
  State<_MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<_MedicineCard> {
  bool _expanded = false;

  Color get _color => switch (widget.medicine.safety) {
        SafetyLevel.safe => Colors.green,
        SafetyLevel.caution => Colors.orange,
        SafetyLevel.unsafe => Colors.red,
      };

  String get _safetyLabel => switch (widget.medicine.safety) {
        SafetyLevel.safe => '✅ Safe',
        SafetyLevel.caution => '⚠️ Caution',
        SafetyLevel.unsafe => '❌ Unsafe',
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
              color: _expanded
                  ? _color.withValues(alpha: 0.4)
                  : AppColors.divider),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(widget.medicine.name,
                      style: AppTextStyles.bodyLarge
                          .copyWith(fontWeight: FontWeight.w600)),
                  Text(widget.medicine.category,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textLight)),
                ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(_safetyLabel,
                  style: AppTextStyles.bodySmall.copyWith(
                      color: _color,
                      fontWeight: FontWeight.w600,
                      fontSize: 11)),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
                _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: AppColors.textLight,
                size: 20),
          ]),
          if (_expanded) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),
            _DetailRow(
                icon: Icons.medical_services_outlined,
                color: Colors.blue,
                label: 'Use',
                value: widget.medicine.use),
            const SizedBox(height: AppSpacing.sm),
            _DetailRow(
                icon: Icons.warning_amber_outlined,
                color: Colors.orange,
                label: 'Side Effects',
                value: widget.medicine.sideEffects),
            const SizedBox(height: AppSpacing.sm),
            _DetailRow(
                icon: Icons.pregnant_woman,
                color: AppColors.primary,
                label: 'Pregnancy Note',
                value: widget.medicine.note),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.schedule, color: _color, size: 14),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(widget.medicine.trimesterAdvice,
                        style: AppTextStyles.bodySmall.copyWith(
                            color: _color, fontWeight: FontWeight.w500))),
              ]),
            ),
          ],
        ]),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, value;
  const _DetailRow(
      {required this.icon,
      required this.color,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Expanded(
            child: RichText(
                text: TextSpan(style: AppTextStyles.bodySmall, children: [
          TextSpan(
              text: '$label: ',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Color(0xFF2D2D2D))),
          TextSpan(
              text: value, style: const TextStyle(color: Color(0xFF6B6B6B))),
        ]))),
      ]);
}

class _CheckerResult {
  final String query;
  final SafetyLevel? level;
  final String? matchedKey;
  const _CheckerResult({required this.query, this.level, this.matchedKey});
}

class _CheckerResultCard extends StatelessWidget {
  final _CheckerResult result;
  const _CheckerResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    if (result.level == null) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(children: [
          const Icon(Icons.help_outline, color: Colors.grey, size: 40),
          const SizedBox(height: AppSpacing.md),
          Text('Medicine Not Found', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.sm),
          Text(
              '"${result.query}" is not in our database. Please consult your midwife or doctor before taking any medicine.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textMedium, height: 1.4)),
        ]),
      );
    }

    final color = switch (result.level!) {
      SafetyLevel.safe => Colors.green,
      SafetyLevel.caution => Colors.orange,
      SafetyLevel.unsafe => Colors.red,
    };
    final icon = switch (result.level!) {
      SafetyLevel.safe => Icons.check_circle,
      SafetyLevel.caution => Icons.warning_amber_rounded,
      SafetyLevel.unsafe => Icons.cancel,
    };
    final title = switch (result.level!) {
      SafetyLevel.safe => '✅ Generally Safe',
      SafetyLevel.caution => '⚠️ Use with Caution',
      SafetyLevel.unsafe => '❌ Unsafe During Pregnancy',
    };
    final message = switch (result.level!) {
      SafetyLevel.safe =>
        '"${result.query}" is considered safe during pregnancy at recommended doses. Always confirm with your doctor.',
      SafetyLevel.caution =>
        '"${result.query}" requires caution during pregnancy. It may be appropriate in certain circumstances — only take if prescribed.',
      SafetyLevel.unsafe =>
        '"${result.query}" is NOT recommended during pregnancy. It can cause harm to you or your baby. Contact your midwife for alternatives.',
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 48),
        const SizedBox(height: AppSpacing.md),
        Text(title, style: AppTextStyles.heading3.copyWith(color: color)),
        const SizedBox(height: AppSpacing.sm),
        Text(message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textMedium, height: 1.5)),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(children: [
            const Icon(Icons.local_hospital_outlined,
                size: 14, color: AppColors.textLight),
            const SizedBox(width: 6),
            Expanded(
                child: Text(
                    'Always consult your healthcare provider before taking any medicine during pregnancy.',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textLight, height: 1.4))),
          ]),
        ),
      ]),
    );
  }
}
