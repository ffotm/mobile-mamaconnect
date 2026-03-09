// lib/screens/timeline/timeline_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Constants — change these to match actual patient data
// ─────────────────────────────────────────────────────────────────────────────
const int _kCurrentWeek = 7;
const int _kCurrentDay = 3;
const String _kDueDate = 'May 26, 2025';
const String _kLmpDate = 'Aug 19, 2024';

// ─────────────────────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────────────────────
enum _EntryType { week, appointment, vaccine }

class _Entry {
  final _EntryType type;
  final int? week;
  final String title;
  final String dayRange; // e.g. "Days 43–49"
  final String? babySize;
  final String? babySizeEmoji;
  final List<String>? babyFacts;
  final List<String>? momFacts;
  final String? tip;
  final bool isCurrent;
  // appointment / vaccine
  final String? apptWhen;
  final String? apptWhere;
  final String? apptDuration;
  final String? apptDescription;

  const _Entry({
    required this.type,
    this.week,
    required this.title,
    required this.dayRange,
    this.babySize,
    this.babySizeEmoji,
    this.babyFacts,
    this.momFacts,
    this.tip,
    this.isCurrent = false,
    this.apptWhen,
    this.apptWhere,
    this.apptDuration,
    this.apptDescription,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Timeline data — full 40 weeks + appointments + vaccines
// ─────────────────────────────────────────────────────────────────────────────
final List<_Entry> _timelineEntries = [
  // ── FIRST TRIMESTER ───────────────────────────────────────────────────────

  _Entry(
    type: _EntryType.week,
    week: 1,
    title: 'Week 1',
    dayRange: 'Days 1–7 · Last menstrual period',
    babySize: 'Microscopic',
    babySizeEmoji: '🔬',
    babyFacts: [
      'No embryo yet — this week begins with your period',
      'Follicles in your ovary begin maturing',
      'Uterine lining is shedding and rebuilding',
    ],
    momFacts: [
      'Start 400 µg folic acid daily if not already',
      'Normal menstrual bleeding this week',
      'Avoid alcohol, smoking, and raw fish from now',
    ],
    tip:
        'Folic acid taken before conception and through week 12 reduces neural tube defect risk by 70%.',
  ),

  _Entry(
    type: _EntryType.week,
    week: 2,
    title: 'Week 2',
    dayRange: 'Days 8–14 · Ovulation window',
    babySize: 'Egg cell (0.1 mm)',
    babySizeEmoji: '⭕',
    babyFacts: [
      'Ovulation occurs around day 14',
      'Egg is released from the dominant follicle',
      'Fertilisation is possible for ~24 hours after ovulation',
    ],
    momFacts: [
      'Mild cramping (Mittelschmerz) is normal at ovulation',
      'Cervical mucus becomes clear and stretchy',
      'Basal body temperature rises slightly after ovulation',
    ],
    tip:
        'Sperm survive 3–5 days — conception is most likely if you have intercourse in the 5 days before ovulation.',
  ),

  _Entry(
    type: _EntryType.week,
    week: 3,
    title: 'Week 3',
    dayRange: 'Days 15–21 · Fertilisation & implantation',
    babySize: 'Poppy seed (0.1 mm)',
    babySizeEmoji: '🌱',
    babyFacts: [
      'Sperm meets egg → zygote formed',
      'Zygote divides rapidly into a blastocyst (100+ cells)',
      'Blastocyst travels down fallopian tube toward uterus',
      'Implantation into uterine wall begins around day 20–21',
    ],
    momFacts: [
      'No symptoms yet — too early for hCG to be detectable',
      'Possible very light implantation spotting (pink/brown)',
      'hCG hormone begins rising after implantation',
    ],
    tip:
        'Implantation spotting at days 6–12 post-ovulation is normal. It is lighter and shorter than a period.',
  ),

  _Entry(
    type: _EntryType.week,
    week: 4,
    title: 'Week 4',
    dayRange: 'Days 22–28 · Missed period',
    babySize: 'Sesame seed (1–2 mm)',
    babySizeEmoji: '🫘',
    babyFacts: [
      'Embryo about the size of a sesame seed',
      'Placenta and amniotic sac begin forming',
      'Three layers (ectoderm, mesoderm, endoderm) developing — every organ will come from these',
    ],
    momFacts: [
      'Missed period — take a home pregnancy test',
      'Breast tenderness and mild fatigue may begin',
      'hCG is now detectable in urine',
    ],
    tip:
        'Home tests are most accurate from the first day of your missed period. A blood test can detect pregnancy 1–2 days earlier.',
  ),

  _Entry(
    type: _EntryType.appointment,
    title: '📋 Confirm Pregnancy',
    dayRange: 'Recommended at Week 4–6',
    apptDescription:
        'Visit your GP or clinic to confirm pregnancy with a blood hCG test. Start your maternity care registration and get your first prescriptions (folic acid, vitamin D).',
    apptWhen: 'Week 4–6 (as soon as possible)',
    apptWhere: 'Your GP or family doctor',
    apptDuration: '~30 minutes',
  ),

  _Entry(
    type: _EntryType.week,
    week: 5,
    title: 'Week 5',
    dayRange: 'Days 29–35 · Neural tube forms',
    babySize: 'Apple seed (3 mm)',
    babySizeEmoji: '🍏',
    babyFacts: [
      'Neural tube closes — this becomes the brain and spinal cord',
      'Tiny heart begins beating at 80–85 bpm',
      'Arm and leg buds are just appearing',
      'Eyes and ear canals start forming',
    ],
    momFacts: [
      'Morning sickness may begin — can be all day',
      'Heightened sense of smell (hyperosmia)',
      'Extreme fatigue — your body is working hard',
      'Frequent urination begins as uterus presses on bladder',
    ],
    tip:
        'Eat small, frequent meals every 2–3 hours to manage nausea. Ginger tea and Vitamin B6 (10–25 mg) are safe and effective.',
  ),

  _Entry(
    type: _EntryType.week,
    week: 6,
    title: 'Week 6',
    dayRange: 'Days 36–42 · Heartbeat visible on scan',
    babySize: 'Lentil (5–6 mm)',
    babySizeEmoji: '🟤',
    babyFacts: [
      'Heartbeat visible on transvaginal ultrasound (110–160 bpm)',
      'Facial features forming — nose tip, jaw, cheeks',
      'Fingers beginning to form',
      'Pituitary gland and brain developing rapidly',
    ],
    momFacts: [
      'Nausea often peaks around week 6–9',
      'Areolae darken and breasts become tender',
      'Mood swings from surging estrogen and progesterone',
      'Bloating and constipation very common',
    ],
    tip:
        'An early scan at 6–8 weeks can confirm heartbeat, check position, and rule out ectopic pregnancy.',
  ),

  // ── CURRENT WEEK ──────────────────────────────────────────────────────────

  _Entry(
    type: _EntryType.week,
    week: 7,
    title: 'Week 7',
    dayRange: 'Days 43–49 · You are here ✦',
    isCurrent: true,
    babySize: 'Blueberry · 13 mm · ~1 gram',
    babySizeEmoji: '🫐',
    babyFacts: [
      'Brain growing 100 new cells every minute',
      'Arms bend at elbows — hands are paddle-shaped',
      'Eyelids forming, nostrils visible on tiny face',
      'Kidneys beginning to produce first urine',
      'Baby tooth buds forming under the gums',
    ],
    momFacts: [
      'Morning sickness often at its worst — can be all-day',
      'Excess saliva production (ptyalism gravidarum)',
      'Visible blue veins across breasts and abdomen',
      'Waistline beginning to thicken',
      'Deep fatigue — prioritise rest whenever you can',
    ],
    tip:
        'If vomiting prevents keeping ANY food or water down (hyperemesis gravidarum), contact your midwife immediately. Safe anti-nausea medication is available.',
  ),

  _Entry(
    type: _EntryType.appointment,
    title: '🩺 First Antenatal Booking',
    dayRange: 'Due at Week 8–10',
    apptDescription:
        'Your most important first appointment. Midwife takes full medical and family history, measures blood pressure and BMI, orders all first-trimester blood tests, and books your 12-week scan. Brings your prescriptions and sets up your maternity record.',
    apptWhen: 'Ideally before Week 10 — book now',
    apptWhere: 'Maternity clinic or community midwife',
    apptDuration: '60–90 minutes',
  ),

  _Entry(
    type: _EntryType.vaccine,
    title: '💉 First Blood Tests & Screenings',
    dayRange: 'At booking (Week 8–10)',
    apptDescription:
        'Full blood count (anaemia check), blood group & Rhesus factor, rubella immunity, hepatitis B surface antigen, syphilis, HIV, urine culture for infection, and thyroid function. These protect you and your baby.',
    apptWhen: 'At your booking appointment',
    apptWhere: 'Clinic lab or blood draw centre',
    apptDuration: '20–30 minutes',
  ),

  _Entry(
    type: _EntryType.week,
    week: 8,
    title: 'Week 8',
    dayRange: 'Days 50–56',
    babySize: 'Kidney bean · 16 mm',
    babySizeEmoji: '🫘',
    babyFacts: [
      'All major organs now forming simultaneously',
      'Fingers and toes still webbed',
      'Tail completely disappears this week',
      'Heart has four chambers',
    ],
    momFacts: [
      'Uterus is now the size of an orange',
      'Heartburn and indigestion may begin',
      'Mood swings continue from hormonal surges',
    ],
    tip:
        'Avoid raw/undercooked meat, raw shellfish, unpasteurised cheese, pâté and deli meats to prevent listeria and toxoplasmosis.',
  ),

  _Entry(
    type: _EntryType.week,
    week: 9,
    title: 'Week 9',
    dayRange: 'Days 57–63',
    babySize: 'Grape · 23 mm',
    babySizeEmoji: '🍇',
    babyFacts: [
      'Now officially called a fetus (not embryo)',
      'Fingers and toes are separated',
      'Eyes fully formed but fused shut until week 26',
      'Baby can make tiny spontaneous movements',
    ],
    momFacts: [
      'Frequent urination at its peak',
      'Round ligament pain may start — sharp twinges on sides',
      'Constipation very common — increase water and fibre',
    ],
    tip:
        'Start Kegel (pelvic floor) exercises now. Do 3 sets of 10 x 5-second contractions daily. Prevents incontinence and speeds postnatal recovery.',
  ),

  _Entry(
    type: _EntryType.week,
    week: 10,
    title: 'Week 10',
    dayRange: 'Days 64–70 · End of embryonic period',
    babySize: 'Strawberry · 31 mm',
    babySizeEmoji: '🍓',
    babyFacts: [
      'Critical organ formation is now complete',
      'Fingernails and toenails beginning to form',
      'External genitalia developing (not yet visible on scan)',
      'Baby can hiccup — diaphragm is practising',
    ],
    momFacts: [
      'Miscarriage risk drops significantly after week 10',
      'Nausea beginning to ease for many women',
      'Visible bump for slim women',
    ],
    tip:
        'After week 10, miscarriage risk drops to under 1%. Many parents choose this time to share their news.',
  ),

  _Entry(
    type: _EntryType.appointment,
    title: '🔬 NIPT or CVS (Optional)',
    dayRange: 'Week 10–13 if chosen',
    apptDescription:
        'Non-Invasive Prenatal Test (NIPT) screens for Down syndrome (T21), Edwards (T18) and Patau (T13) syndromes from a simple blood sample. CVS (chorionic villus sampling) is more invasive but gives a definitive diagnosis. Discuss with your midwife whether you want screening.',
    apptWhen: 'Week 10–13',
    apptWhere: 'Specialist fetal medicine unit',
    apptDuration: '30–60 minutes',
  ),

  _Entry(
    type: _EntryType.week,
    week: 11,
    title: 'Week 11',
    dayRange: 'Days 71–77',
    babySize: 'Fig · 41 mm',
    babySizeEmoji: '🟣',
    babyFacts: [
      'Baby almost doubles in size this week',
      'Tooth buds forming in jawbone',
      'Diaphragm forming — hiccups possible',
      'Hands can open and close reflexively',
    ],
    momFacts: [
      'Energy may start returning',
      'Food aversions still common',
      'Skin and hair changes may appear',
    ],
  ),

  _Entry(
    type: _EntryType.week,
    week: 12,
    title: 'Week 12',
    dayRange: 'Days 78–84 · End of 1st trimester 🎉',
    babySize: 'Plum · 53 mm · ~14 grams',
    babySizeEmoji: '🍑',
    babyFacts: [
      'All organs, muscles, and limbs are in place',
      'Baby can suck thumb and swallow',
      'Reflexes are developing rapidly',
      'Intestines move from umbilical cord into belly',
    ],
    momFacts: [
      'Nausea usually eases after week 12',
      'Energy returns for most women',
      'Uterus rises above the pubic bone',
      'Waistline noticeably changed',
    ],
    tip:
        '🎉 End of first trimester! Miscarriage risk is now very low. Safe to share your news if you wish.',
  ),

  _Entry(
    type: _EntryType.appointment,
    title: '📷 12-Week Dating Scan',
    dayRange: 'Week 11–14 (book now)',
    apptDescription:
        'First major ultrasound. Confirms your due date, checks for twins or multiples, measures nuchal translucency (NT fold) as part of Down syndrome screening, and checks all visible structures. You will hear the heartbeat and receive your first scan photo.',
    apptWhen: 'Week 11–14 (ideally at 12+3)',
    apptWhere: 'Maternity ultrasound unit',
    apptDuration: '30–45 minutes',
  ),

  // ── SECOND TRIMESTER ──────────────────────────────────────────────────────

  _Entry(
    type: _EntryType.week,
    week: 16,
    title: 'Week 16',
    dayRange: 'Days 106–112 · 2nd trimester energy peak',
    babySize: 'Avocado · 12 cm · 100 grams',
    babySizeEmoji: '🥑',
    babyFacts: [
      'Makes facial expressions — frowns and squints',
      'Eyes move side-to-side beneath fused lids',
      'Unique fingerprints now fully formed',
      'Ears positioned correctly, can detect sound',
    ],
    momFacts: [
      'Bump clearly visible to others now',
      'Energy typically at highest point in pregnancy',
      'Round ligament pain (sharp side pains) common',
      'Possible "pregnancy glow" — increased blood flow',
    ],
  ),

  _Entry(
    type: _EntryType.appointment,
    title: '🩸 Anomaly Scan + AFP Test',
    dayRange: 'Week 18–21 · Book ahead',
    apptDescription:
        'Most detailed ultrasound in pregnancy. Checks every organ — heart chambers, brain, kidneys, spine, lips, limbs and placenta position. The AFP (alpha-fetoprotein) blood test screens for neural tube defects. Baby\'s sex may be visible if desired.',
    apptWhen: 'Week 18–21 (book at 16-week appointment)',
    apptWhere: 'Maternity ultrasound unit',
    apptDuration: '45–60 minutes',
  ),

  _Entry(
    type: _EntryType.week,
    week: 20,
    title: 'Week 20',
    dayRange: 'Days 134–140 · Halfway point 🎯',
    babySize: 'Banana · 25 cm · 300 grams',
    babySizeEmoji: '🍌',
    babyFacts: [
      '🎯 You are exactly halfway to your due date',
      'Vernix (white waxy coating) covers skin',
      'Swallows amniotic fluid and makes urine',
      'Distinct sleep and wake cycles beginning',
      'Kicks clearly felt from outside belly',
    ],
    momFacts: [
      'Kicks clearly felt — enjoy this milestone',
      'Belly button may pop out',
      'Backache begins as posture shifts',
      'Possible leg cramps at night — stretch before bed',
    ],
    tip:
        'From week 20, start sleeping on your left side. This improves blood flow through the inferior vena cava to the placenta.',
  ),

  _Entry(
    type: _EntryType.vaccine,
    title: '💉 Influenza (Flu) Vaccine',
    dayRange: 'Week 20+ · Strongly recommended',
    apptDescription:
        'Flu in pregnancy can cause severe illness and trigger premature labour. The vaccine is safe at any stage of pregnancy and passes antibodies to your baby, protecting them for the first months of life before they can be vaccinated.',
    apptWhen: 'After week 20, before flu season (Oct–Nov)',
    apptWhere: 'GP surgery or pharmacy',
    apptDuration: '10–15 minutes',
  ),

  _Entry(
    type: _EntryType.week,
    week: 24,
    title: 'Week 24',
    dayRange: 'Days 162–168 · Viability milestone ⚠️',
    babySize: 'Corn on the cob · 30 cm · 600 g',
    babySizeEmoji: '🌽',
    babyFacts: [
      '⚠️ Legal viability: survival possible with NICU care',
      'Lungs developing surfactant (essential for breathing)',
      'Brain growing most rapidly of any stage',
      'Responds clearly to your voice',
    ],
    momFacts: [
      'Braxton Hicks "practice" contractions may begin',
      'Heartburn often worsens as uterus pushes up',
      'Stretch marks (striae) may appear — belly, hips, breasts',
      'Linea nigra (dark midline) appears on abdomen',
    ],
    tip:
        'At 24 weeks, premature babies can survive with intensive neonatal care. Know the signs of preterm labour: regular contractions before 37 weeks, back pain, pelvic pressure.',
  ),

  _Entry(
    type: _EntryType.appointment,
    title: '🩺 Glucose Tolerance Test (OGTT)',
    dayRange: 'Week 24–28 · Gestational diabetes',
    apptDescription:
        'Oral Glucose Tolerance Test screens for gestational diabetes mellitus (GDM). You fast overnight, drink a glucose solution, and blood is drawn at 1 hour and 2 hours. Results in 1–2 days. GDM is highly manageable with diet changes and monitoring.',
    apptWhen: 'Week 24–28',
    apptWhere: 'Clinic laboratory',
    apptDuration: '2 hours (fasting required)',
  ),

  _Entry(
    type: _EntryType.week,
    week: 28,
    title: 'Week 28',
    dayRange: 'Days 190–196 · Third trimester begins',
    babySize: 'Aubergine · 37 cm · 1.0 kg',
    babySizeEmoji: '🍆',
    babyFacts: [
      'Eyes now open — baby can see light through your skin',
      'Lungs could support breathing if born now',
      'Fat accumulating rapidly under skin',
      'Hiccups felt regularly — normal and harmless',
    ],
    momFacts: [
      'Shortness of breath as uterus pushes up on diaphragm',
      'Frequent urination returns as baby drops lower',
      'Insomnia becomes very common — use a pregnancy pillow',
      'Pelvic pressure increases',
    ],
    tip:
        'From 28 weeks: count kicks daily. 10 kicks in 2 hours is the guideline. Contact your midwife immediately if you notice a significant reduction.',
  ),

  _Entry(
    type: _EntryType.vaccine,
    title: '💉 Tdap — Whooping Cough Vaccine',
    dayRange: 'Week 27–36 · Every pregnancy',
    apptDescription:
        'Tetanus, diphtheria and pertussis (whooping cough) vaccine. Critically important: your newborn cannot receive this vaccine until 8 weeks old. Antibodies you develop cross the placenta and protect your baby from potentially fatal whooping cough in early life. Recommended at every pregnancy.',
    apptWhen: 'Week 27–36 (ideally 28–32 for maximum antibody transfer)',
    apptWhere: 'GP surgery or maternity clinic',
    apptDuration: '15 minutes',
  ),

  _Entry(
    type: _EntryType.week,
    week: 32,
    title: 'Week 32',
    dayRange: 'Days 218–224',
    babySize: 'Squash · 43 cm · 1.7 kg',
    babySizeEmoji: '🎃',
    babyFacts: [
      'Toenails fully formed',
      'Practising breathing movements with amniotic fluid',
      'Most babies settling head-down by now',
      'Gaining approximately 200 grams per week',
    ],
    momFacts: [
      'Braxton Hicks more frequent and stronger',
      'Waddling gait as pelvis widens',
      'Sleep very difficult — try left-side sleeping with pillow',
      'Carpal tunnel syndrome in some women',
    ],
    tip:
        'Start your birth plan now. Pack your hospital bag by week 36. Include: ID, maternity notes, baby clothes, feeding supplies, toiletries, phone charger.',
  ),

  _Entry(
    type: _EntryType.appointment,
    title: '📷 Growth & Wellbeing Scan',
    dayRange: 'Week 32–34 · Check growth',
    apptDescription:
        'Checks baby\'s growth trajectory, estimated weight, amniotic fluid levels, placenta position and function, and confirms head-down position. Particularly important if any risk factors present (small for dates, high blood pressure, reduced movements).',
    apptWhen: 'Week 32–34',
    apptWhere: 'Maternity ultrasound unit',
    apptDuration: '30–40 minutes',
  ),

  _Entry(
    type: _EntryType.week,
    week: 36,
    title: 'Week 36',
    dayRange: 'Days 246–252 · Nearly full term',
    babySize: 'Honeydew melon · 47 cm · 2.6 kg',
    babySizeEmoji: '🍈',
    babyFacts: [
      '"Early term" begins at 37 weeks',
      'Head may begin engaging in pelvis ("lightening")',
      'Lungs almost fully mature',
      'Gaining approximately 30 grams of fat per day',
    ],
    momFacts: [
      'Engagement — "lightening" — breathing becomes easier',
      'Pelvic pressure and heaviness increases',
      'Nesting instinct very strong',
      'Colostrum may leak from breasts',
    ],
    tip:
        '✅ Hospital bag should be packed and ready. Pre-register with your delivery hospital. Know your route and parking.',
  ),

  _Entry(
    type: _EntryType.appointment,
    title: '🩺 GBS Swab Test',
    dayRange: 'Week 35–37 · Group B Strep',
    apptDescription:
        'Swab of vagina and rectum tests for Group B Streptococcus (GBS) bacteria. If positive, IV antibiotics during labour protect your baby from GBS infection, which can cause meningitis and sepsis in newborns. Simple, painless, and essential.',
    apptWhen: 'Week 35–37',
    apptWhere: 'Maternity clinic or GP',
    apptDuration: '10–15 minutes',
  ),

  _Entry(
    type: _EntryType.week,
    week: 38,
    title: 'Week 38',
    dayRange: 'Days 260–266 · Early term',
    babySize: 'Small pumpkin · 49 cm · 3.0 kg',
    babySizeEmoji: '🎃',
    babyFacts: [
      'All organ systems fully developed',
      'Brain continues rapid development (continues after birth)',
      'Immune antibodies transferred from you to baby',
      'Baby could arrive any time now',
    ],
    momFacts: [
      'Cervix beginning to ripen and efface',
      'Braxton Hicks intensifying',
      'Mucus plug may pass (bloody show)',
      'Anxiety and excitement building',
    ],
    tip:
        'Know the signs of labour: regular contractions getting closer (5-1-1 rule: 5 min apart, 1 min long, for 1 hour), waters breaking, or bloody show.',
  ),

  _Entry(
    type: _EntryType.week,
    week: 40,
    title: 'Week 40',
    dayRange: 'Days 274–280 · Due date',
    babySize: 'Watermelon · 51 cm · ~3.4 kg',
    babySizeEmoji: '🍉',
    babyFacts: [
      '🎯 Due date: $_kDueDate',
      'Only 5% of babies are born on their due date',
      'Baby fully developed and ready for the world',
      'Skull bones remain soft and pliable for delivery',
      'All reflexes in place — sucking, grasping, rooting',
    ],
    momFacts: [
      'Induction typically offered at 41–42 weeks',
      'Gentle walking and activity can encourage labour',
      'Rest as much as possible — you will need energy for labour',
    ],
    tip:
        '🗓️ Anywhere from 38–42 weeks is normal. If you reach 41 weeks, your midwife will discuss induction options.',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

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
        title: Text('Pregnancy Timeline', style: AppTextStyles.heading3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.event_note_outlined,
                color: AppColors.textDark),
            onPressed: () => _showKeyDates(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Summary strip ──────────────────────────────────────────────
          _SummaryStrip(),
          const SizedBox(height: 6),
          // ── Legend ────────────────────────────────────────────────────
          const _Legend(),
          const SizedBox(height: 8),
          // ── List ──────────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, 4, AppSpacing.lg, 48),
              itemCount: _timelineEntries.length,
              itemBuilder: (ctx, i) => _TItem(
                entry: _timelineEntries[i],
                isLast: i == _timelineEntries.length - 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showKeyDates(BuildContext context) {
    final elapsed = (_kCurrentWeek - 1) * 7 + _kCurrentDay;
    final daysLeft = 280 - elapsed;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // handle
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: AppSpacing.md),
          Text('Your Key Dates', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.lg),
          _DateRow('Last Period (LMP)', _kLmpDate, '📅'),
          const Divider(),
          _DateRow('Estimated Due Date', _kDueDate, '🎯'),
          const Divider(),
          _DateRow(
              'Currently at', 'Week $_kCurrentWeek + $_kCurrentDay days', '📍'),
          const Divider(),
          _DateRow('Days remaining', '$daysLeft days to due date', '⏳'),
          const Divider(),
          _DateRow('1st Trimester ends', 'Week 12 · Nov 18, 2024', '1️⃣'),
          const Divider(),
          _DateRow('2nd Trimester ends', 'Week 27 · Feb 10, 2025', '2️⃣'),
          const Divider(),
          _DateRow('Full term (Week 39)', 'May 12, 2025', '✅'),
          const SizedBox(height: AppSpacing.lg),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary strip widget
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final elapsed = (_kCurrentWeek - 1) * 7 + _kCurrentDay;
    final daysLeft = 280 - elapsed;
    final String tri = _kCurrentWeek <= 12
        ? '1st'
        : _kCurrentWeek <= 27
            ? '2nd'
            : '3rd';
    final Color triColor = _kCurrentWeek <= 12
        ? const Color(0xFF5B8DEF)
        : _kCurrentWeek <= 27
            ? const Color(0xFF10B981)
            : AppColors.primary;

    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, 0),
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Pip('Week $_kCurrentWeek', '+$_kCurrentDay days', AppColors.primary),
          _Divider(),
          _Pip('$daysLeft days', 'to due date', Colors.orange),
          _Divider(),
          _Pip(tri, 'trimester', triColor),
          _Divider(),
          _Pip('May 26', 'due date', Colors.green),
        ],
      ),
    );
  }
}

class _Pip extends StatelessWidget {
  final String v, s;
  final Color c;
  const _Pip(this.v, this.s, this.c);
  @override
  Widget build(BuildContext context) => Column(children: [
        Text(v,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: c,
                fontFamily: 'Poppins')),
        Text(s, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
      ]);
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 26, color: AppColors.divider);
}

