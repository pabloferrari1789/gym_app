import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/week_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(authStateProvider).valueOrNull;
    final selectedWeek = ref.watch(selectedWeekProvider);
    final weekAsync = ref.watch(workoutWeekProvider(selectedWeek));
    final week = weekAsync.valueOrNull;

    final completedDays = week?.days.where((d) => d.isCompleted).length ?? 0;
    final totalExercises =
        week?.days.fold(0, (sum, d) => sum + d.exercises.length) ?? 0;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 24),
            // Header
            Center(
              child: Column(
                children: [
                  if (account?.photoUrl != null)
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(account!.photoUrl!),
                    )
                  else
                    const CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 40),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    account?.displayName ?? 'Usuario',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    account?.email ?? '',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Stats
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    value: '$completedDays',
                    label: 'Días completados',
                    icon: Icons.fitness_center,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    value: '$totalExercises',
                    label: 'Ejercicios en la semana',
                    icon: Icons.repeat,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            // Settings
            Text(
              'AJUSTES',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const _SettingsGroup(items: [
              _SettingsItem(icon: Icons.person_outline, label: 'Mis datos'),
            ]),
            const SizedBox(height: 28),
            // Logout
            _LogoutButton(
              onTap: () => ref.read(authStateProvider.notifier).signOut(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatCard(
      {required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF4361EE), size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String label;

  const _SettingsItem({required this.icon, required this.label});
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;

  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Icon(item.icon,
                    color: Colors.white.withValues(alpha: 0.7), size: 20),
                title: Text(
                  item.label,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                trailing: Icon(Icons.chevron_right,
                    color: Colors.white.withValues(alpha: 0.3), size: 20),
                onTap: () {},
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              ),
              if (i < items.length - 1)
                Divider(
                  height: 1,
                  indent: 52,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
        title: const Text(
          'Cerrar sesión',
          style: TextStyle(color: Colors.redAccent, fontSize: 15),
        ),
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
    );
  }
}
