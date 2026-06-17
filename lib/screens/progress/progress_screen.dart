import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Progreso\nPróximamente',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white54, fontSize: 18),
        ),
      ),
    );
  }
}