// ─────────────────────────────────────────────────────────────────────────────
// Legend
// ─────────────────────────────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  const _Legend();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(children: [
          _Dot(AppColors.primary, 'Week milestone'),
          const SizedBox(width: 14),
          _Dot(const Color(0xFF5B8DEF), 'Appointment'),
          const SizedBox(width: 14),
          _Dot(const Color(0xFF10B981), 'Vaccine / Test'),
        ]),
      );
}

class _Dot extends StatelessWidget {
  final Color c;
  final String l;
  const _Dot(this.c, this.l);
  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(shape: BoxShape.circle, color: c)),
        const SizedBox(width: 5),
        Text(l,
            style: AppTextStyles.bodySmall
                .copyWith(color: AppColors.textMedium, fontSize: 11)),
      ]);
}

// ─────────────────────────────────────────────────────────────────────────────
// Timeline item
// ─────────────────────────────────────────────────────────────────────────────

class _TItem extends StatefulWidget {
  final _Entry entry;
  final bool isLast;
  const _TItem({required this.entry, required this.isLast});
  @override
  State<_TItem> createState() => _TItemState();
}

class _TItemState extends State<_TItem> {
  bool _open = false;
  bool _booked = false;

  bool get _isPast =>
      widget.entry.week != null && widget.entry.week! < _kCurrentWeek;

