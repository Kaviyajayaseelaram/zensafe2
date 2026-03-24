import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/profile_controller.dart';
import '../../widgets/zensafe_logo.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider).value;
    final name = profile?.name.isNotEmpty == true ? profile!.name : 'Friend';
    final xp = profile?.xp ?? 0;
    final streak = profile?.streak ?? 0;
    final level = profile?.level ?? 1;
    final progress = (xp % 300) / 300;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, $name 👋'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(profileControllerProvider.notifier).loadProfile(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5AD0FF), Color(0xFF47B3FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const ZenSafeLogo(size: 86),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hi, $name!',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text('Level $level • $xp XP',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text('$streak day streak',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Level progress'),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(value: progress.clamp(0, 1)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Current XP: $xp'),
                        Text('Next at ${(xp ~/ 300 + 1) * 300}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Keep your streak', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    const Text('Daily target 20 XP. Do a lesson, chat, or add a contact.'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => context.go('/lessons'),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Continue Lesson'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.go('/chat'),
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text('Chat Assistant'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.health_and_safety_outlined, color: Colors.green),
                title: const Text('Safety Toolkit'),
                subtitle: const Text('SOS, breathing, journaling, contacts'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/tools'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.emoji_events_outlined, color: Colors.amber),
                title: const Text('Badges'),
                subtitle: Text(profile?.badges.join(' • ') ?? 'Earn badges as you progress'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

