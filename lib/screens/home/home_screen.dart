import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/week_provider.dart';
import '../../models/workout_day.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final account = authState.valueOrNull;
    final selectedWeek = ref.watch(selectedWeekProvider);
    final weekAsync = ref.watch(workoutWeekProvider(selectedWeek));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Rutina'),
        actions: [
          if (account?.photoUrl != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(account!.photoUrl!),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => ref.read(authStateProvider.notifier).signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Week selector
          _WeekSelector(
            selectedWeek: selectedWeek,
            onSelect: (w) => ref.read(selectedWeekProvider.notifier).state = w,
          ),
          const SizedBox(height: 8),
          // Week content
          Expanded(
            child: weekAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error al cargar la rutina'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(
                          workoutWeekProvider(selectedWeek)),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
              data: (week) => week.days.isEmpty
                  ? const Center(
                      child: Text('No hay rutina para esta semana'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: week.days.length,
                      itemBuilder: (context, index) {
                        return _DayCard(
                          day: week.days[index],
                          onTap: () => context.push(
                            '/week/$selectedWeek/day/${week.days[index].dayNumber}',
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekSelector extends StatelessWidget {
  final int selectedWeek;
  final ValueChanged<int> onSelect;

  const _WeekSelector({required this.selectedWeek, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(4, (i) {
            final week = i + 1;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text('SEMANA $week'),
                selected: selectedWeek == week,
                onSelected: (_) => onSelect(week),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final WorkoutDay day;
  final VoidCallback onTap;

  const _DayCard({required this.day, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final preview = day.exercises
        .take(3)
        .map((e) => e.name)
        .join(' · ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Day number circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF4361EE).withValues(alpha:0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${day.dayNumber}',
                    style: const TextStyle(
                      color: Color(0xFF4361EE),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'DÍA ${day.dayNumber}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${day.exercises.length} ejercicios',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha:0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      preview,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha:0.6),
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (day.isCompleted)
                const Icon(Icons.check_circle, color: Color(0xFF4CAF50))
              else
                Icon(Icons.chevron_right,
                    color: Colors.white.withValues(alpha:0.4)),
            ],
          ),
        ),
      ),
    );
  }
}
