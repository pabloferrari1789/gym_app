import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/exercise_service.dart';

final exerciseServiceProvider = Provider<ExerciseService>((ref) {
  return ExerciseService();
});

final exerciseGifProvider =
    FutureProvider.family<String?, String>((ref, exerciseName) async {
  final service = ref.watch(exerciseServiceProvider);
  return service.getGifUrl(exerciseName);
});
