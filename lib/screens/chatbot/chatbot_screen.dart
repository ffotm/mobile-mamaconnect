import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import '../../providers/subscription_provider.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      fromBot: true,
      text:
          'Hi mama, I am your Mamaconnect assistant. I can help with symptoms, nutrition, safe activity, and warning signs. Pick one topic below to begin.',
    ),
  ];

  List<String> _currentSuggestions = _rootSuggestions;

  static const List<String> _rootSuggestions = [
    'I have nausea and fatigue',
    'I have back pain',
    'What should I eat today?',
    'What warning signs need urgent care?',
    'How can I sleep better?',
    'Give me a safe daily routine',
  ];

  void _sendSuggestion(String suggestion) {
    final subscription = context.read<SubscriptionProvider>();
    if (!subscription.consumeFreeChat()) {
      setState(() {});
      return;
    }

    final response = _buildDetailedResponse(suggestion);

    setState(() {
      _messages.add(_ChatMessage(fromBot: false, text: suggestion));
      _messages.add(_ChatMessage(fromBot: true, text: response.text));
      _currentSuggestions = response.suggestions;
    });
  }

  _ChatResponse _buildDetailedResponse(String suggestion) {
    final key = suggestion.toLowerCase();

    if (key.contains('nausea') || key.contains('fatigue')) {
      return const _ChatResponse(
        text:
            'For nausea plus fatigue, the goal is steady fuel and hydration through the day.\n\n'
            '1) Eat every 2 to 3 hours: small portions such as toast, banana, yogurt, or oatmeal. An empty stomach often worsens nausea.\n'
            '2) Hydration strategy: take small frequent sips of water, ginger tea, or oral rehydration drinks instead of large amounts at once.\n'
            '3) Include iron and protein: lentils, eggs, fish, chicken, beans, and spinach can reduce fatigue linked to low iron intake.\n'
            '4) Rest plan: add two short rest blocks (20 to 30 minutes) and avoid standing too long without breaks.\n\n'
            'Call your midwife urgently if you cannot keep fluids down for more than 12 hours, feel faint repeatedly, or notice very dark urine.',
        suggestions: [
          'Create a one-day meal plan for nausea',
          'Give hydration tips for morning sickness',
          'What medicines are usually considered safe?',
          'Back to main topics',
        ],
      );
    }

    if (key.contains('back pain')) {
      return const _ChatResponse(
        text:
            'Pregnancy back pain is common, especially as your center of gravity changes. A structured routine usually helps.\n\n'
            '1) Posture reset every 60 minutes: shoulders relaxed, chin neutral, avoid locking knees.\n'
            '2) Safe exercises: pelvic tilts, cat-cow, seated marching, and wall push-ups for 10 to 15 minutes daily.\n'
            '3) Sleep support: lie on your side with a pillow between knees and one supporting your abdomen.\n'
            '4) Heat and load management: use warm compress for 10 to 15 minutes and avoid lifting heavy bags.\n\n'
            'Seek urgent care for severe one-sided pain, fever, numbness, weakness, or pain with vaginal bleeding.',
        suggestions: [
          'Give me a 10-minute back pain routine',
          'How should I sleep to reduce pain?',
          'When is back pain dangerous?',
          'Back to main topics',
        ],
      );
    }

    if (key.contains('eat')) {
      return const _ChatResponse(
        text:
            'A balanced pregnancy plate supports both maternal energy and fetal growth. Aim for a simple structure each meal.\n\n'
            '1) Protein: eggs, chicken, fish low in mercury, lentils, beans, or yogurt.\n'
            '2) Fiber and vitamins: vegetables at lunch and dinner, plus 2 fruit portions daily.\n'
            '3) Slow carbs: oats, brown rice, potatoes, or whole-grain bread to keep energy stable.\n'
            '4) Healthy fats: olive oil, nuts, seeds, avocado.\n'
            '5) Iron + vitamin C pairing: for example lentils with tomatoes or spinach with citrus to improve iron absorption.\n\n'
            'If you want, I can suggest a full day menu adapted to nausea, constipation, or heartburn.',
        suggestions: [
          'Build a full day meal menu',
          'Foods for constipation',
          'Foods for heartburn',
          'Back to main topics',
        ],
      );
    }

    if (key.contains('warning signs') || key.contains('urgent care')) {
      return const _ChatResponse(
        text:
            'Please treat the following as urgent and contact emergency services or your maternity unit immediately:\n\n'
            '- Vaginal bleeding, fluid leakage, or painful regular contractions.\n'
            '- Severe headache with vision changes or sudden swelling of face/hands.\n'
            '- Chest pain, shortness of breath at rest, or fainting.\n'
            '- Fever with persistent abdominal pain.\n'
            '- Significant decrease in baby movements after the stage where movements are expected.\n\n'
            'For non-urgent symptoms, track patterns (time, severity, triggers) and share them with your midwife in your next review.',
        suggestions: [
          'How to monitor baby movements',
          'What to track before calling my midwife',
          'I have headache and dizziness now',
          'Back to main topics',
        ],
      );
    }

    if (key.contains('sleep')) {
      return const _ChatResponse(
        text:
            'For better sleep in pregnancy, combine body comfort, timing, and a wind-down routine.\n\n'
            '1) Sleep position: left side if comfortable, with pillows under belly and between knees.\n'
            '2) Evening routine: dim lights 60 minutes before bed, gentle stretching, warm shower, no heavy meals right before sleep.\n'
            '3) Caffeine timing: stop caffeine by early afternoon.\n'
            '4) Night waking: if awake more than 20 minutes, sit up, breathe slowly, then return to bed when drowsy.\n\n'
            'If insomnia is persistent with anxiety or low mood, speak with your provider for tailored support.',
        suggestions: [
          'Give me a bedtime stretch plan',
          'Breathing exercise for sleep',
          'Food and drinks that help sleep',
          'Back to main topics',
        ],
      );
    }

    if (key.contains('daily routine')) {
      return const _ChatResponse(
        text:
            'Here is a gentle pregnancy daily routine you can adapt:\n\n'
            '- Morning: hydration + protein breakfast, then 10 to 15 minutes light walk.\n'
            '- Midday: balanced lunch, short rest, and 5 minutes posture reset.\n'
            '- Afternoon: snack with fruit/protein, light mobility or stretching.\n'
            '- Evening: early dinner, calm activity, warm shower, side-sleep setup.\n\n'
            'Keep intensity low to moderate, avoid overheating, and stop activity immediately if you feel pain, dizziness, or contractions.',
        suggestions: [
          'Make this routine for 1st trimester',
          'Make this routine for 3rd trimester',
          'Add safe exercises only',
          'Back to main topics',
        ],
      );
    }

    if (key.contains('back to main topics')) {
      return const _ChatResponse(
        text:
            'Sure. Pick another topic and I will give step-by-step guidance tailored to pregnancy-safe care.',
        suggestions: _rootSuggestions,
      );
    }

    return const _ChatResponse(
      text:
          'I can still help with that. To keep advice useful and safe, choose one of the topics below and I will provide detailed steps.',
      suggestions: _rootSuggestions,
    );
  }

  @override
  Widget build(BuildContext context) {
    final subscription = context.watch<SubscriptionProvider>();
    final locked = subscription.isChatLocked;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('AI Chatbot', style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border:
                    Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Text(
                subscription.isPremium
                    ? 'Premium active: unlimited AI chats unlocked.'
                    : 'Free plan: ${subscription.freeChatsLeft} of ${SubscriptionProvider.freeChatLimit} chats remaining.',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.fromBot
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.82,
                    ),
                    decoration: BoxDecoration(
                      color: message.fromBot
                          ? Colors.white
                          : AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: message.fromBot
                            ? AppColors.divider
                            : AppColors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      message.text,
                      style: AppTextStyles.bodySmall
                          .copyWith(height: 1.5, color: AppColors.textDark),
                    ),
                  ),
                );
              },
            ),
          ),
          if (locked)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.lock, color: AppColors.primary, size: 26),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Free chat limit reached', style: AppTextStyles.heading3),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Upgrade to Premium to continue unlimited AI conversations and personalised guidance.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textMedium, height: 1.4),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.shop),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                        ),
                        child: const Text('Get Premium', style: AppTextStyles.buttonText),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _currentSuggestions
                    .map(
                      (suggestion) => InkWell(
                        onTap: () => _sendSuggestion(suggestion),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            suggestion,
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.primary),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final bool fromBot;
  final String text;

  const _ChatMessage({required this.fromBot, required this.text});
}

class _ChatResponse {
  final String text;
  final List<String> suggestions;

  const _ChatResponse({required this.text, required this.suggestions});
}
