import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';
import '../services/gamification_service.dart';
import '../services/supabase_service.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<UserProfile?>>(
  (ref) => ProfileController(),
);

class ProfileController extends StateNotifier<AsyncValue<UserProfile?>> {
  ProfileController() : super(const AsyncValue.data(null));

  Future<void> signInAndCreate({required String name, required int age}) async {
    state = const AsyncValue.loading();
    try {
      final auth = await SupabaseService.signInAnon();
      final user = auth?.user;
      final userId = user?.id ?? 'local-user';
      final base = UserProfile(
        id: userId,
        name: name,
        age: age,
        dateJoined: DateTime.now(),
        xp: 5, // daily login bonus
        streak: 1,
      );
      final saved = await SupabaseService.upsertProfile(base);
      await SupabaseService.addXpEvent(
        userId: userId,
        delta: 5,
        reason: 'daily_login',
      );
      state = AsyncValue.data(saved ?? base);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadProfile() async {
    try {
      final session = SupabaseService.isReady
          ? Supabase.instance.client.auth.currentSession
          : null;
      final userId = session?.user.id;
      if (userId == null) return;
      final profile = await SupabaseService.fetchProfile(userId);
      state = AsyncValue.data(profile ?? state.value);
    } catch (_) {
      // keep existing state
    }
  }

  Future<void> updateProfile({
    required String name,
    required int age,
  }) async {
    final current = state.value;
    if (current == null) return;
    final updated = current.copyWith(name: name, age: age);
    state = AsyncValue.data(updated);
    await SupabaseService.upsertProfile(updated);
  }

  Future<void> awardXp({
    required int delta,
    required String reason,
    bool completedSafetyLesson = false,
    bool completedWellness = false,
  }) async {
    final current = state.value;
    if (current == null) return;
    final updated = GamificationService.applyXp(
      profile: current,
      delta: delta,
      completedSafetyLesson: completedSafetyLesson,
      completedWellness: completedWellness,
    );
    state = AsyncValue.data(updated);
    await SupabaseService.addXpEvent(
      userId: current.id,
      delta: delta,
      reason: reason,
    );
    await SupabaseService.upsertProfile(updated);
  }
}

