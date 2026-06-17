import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../providers/auth_provider.dart';
import '../../providers/week_provider.dart';
import '../../models/workout_day.dart';
import '../../models/workout_week.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final account = authState.valueOrNull;
    final selectedWeek = ref.watch(selectedWeekProvider);
    final weekAsync = ref.watch(workoutWeekProvider(selectedWeek));

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WelcomeHeader(account: account),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _WeeklySummaryCard(week: weekAsync.valueOrNull),
          ),
          _WeekSelector(
            selectedWeek: selectedWeek,
            onSelect: (w) => ref.read(selectedWeekProvider.notifier).state = w,
          ),
          const SizedBox(height: 8),
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

class _WelcomeHeader extends StatelessWidget {
  final GoogleSignInAccount? account;
  const _WelcomeHeader({required this.account});

  @override
  Widget build(BuildContext context) {
    final firstName = account?.displayName?.split(' ').first ?? 'atleta';

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
        child: Row(
          children: [
            if (account?.photoUrl != null)
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(account!.photoUrl!),
              )
            else
              const CircleAvatar(
                radius: 24,
                child: Icon(Icons.person),
              ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola de nuevo,',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
                Text(
                  firstName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _WeeklySummaryCard extends StatelessWidget {
  final WorkoutWeek? week;

  const _WeeklySummaryCard({required this.week});

  @override
  Widget build(BuildContext context) {
    if (week == null) {
      return Container(
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }

    final completedDays = week!.days.where((d) => d.isCompleted).length;
    final totalDays = week!.days.length;
    final totalExercises = week!.days.fold(0, (sum, d) => sum + d.exercises.length);
    final progress = totalDays > 0 ? completedDays / totalDays : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4361EE), Color(0xFF3A56D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Resumen de la semana',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Icon(Icons.calendar_today, color: Colors.white.withValues(alpha: 0.7), size: 18),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _StatChip(label: '$completedDays/$totalDays días', icon: Icons.fitness_center),
              const SizedBox(width: 16),
              _StatChip(label: '$totalExercises ejercicios', icon: Icons.repeat),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _StatChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 14),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ],
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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF4361EE).withValues(alpha: 0.15),
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
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      preview,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
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
                    color: Colors.white.withValues(alpha: 0.4)),
            ],
          ),
        ),
      ),
    );
  }
}
