import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/lessons_controller.dart';

class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessons = ref.watch(lessonsProvider);
    final completed = ref.watch(lessonProgressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Lessons & Activities')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Creative Corner', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _ActivityCard(
            title: 'DoodleLand',
            subtitle: 'See a fun prompt, draw, and upload to earn rewards.',
            icon: Icons.brush_outlined,
            onTap: () => context.go('/lessons/doodle'),
          ),
          _ActivityCard(
            title: 'Word Scramble',
            subtitle: 'Unscramble kid-friendly words by category.',
            icon: Icons.text_fields,
            onTap: () => context.go('/lessons/scramble'),
          ),
          _ActivityCard(
            title: 'Time Wizz',
            subtitle: 'A simple to-do list to plan your day.',
            icon: Icons.schedule,
            onTap: () => context.go('/lessons/timewizz'),
          ),
          const SizedBox(height: 16),
          Text('Quizzes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...List.generate(lessons.length, (index) {
            final lesson = lessons[index];
            final isDone = completed.contains(lesson.id);
            return Card(
              child: ListTile(
                leading: Icon(
                  isDone ? Icons.check_circle : Icons.play_circle_outline,
                  color: isDone ? Colors.green : Theme.of(context).colorScheme.primary,
                ),
                title: Text(lesson.title),
                subtitle: Text('${lesson.category} • ${lesson.description}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/lessons/detail/${lesson.id}'),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.lightBlue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}


