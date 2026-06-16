import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout_week.dart';
import '../services/sheets_service.dart';
import 'auth_provider.dart';

final selectedWeekProvider = StateProvider<int>((ref) => 1);

final sheetsServiceProvider = Provider<SheetsService>((ref) {
  return SheetsService(ref.watch(googleSignInProvider));
});

final workoutWeekProvider =
    FutureProvider.family<WorkoutWeek, int>((ref, weekNumber) async {
  final authState = ref.watch(authStateProvider);
  final account = authState.valueOrNull;
  if (account == null) throw Exception('Not authenticated');

  final service = ref.watch(sheetsServiceProvider);
  return service.getWeek(weekNumber, account);
});
