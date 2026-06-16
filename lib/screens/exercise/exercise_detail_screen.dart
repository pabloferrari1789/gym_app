import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/week_provider.dart';
import '../../models/exercise.dart';
import '../../models/workout_day.dart';
import '../../widgets/rest_timer_sheet.dart';
import '../../data/exercise_videos.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  final int weekNumber;
  final int dayNumber;
  final int exerciseIndex;

  const ExerciseDetailScreen({
    super.key,
    required this.weekNumber,
    required this.dayNumber,
    required this.exerciseIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekAsync = ref.watch(workoutWeekProvider(weekNumber));

    return weekAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $e')),
      ),
      data: (week) {
        final day = week.days.firstWhere(
          (d) => d.dayNumber == dayNumber,
          orElse: () => WorkoutDay(dayNumber: dayNumber, exercises: []),
        );
        if (day.exercises.isEmpty ||
            exerciseIndex >= day.exercises.length) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Ejercicio no encontrado')),
          );
        }
        return _ExerciseDetail(
          exercise: day.exercises[exerciseIndex],
          exerciseIndex: exerciseIndex,
          totalExercises: day.exercises.length,
          weekNumber: weekNumber,
          dayNumber: dayNumber,
        );
      },
    );
  }
}

class _ExerciseDetail extends ConsumerWidget {
  final Exercise exercise;
  final int exerciseIndex;
  final int totalExercises;
  final int weekNumber;
  final int dayNumber;

  const _ExerciseDetail({
    required this.exercise,
    required this.exerciseIndex,
    required this.totalExercises,
    required this.weekNumber,
    required this.dayNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPrev = exerciseIndex > 0;
    final hasNext = exerciseIndex < totalExercises - 1;
    final asset = exerciseAsset(exercise.name);
    final videoUrl = youtubeUrl(exercise.name);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          exercise.name,
          style: const TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: hasPrev
                ? () => _navigate(context, exerciseIndex - 1)
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: hasNext
                ? () => _navigate(context, exerciseIndex + 1)
                : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Video thumbnail
            GestureDetector(
              onTap: videoUrl != null
                  ? () => launchUrl(Uri.parse(videoUrl),
                      mode: LaunchMode.externalApplication)
                  : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  asset != null
                      ? Image.asset(
                          asset,
                          height: 260,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        )
                      : _gifPlaceholder(),
                  if (videoUrl != null)
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow,
                          color: Colors.white, size: 40),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoChip(
                          icon: Icons.repeat,
                          label: '${exercise.sets} series'),
                      _InfoChip(
                          icon: Icons.close,
                          label: '${exercise.reps} reps'),
                      _InfoChip(
                          icon: Icons.fitness_center,
                          label: exercise.weight),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Nota del profe
                  if (exercise.notes.isNotEmpty) ...[
                    const Text(
                      'Nota del profe',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4361EE).withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF4361EE).withValues(alpha:0.3),
                        ),
                      ),
                      child: Text(
                        exercise.notes,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha:0.85),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Rest timer button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => _showRestTimer(context),
                      icon: const Icon(Icons.timer_outlined),
                      label: const Text('Iniciar descanso'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4361EE),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, int newIndex) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseDetailScreen(
          weekNumber: weekNumber,
          dayNumber: dayNumber,
          exerciseIndex: newIndex,
        ),
      ),
    );
  }

  void _showRestTimer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => const RestTimerSheet(),
    );
  }

  Widget _gifPlaceholder() {
    return Container(
      height: 260,
      color: const Color(0xFF1E1E2E),
      child: const Center(
        child: Icon(Icons.fitness_center, size: 64, color: Color(0xFF4361EE)),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF4361EE)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
