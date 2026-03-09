// lib/screens/diet/diet_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

class _Recipe {
  final String name;
  final String category;
  final String description;
  final List<String> benefits;
  final List<String> ingredients;
  final String prepTime;
  final String trimesterBest;
  final String emoji;
  final bool isPremium;

  const _Recipe({
    required this.name,
    required this.category,
    required this.description,
    required this.benefits,
    required this.ingredients,
    required this.prepTime,
    required this.trimesterBest,
    required this.emoji,
    this.isPremium = false,
  });
}

const _recipes = [
  _Recipe(
    name: 'Lentil & Spinach Soup',
    category: 'Iron-Rich',
    emoji: '🥣',
    description:
        'A warming, nutrient-dense soup packed with plant-based iron and folate.',
    benefits: [
      'High in iron (prevents anaemia)',
      'Rich in folate (neural tube development)',
      'High fibre (relieves constipation)'
    ],
    ingredients: [
      '1 cup red lentils',
      '2 cups spinach',
      '1 carrot',
      '1 onion',
      '2 garlic cloves',
      'Cumin, turmeric',
      'Lemon juice'
    ],
    prepTime: '25 min',
    trimesterBest: 'All trimesters',
  ),
  _Recipe(
    name: 'Avocado & Egg Toast',
    category: 'Protein & Healthy Fats',
    emoji: '🥑',
    description:
        'Quick, filling breakfast with choline for fetal brain development.',
    benefits: [
      'Rich in choline (brain development)',
      'Healthy omega-3 fats',
      'Complete protein source'
    ],
    ingredients: [
      '2 slices whole grain bread',
      '1 avocado',
      '2 eggs (fully cooked)',
      'Lemon juice',
      'Salt, pepper'
    ],
    prepTime: '10 min',
    trimesterBest: '1st & 2nd trimester',
  ),
  _Recipe(
    name: 'Sardine & Tomato Pasta',
    category: 'Omega-3',
    emoji: '🍝',
    description:
        'Low-mercury fish high in DHA, essential for baby\'s brain and eye development.',
    benefits: [
      'DHA for brain & eye development',
      'Calcium for bones',
      'High protein',
      'Low mercury (safer than tuna)'
    ],
    ingredients: [
      '200g whole wheat pasta',
      '1 can sardines in tomato',
      '2 garlic cloves',
      'Cherry tomatoes',
      'Fresh parsley',
      'Olive oil'
    ],
    prepTime: '20 min',
    trimesterBest: '2nd & 3rd trimester',
  ),
  _Recipe(
    name: 'Banana Oat Smoothie',
    category: 'Energy Boost',
    emoji: '🍌',
    description:
        'Easy-to-digest morning smoothie to combat first trimester nausea.',
    benefits: [
      'Vitamin B6 (reduces nausea)',
      'Slow-release energy',
      'Potassium for muscle cramps',
      'Gentle on stomach'
    ],
    ingredients: [
      '1 banana',
      '1/2 cup oats',
      '1 cup milk or almond milk',
      '1 tbsp honey',
      'A pinch of cinnamon'
    ],
    prepTime: '5 min',
    trimesterBest: '1st trimester',
  ),
  _Recipe(
    name: 'Salmon & Quinoa Bowl',
    category: 'Omega-3 + Protein',
    emoji: '🐟',
    isPremium: true,
    description:
        'Complete meal with salmon (DHA) and quinoa (complete amino acid profile).',
    benefits: [
      'High DHA for neural development',
      'Complete protein (all amino acids)',
      'Iron + zinc',
      'Anti-inflammatory'
    ],
    ingredients: [
      '150g salmon fillet',
      '1 cup quinoa',
      'Cucumber',
      'Avocado',
      'Lemon tahini dressing'
    ],
    prepTime: '30 min',
    trimesterBest: '2nd & 3rd trimester',
  ),
  _Recipe(
    name: 'Yogurt & Berry Parfait',
    category: 'Calcium + Antioxidants',
    emoji: '🫐',
    isPremium: true,
    description:
        'Probiotic-rich dessert that supports gut health and delivers calcium.',
    benefits: [
      'Probiotics (gut & immune health)',
      'Calcium for fetal bones',
      'Antioxidants from berries',
      'Protein'
    ],
    ingredients: [
      '1 cup Greek yogurt',
      'Mixed berries',
      '2 tbsp granola',
      '1 tbsp honey',
      'Chia seeds'
    ],
    prepTime: '5 min',
    trimesterBest: 'All trimesters',
  ),
  _Recipe(
    name: 'Chickpea & Sweet Potato Curry',
    category: 'Iron + Vitamin A',
    emoji: '🍛',
    isPremium: true,
    description: 'Plant-powered curry high in iron, folate, and beta-carotene.',
    benefits: [
      'Plant iron (pair with vitamin C for absorption)',
      'Beta-carotene → Vitamin A',
      'Folate',
      'High fibre'
    ],
    ingredients: [
      '1 can chickpeas',
      '1 large sweet potato',
      'Coconut milk',
      'Spinach',
      'Ginger, turmeric, garam masala'
    ],
    prepTime: '35 min',
    trimesterBest: '2nd trimester',
  ),
  _Recipe(
    name: 'Date & Walnut Energy Balls',
    category: 'Natural Sugars + Energy',
    emoji: '🟤',
    isPremium: true,
    description:
        'Research-backed: dates in late pregnancy may support cervical ripening.',
    benefits: [
      'Natural energy boost',
      'Dates may ease labour (evidence-based)',
      'Omega-3 from walnuts',
      'No refined sugar'
    ],
    ingredients: [
      '10 Medjool dates',
      '1 cup walnuts',
      '2 tbsp cocoa powder',
      'Desiccated coconut',
      'Sesame seeds'
    ],
    prepTime: '15 min',
    trimesterBest: '3rd trimester',
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  String _filter = 'All';
  final _filters = [
    'All',
    '1st Trimester',
    '2nd Trimester',
    '3rd Trimester',
    'Iron-Rich',
    'Omega-3',
    'Protein'
  ];

  List<_Recipe> get _filtered {
    if (_filter == 'All') return _recipes;
    return _recipes.where((r) {
      if (_filter.contains('Trimester')) {
        return r.trimesterBest.contains(_filter.split(' ')[0]) ||
            r.trimesterBest.contains('All');
      }
      return r.category.toLowerCase().contains(_filter.toLowerCase());
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Nutrition & Recipes', style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header gradient card
          Container(
            margin: const EdgeInsets.all(AppSpacing.md),
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
                    Text('Eat Well, Grow Strong',
                        style: AppTextStyles.heading3
                            .copyWith(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Recipes tailored for each stage of your pregnancy',
                        style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.9))),
                  ])),
              const Text('🥗', style: TextStyle(fontSize: 40)),
            ]),
          ),

          // Filters
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: _filters.length,
              itemBuilder: (_, i) {
                final active = _filter == _filters[i];
                return GestureDetector(
                  onTap: () => setState(() => _filter = _filters[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: AppSpacing.sm),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                          color: active ? AppColors.primary : AppColors.border),
                    ),
                    child: Text(_filters[i],
                        style: AppTextStyles.bodySmall.copyWith(
                          color: active ? Colors.white : AppColors.textMedium,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Premium banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E7),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: const Color(0xFFFFCC50)),
            ),
            child: Row(children: [
              const Text('👑', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(
                      '${_recipes.where((r) => r.isPremium).length} premium recipes locked. Upgrade to unlock all.',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: const Color(0xFF8B6914)))),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, minimumSize: Size.zero),
                child: Text('Unlock',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFF8B6914),
                        fontWeight: FontWeight.w700)),
              ),
            ]),
          ),

          const SizedBox(height: AppSpacing.md),

          // Recipe list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _RecipeCard(recipe: _filtered[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeCard extends StatefulWidget {
  final _Recipe recipe;
  const _RecipeCard({required this.recipe});
  @override
  State<_RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<_RecipeCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.recipe;
    final locked = r.isPremium;

    return GestureDetector(
      onTap: () {
        if (locked) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Upgrade to Premium to unlock this recipe 👑')),
          );
          return;
        }
        setState(() => _expanded = !_expanded);
      },
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
              // Emoji avatar
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Center(
                    child: Text(r.emoji, style: const TextStyle(fontSize: 26))),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(children: [
                      Expanded(
                          child: Text(r.name,
                              style: AppTextStyles.bodyLarge
                                  .copyWith(fontWeight: FontWeight.w600))),
                      if (locked)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Text('👑', style: TextStyle(fontSize: 16)),
                        ),
                    ]),
                    const SizedBox(height: 2),
                    Text(r.category,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.schedule,
                          size: 12, color: AppColors.textLight),
                      Text('  ${r.prepTime}',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textLight)),
                      const SizedBox(width: AppSpacing.sm),
                      const Icon(Icons.pregnant_woman,
                          size: 12, color: AppColors.textLight),
                      Expanded(
                          child: Text('  ${r.trimesterBest}',
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: AppColors.textLight),
                              overflow: TextOverflow.ellipsis)),
                    ]),
                  ])),
              if (!locked)
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textLight,
                  size: 20,
                ),
            ]),
          ),
          if (locked)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF8E7),
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(AppRadius.lg)),
              ),
              child: const Center(
                child: Text('🔒 Premium Recipe — Tap to unlock',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B6914),
                        fontWeight: FontWeight.w500)),
              ),
            ),
          if (!locked && _expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.description,
                        style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMedium, height: 1.5)),
                    const SizedBox(height: AppSpacing.md),
                    Text('Benefits',
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: AppSpacing.sm),
                    ...r.benefits.map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('✅ ',
                                    style: TextStyle(fontSize: 12)),
                                Expanded(
                                    child: Text(b,
                                        style: AppTextStyles.bodySmall
                                            .copyWith(height: 1.4))),
                              ]),
                        )),
                    const SizedBox(height: AppSpacing.md),
                    Text('Ingredients',
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: r.ingredients
                          .map((ing) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.07),
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.full),
                                ),
                                child: Text(ing,
                                    style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.primary,
                                        fontSize: 11)),
                              ))
                          .toList(),
                    ),
                  ]),
            ),
          ],
        ]),
      ),
    );
  }
}
