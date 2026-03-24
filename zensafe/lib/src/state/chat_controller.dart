import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/env.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import '../services/supabase_service.dart';
import 'profile_controller.dart';

final _uuid = Uuid();

final geminiServiceProvider = Provider<GeminiService>(
  (ref) => GeminiService(Env.geminiApiKey),
);

final chatControllerProvider =
    StateNotifierProvider<ChatController, List<ChatMessage>>(
  (ref) => ChatController(ref),
);

class ChatController extends StateNotifier<List<ChatMessage>> {
  ChatController(this.ref) : super(const []);

  final Ref ref;
  bool _busy = false;

  Future<void> loadHistory() async {
    final history = await SupabaseService.fetchChatHistory();
    if (history.isNotEmpty) {
      state = history;
    }
  }

  // 👇 NEW: Clear Chat Method
  Future<void> clear() async {
    state = const [];

    // OPTIONAL: Later, if you want to clear Supabase also:
    // await SupabaseService.clearChatHistory();
  }

  Future<void> send(String text) async {
    if (_busy || text.trim().isEmpty) return;
    _busy = true;

    final now = DateTime.now();

    // Save user message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      sender: ChatSender.user,
      content: text.trim(),
      createdAt: now,
    );
    state = [...state, userMessage];
    await SupabaseService.logChat(userMessage);

    // Award XP
    await ref.read(profileControllerProvider.notifier).awardXp(
          delta: 2,
          reason: 'chat_activity',
        );

    // Get assistant reply
    final gemini = ref.read(geminiServiceProvider);
    final replyText = await gemini.sendMessage(text);

    final reply = ChatMessage(
      id: _uuid.v4(),
      sender: ChatSender.assistant,
      content: replyText,
      createdAt: DateTime.now(),
    );

    state = [...state, reply];
    await SupabaseService.logChat(reply);

    _busy = false;
  }
}
