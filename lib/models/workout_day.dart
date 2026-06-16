import 'exercise.dart';

class WorkoutDay {
  final int dayNumber;
  final List<Exercise> exercises;

  const WorkoutDay({
    required this.dayNumber,
    required this.exercises,
  });

  bool get isCompleted => exercises.every((e) => e.isFullyLogged);

  int get completedCount => exercises.where((e) => e.completed).length;
}