  Color get _dotColor {
    if (widget.entry.isCurrent) return AppColors.primary;
    switch (widget.entry.type) {
      case _EntryType.appointment:
        return const Color(0xFF5B8DEF);
      case _EntryType.vaccine:
        return const Color(0xFF10B981);
      case _EntryType.week:
        return _isPast ? AppColors.primaryLight : AppColors.primaryLight;
    }
  }

  // Accent color used on card border and title
  Color get _accentColor {
    if (widget.entry.isCurrent) return AppColors.primary;
    switch (widget.entry.type) {
      case _EntryType.appointment:
        return const Color(0xFF5B8DEF);
      case _EntryType.vaccine:
        return const Color(0xFF10B981);
      case _EntryType.week:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Rail ──────────────────────────────────────────────────────
          SizedBox(
            width: 26,
            child: Column(children: [
              Container(
                width: e.isCurrent ? 18 : 12,
                height: e.isCurrent ? 18 : 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _dotColor,
                  border: e.isCurrent
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                  boxShadow: e.isCurrent
                      ? [
                          BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.45),
                              blurRadius: 8,
                              spreadRadius: 1),
                        ]
                      : null,
                ),
                child: e.type == _EntryType.appointment
                    ? const Center(
                        child: Icon(Icons.calendar_today,
                            color: Colors.white, size: 6))
                    : e.type == _EntryType.vaccine
                        ? const Center(
                            child: Icon(Icons.vaccines,
                                color: Colors.white, size: 6))
                        : null,
              ),
              if (!widget.isLast)
                Expanded(
                    child: Container(
                  width: 2,
                  color: _isPast ? AppColors.primaryLight : AppColors.divider,
                )),
            ]),
          ),

          const SizedBox(width: 10),

          // ── Card ──────────────────────────────────────────────────────
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _open = !_open),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: e.isCurrent
                      ? AppColors.primary.withValues(alpha: 0.04)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: _open
                        ? _accentColor.withValues(alpha: 0.5)
                        : e.isCurrent
                            ? AppColors.primary.withValues(alpha: 0.3)
                            : AppColors.divider,
                    width: e.isCurrent ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ──────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 12, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(
                              child: Text(e.title,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: e.isCurrent
                                        ? AppColors.primary
                                        : e.type == _EntryType.appointment
                                            ? const Color(0xFF5B8DEF)
                                            : e.type == _EntryType.vaccine
                                                ? const Color(0xFF10B981)
                                                : _isPast
                                                    ? AppColors.textMedium
                                                    : AppColors.textDark,
                                  )),
                            ),
                            if (e.babySizeEmoji != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(e.babySizeEmoji!,
                                    style: const TextStyle(fontSize: 20)),
                              ),
                            Icon(
                                _open
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textLight,
                                size: 18),
                          ]),

                          const SizedBox(height: 3),

                          Row(children: [
                            Expanded(
                              child: Text(e.dayRange,
                                  style: AppTextStyles.bodySmall),
                            ),
                            if (_isPast) _PastBadge(),
                            if (e.isCurrent) _CurrentBadge(),
                          ]),

                          // Collapsed baby size preview
                          if (e.babySize != null && !_open) ...[
                            const SizedBox(height: 5),
                            Text('👶 ${e.babySize}',
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: AppColors.textMedium)),
                          ],

                          // Collapsed appointment preview
                          if ((e.type == _EntryType.appointment ||
                                  e.type == _EntryType.vaccine) &&
                              !_open &&
                              e.apptWhen != null) ...[
                            const SizedBox(height: 4),
                            Row(children: [
                              Icon(Icons.schedule,
                                  size: 11, color: AppColors.textLight),
                              const SizedBox(width: 4),
                              Text(e.apptWhen!,
                                  style: AppTextStyles.bodySmall
                                      .copyWith(fontSize: 11)),
                            ]),
                          ],
                        ],
                      ),
                    ),

                    // ── Expanded content ──────────────────────────────
                    if (_open)
                      _ExpandedBody(
                        entry: e,
                        booked: _booked,
                        onBookToggle: () => setState(() => _booked = !_booked),
                      ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Expanded body
// ─────────────────────────────────────────────────────────────────────────────

class _ExpandedBody extends StatelessWidget {
  final _Entry entry;
  final bool booked;
  final VoidCallback onBookToggle;
  const _ExpandedBody(
      {required this.entry, required this.booked, required this.onBookToggle});

  @override
  Widget build(BuildContext context) {
    final e = entry;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, color: AppColors.divider),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ── Week milestone ─────────────────────────────────────────
            if (e.type == _EntryType.week) ...[
              if (e.babySize != null) ...[
                _SectionTitle('👶 Baby this week'),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(children: [
                    Text(e.babySizeEmoji ?? '',
                        style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.babySize!,
                            style: AppTextStyles.labelText.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark)),
                        const SizedBox(height: 6),
                        ...?e.babyFacts?.map((f) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700)),
                                  Expanded(
                                      child: Text(f,
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                  color: AppColors.textMedium,
                                                  height: 1.45))),
                                ],
                              ),
                            )),
                      ],
                    )),
                  ]),
                ),
                const SizedBox(height: 12),
              ],
              if (e.momFacts != null) ...[
                _SectionTitle('🤰 Your body'),
                ...e.momFacts!.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ',
                                style: TextStyle(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w700)),
                            Expanded(
                                child: Text(f,
                                    style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textDark,
                                        height: 1.5))),
                          ]),
                    )),
                const SizedBox(height: 10),
              ],
              if (e.tip != null)
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEE),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border:
                        Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('💡 ', style: TextStyle(fontSize: 14)),
                      Expanded(
                          child: Text(e.tip!,
                              style: AppTextStyles.bodySmall.copyWith(
                                  color: const Color(0xFF7A5C00),
                                  height: 1.5))),
                    ],
                  ),
                ),
            ],

            // ── Appointment / Vaccine ──────────────────────────────────
            if (e.type == _EntryType.appointment ||
                e.type == _EntryType.vaccine) ...[
              if (e.apptDescription != null) ...[
                Text(e.apptDescription!,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textMedium, height: 1.6)),
                const SizedBox(height: 12),
              ],

              // Info rows
              if (e.apptWhen != null)
                _InfoRow(Icons.schedule, 'When', e.apptWhen!),
              if (e.apptWhere != null)
                _InfoRow(Icons.place_outlined, 'Where', e.apptWhere!),
              if (e.apptDuration != null)
                _InfoRow(Icons.timer_outlined, 'Duration', e.apptDuration!),

              const SizedBox(height: 14),

              // Action buttons
              if (e.type == _EntryType.appointment)
                Row(children: [
                  Expanded(
                      child: ElevatedButton.icon(
                    onPressed: onBookToggle,
                    icon: Icon(
                      booked ? Icons.check_circle : Icons.calendar_today,
                      size: 15,
                      color: Colors.white,
                    ),
                    label: Text(
                      booked ? 'Booked ✓' : 'Book Appointment',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          booked ? Colors.green : const Color(0xFF5B8DEF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full)),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  )),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('🔔 Appointment reminder set!'))),
                    icon: const Icon(Icons.notifications_outlined, size: 15),
                    label: const Text('Alert',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textDark,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 11, horizontal: 16),
                    ),
                  ),
                ])
              else
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('🔔 Vaccine reminder set!'))),
                    icon: const Icon(Icons.notifications_outlined, size: 15),
                    label: const Text('Set Vaccine Reminder',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF10B981),
                      side: const BorderSide(color: Color(0xFF10B981)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full)),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
            ],
          ]),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700, color: AppColors.textDark)),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow(this.icon, this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Row(children: [
          Icon(icon, size: 13, color: AppColors.textLight),
          const SizedBox(width: 6),
          Text('$label: ',
              style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                  fontSize: 12)),
          Expanded(
              child: Text(value,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textMedium, fontSize: 12))),
        ]),
      );
}

class _PastBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: const Text('✓ Passed',
            style: TextStyle(
                fontSize: 9,
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins')),
      );
}

class _CurrentBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text('You are here',
            style: TextStyle(
                fontSize: 9,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins')),
      );
}

class _DateRow extends StatelessWidget {
  final String label, value, icon;
  const _DateRow(this.label, this.value, this.icon);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
          Text(value,
              style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700, color: AppColors.primary)),
        ]),
      );
}
