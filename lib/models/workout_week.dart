import 'workout_day.dart';

class WorkoutWeek {
  final int weekNumber;
  final List<WorkoutDay> days;

  const WorkoutWeek({
    required this.weekNumber,
    required this.days,
  });
}
