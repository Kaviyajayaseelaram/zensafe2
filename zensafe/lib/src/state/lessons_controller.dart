import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/lesson.dart';
import '../state/profile_controller.dart';

final lessonsProvider = Provider<List<Lesson>>((ref) {
  return const [
    Lesson(
      id: 'safety_basics_1',
      title: 'Safety Basics',
      category: 'Safety Basics',
      description: 'Learn core personal safety tips and awareness skills.',
      steps: [
        LessonStep(
          prompt: 'If you feel unsafe, what is the first step?',
          options: ['Stay silent', 'Trust your instincts and move to safety', 'Ignore it'],
          correctIndex: 1,
        ),
        LessonStep(
          prompt: 'What should you share with a trusted contact?',
          options: ['Your outfit', 'Your location and ETA', 'Your playlist'],
          correctIndex: 1,
        ),
      ],
    ),
    Lesson(
      id: 'wellness_1',
      title: 'Quick Calm',
      category: 'Stress Relief',
      description: 'Practice breathing to reset your nervous system.',
      steps: [
        LessonStep(
          prompt: 'How long should an exhale be for calming?',
          options: ['Shorter than inhale', 'Equal to inhale', 'Longer than inhale'],
          correctIndex: 2,
        ),
      ],
    ),
  ];
});

final lessonProgressProvider =
    StateNotifierProvider<LessonProgressController, Set<String>>(
  (ref) => LessonProgressController(ref),
);

class LessonProgressController extends StateNotifier<Set<String>> {
  LessonProgressController(this.ref) : super(<String>{});

  final Ref ref;

  Future<void> markCompleted(String lessonId) async {
    if (state.contains(lessonId)) return;
    state = {...state, lessonId};
    final profile = ref.read(profileControllerProvider).value;
    if (profile != null) {
      await ref.read(profileControllerProvider.notifier).awardXp(
            delta: 20,
            reason: 'lesson_complete',
            completedSafetyLesson: lessonId.contains('safety'),
            completedWellness: lessonId.contains('wellness'),
          );
    }
  }
}

