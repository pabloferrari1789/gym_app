import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  static const _tabs = [
    (path: '/home', icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Inicio'),
    (path: '/progress', icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: 'Progreso'),
    (path: '/profile', icon: Icons.person_outline, activeIcon: Icons.person, label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        backgroundColor: const Color(0xFF1E1E2E),
        indicatorColor: const Color(0xFF4361EE).withValues(alpha: 0.2),
        destinations: _tabs
            .map((t) => NavigationDestination(
                  icon: Icon(t.icon),
                  selectedIcon: Icon(t.activeIcon, color: const Color(0xFF4361EE)),
                  label: t.label,
                ))
            .toList(),
      ),
    );
  }
}
