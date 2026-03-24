import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_message.dart';
import '../models/user_profile.dart';

class SupabaseService {
  SupabaseService._();

  static SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  static bool get isReady => _client != null;

  static Future<AuthResponse?> signInAnon() async {
    final client = _client;
    if (client == null) return null;
    return client.auth.signInAnonymously();
  }

  static Future<UserProfile?> fetchProfile(String userId) async {
    final client = _client;
    if (client == null) return null;
    final res = await client.from('profiles').select().eq('id', userId).maybeSingle();
    if (res == null) return null;
    return UserProfile.fromMap(res);
  }

  static Future<UserProfile?> upsertProfile(UserProfile profile) async {
    final client = _client;
    if (client == null) return profile;
    final res = await client.from('profiles').upsert(profile.toMap()).select().maybeSingle();
    if (res == null) return profile;
    return UserProfile.fromMap(res);
  }

  static Future<void> addXpEvent({
    required String userId,
    required int delta,
    required String reason,
  }) async {
    final client = _client;
    if (client == null) return;
    await client.from('xp_tracker').insert({
      'user_id': userId,
      'delta': delta,
      'reason': reason,
    });
  }

  static Future<void> updateProgress({
    required String userId,
    required String lessonId,
    required int xpEarned,
  }) async {
    final client = _client;
    if (client == null) return;
    await client.from('user_progress').upsert({
      'user_id': userId,
      'lesson_id': lessonId,
      'xp_earned': xpEarned,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> logChat(ChatMessage message) async {
    final client = _client;
    if (client == null) return;
    await client.from('chat_history').insert({
      'sender': describeEnum(message.sender),
      'message': message.content,
      'created_at': message.createdAt.toIso8601String(),
    });
  }

  static Future<List<ChatMessage>> fetchChatHistory() async {
    final client = _client;
    if (client == null) return [];
    final rows = await client.from('chat_history').select().order('created_at');
    return rows.map<ChatMessage>((row) {
      final senderStr = (row['sender'] ?? 'assistant') as String;
      return ChatMessage(
        id: (row['id'] ?? '').toString(),
        sender: senderStr == 'user' ? ChatSender.user : ChatSender.assistant,
        content: (row['message'] ?? '') as String,
        createdAt: DateTime.tryParse(row['created_at'] as String? ?? '') ?? DateTime.now(),
      );
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> fetchEmergencyContacts(String userId) async {
    final client = _client;
    if (client == null) return [];
    final rows = await client.from('emergency_contacts').select().eq('user_id', userId);
    return List<Map<String, dynamic>>.from(rows);
  }

  static Future<void> addEmergencyContact({
    required String userId,
    required String name,
    required String phone,
  }) async {
    final client = _client;
    if (client == null) return;
    await client.from('emergency_contacts').insert({
      'user_id': userId,
      'name': name,
      'phone': phone,
    });
  }
}

