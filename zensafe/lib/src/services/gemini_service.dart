// lib/src/services/gemini_service.dart
// Offline "fake AI" for now – no network calls, no quotas.

class GeminiService {
  GeminiService(this.apiKey);

  final String apiKey; // kept for future, unused for now

  Future<String> sendMessage(String message) async {
    final text = message.toLowerCase().trim();

    // Simulate a tiny delay so it feels like "thinking"
    await Future.delayed(const Duration(milliseconds: 400));

    // Very simple keyword-based logic
    if (text.contains('help') || text.contains('unsafe') || text.contains('scared')) {
      return '''
It sounds like you're feeling unsafe or uncomfortable. Here are a few things you can do right now:

1. Move to a public, well-lit place with people around.
2. Call or message a trusted contact and share your live location.
3. Keep your emergency contacts and local helpline numbers ready.
4. If you feel in immediate danger, contact your local emergency number.

In ZenSafe, you can also:
• Add/update your emergency contacts
• Use the SOS / quick-access safety tools
''';
    }

    if (text.contains('stress') || text.contains('anxiety') || text.contains('anxious') || text.contains('overwhelmed')) {
      return '''
You’re not alone. Feeling stressed or anxious is very common. Try this quick grounding exercise:

1. Inhale slowly through your nose for 4 seconds.
2. Hold your breath for 4 seconds.
3. Exhale slowly through your mouth for 6 seconds.
4. Repeat this 5 times.

Also helpful:
• Take a short break from screens
• Drink some water
• Write down what exactly is worrying you – one sentence

You can turn this into a daily habit using ZenSafe’s wellness tools 💜
''';
    }

    if (text.contains('routine') || text.contains('habit') || text.contains('daily')) {
      return '''
Here’s a simple daily safety + wellness routine you can try:

Morning:
• 2 minutes to review your day and main tasks
• Quick check that your phone is charged and data is ON
• Share your plan with a trusted person if you’re travelling

Afternoon:
• 2–3 minute breathing or stretch break
• Drink water and avoid skipping meals

Night:
• Reflect on 1 good thing that happened today
• Make sure your important contacts and addresses are saved in ZenSafe

You can log these habits in ZenSafe and earn XP & streaks 🌱
''';
    }

    if (text.contains('safety tip') || text.contains('tips') || text.contains('safe')) {
      return '''
Here are some general safety tips for everyday life:

• Keep your phone charged above 30% whenever you go out
• Share your live location with a trusted contact if you feel uneasy
• Avoid sharing personal details with strangers (online or offline)
• Save emergency numbers and nearby hospital contacts in ZenSafe
• Trust your instincts – if something feels off, move away from the situation

You can save your own custom safety notes inside ZenSafe too ✅
''';
    }

    // Default generic reply
    return '''
Thanks for your message! Right now the AI assistant is running in offline demo mode (no internet AI calls),
so I’ll give you general guidance instead:

• Stay aware of your surroundings
• Keep at least one trusted contact informed about your movements
• Take regular breaks, breathe slowly, and don’t ignore how you feel
• Use ZenSafe’s safety tools, XP system, and routines to build safer daily habits

You can ask things like:
• “Give me a safety tip”
• “I feel stressed”
• “Help me build a daily routine”
''';
  }
}
