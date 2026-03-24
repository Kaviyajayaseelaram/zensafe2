class Lesson {
  final String id;
  final String title;
  final String category;
  final String description;
  final List<LessonStep> steps;

  const Lesson({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.steps,
  });
}

class LessonStep {
  final String prompt;
  final List<String> options;
  final int correctIndex;

  const LessonStep({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });
}

