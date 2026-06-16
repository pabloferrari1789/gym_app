import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/week_provider.dart';
import '../../providers/exercise_provider.dart';
import '../../models/exercise.dart';
import '../../models/workout_day.dart';

class DayScreen extends ConsumerWidget {
  final int weekNumber;
  final int dayNumber;

  const DayScreen({
    super.key,
    required this.weekNumber,
    required this.dayNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekAsync = ref.watch(workoutWeekProvider(weekNumber));

    return weekAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text('DÍA $dayNumber')),
        body: Center(child: Text('Error: $e')),
      ),
      data: (week) {
        final day = week.days.firstWhere(
          (d) => d.dayNumber == dayNumber,
          orElse: () => WorkoutDay(dayNumber: dayNumber, exercises: []),
        );
        return _DayView(
          day: day,
          weekNumber: weekNumber,
        );
      },
    );
  }
}

class _DayView extends StatelessWidget {
  final WorkoutDay day;
  final int weekNumber;

  const _DayView({required this.day, required this.weekNumber});

  @override
  Widget build(BuildContext context) {
    final completed = day.completedCount;
    final total = day.exercises.length;
    final progress = total > 0 ? completed / total : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('DÍA ${day.dayNumber}'),
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$completed / $total ejercicios',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha:0.6),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white12,
                  color: const Color(0xFF4361EE),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Exercise list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: day.exercises.length,
              itemBuilder: (context, index) {
                return _ExerciseListItem(
                  exercise: day.exercises[index],
                  onTap: () => context.push(
                    '/week/$weekNumber/day/${day.dayNumber}/exercise/$index',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseListItem extends ConsumerStatefulWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const _ExerciseListItem({required this.exercise, required this.onTap});

  @override
  ConsumerState<_ExerciseListItem> createState() => _ExerciseListItemState();
}

class _ExerciseListItemState extends ConsumerState<_ExerciseListItem> {
  @override
  Widget build(BuildContext context) {
    final gifAsync = ref.watch(exerciseGifProvider(widget.exercise.name));

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: gifAsync.maybeWhen(
                  data: (url) => url != null
                      ? CachedNetworkImage(
                          imageUrl: url,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => _placeholder(),
                          errorWidget: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                  orElse: () => _placeholder(),
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.exercise.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (widget.exercise.notes.isNotEmpty)
                          const Icon(Icons.notes,
                              size: 16, color: Color(0xFF4361EE)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.exercise.sets} × ${widget.exercise.reps}  ·  ${widget.exercise.weight}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha:0.55),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Checkbox
              Checkbox(
                value: widget.exercise.completed,
                activeColor: const Color(0xFF4361EE),
                onChanged: (_) {
                  setState(() {
                    widget.exercise.completed = !widget.exercise.completed;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 48,
      height: 48,
      color: const Color(0xFF2A2A3E),
      child: const Icon(Icons.fitness_center,
          size: 24, color: Color(0xFF4361EE)),
    );
  }
}
