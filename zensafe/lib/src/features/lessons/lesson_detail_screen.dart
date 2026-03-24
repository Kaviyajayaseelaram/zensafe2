import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/lessons_controller.dart';

class LessonDetailScreen extends ConsumerStatefulWidget {
  const LessonDetailScreen({super.key, required this.lessonId});
  final String lessonId;

  @override
  ConsumerState<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {
  int currentStep = 0;
  int? selectedOption;
  bool completed = false;

  @override
  Widget build(BuildContext context) {
    final lesson = ref
        .watch(lessonsProvider)
        .firstWhere((l) => l.id == widget.lessonId, orElse: () => ref.watch(lessonsProvider).first);
    final step = lesson.steps[currentStep];

    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(step.prompt, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...List.generate(step.options.length, (index) {
              final option = step.options[index];
              final selected = selectedOption == index;
              final isCorrect = step.correctIndex == index;
              Color? color;
              if (completed && selected) {
                color = isCorrect ? Colors.green : Colors.red;
              }
              return Card(
                color: color?.withOpacity(0.08),
                child: RadioListTile<int>(
                  value: index,
                  groupValue: selectedOption,
                  onChanged: completed ? null : (v) => setState(() => selectedOption = v),
                  title: Text(option),
                ),
              );
            }),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: completed
                        ? null
                        : () async {
                            if (selectedOption == null) return;
                            setState(() => completed = true);
                            if (selectedOption == step.correctIndex) {
                              await ref.read(lessonProgressProvider.notifier).markCompleted(lesson.id);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Lesson complete! +20 XP')),
                                );
                              }
                            }
                            if (mounted && currentStep < lesson.steps.length - 1) {
                              setState(() {
                                completed = false;
                                selectedOption = null;
                                currentStep += 1;
                              });
                            }
                          },
                    child: Text(completed ? 'Completed' : 'Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

