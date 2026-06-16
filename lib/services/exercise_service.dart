import 'package:dio/dio.dart';

class ExerciseService {
  static const _baseUrl = 'https://exercisedb.p.rapidapi.com';
  static const _apiKey = 'ce8bc432f9msh63c438893e8a5b7p15c9bdjsn223c15ecfe53';

  static const _nameMap = {
    'sentadillas': 'squat',
    'prensa': 'leg press',
    'press plano con barra': 'barbell bench press',
    'remo en máquina': 'seated cable row',
    'press militar sentado': 'seated dumbbell shoulder press',
    'bíceps con barra de pie': 'barbell curl',
    'biceps con barra de pie': 'barbell curl',
    'sentadilla búlgara': 'bulgarian split squat',
    'sentadilla bulgara': 'bulgarian split squat',
    'peso muerto': 'deadlift',
    'sillón de cuádriceps': 'leg extension',
    'sillon de cuadriceps': 'leg extension',
    'jalón al pecho': 'lat pulldown',
    'jalon al pecho': 'lat pulldown',
    'press de pecho inclinado con mancuernas': 'incline dumbbell press',
    'vuelos laterales': 'lateral raise',
    'extensiones de tríceps en polea': 'triceps pushdown',
    'extensiones de triceps en polea': 'triceps pushdown',
  };

  final Dio _dio;

  ExerciseService()
      : _dio = Dio(BaseOptions(
          baseUrl: _baseUrl,
          headers: {
            'X-RapidAPI-Key': _apiKey,
            'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
          },
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  /// Returns the GIF URL for an exercise name (in Spanish or English).
  Future<String?> getGifUrl(String exerciseName) async {
    try {
      final query = _translate(exerciseName);
      final response = await _dio.get(
        '/exercises/name/$query',
        queryParameters: {'limit': '1', 'offset': '0'},
      );

      final data = response.data as List?;
      if (data == null || data.isEmpty) return null;
      return data.first['gifUrl'] as String?;
    } catch (_) {
      return null;
    }
  }

  String _translate(String name) {
    final lower = name.toLowerCase().trim();
    return _nameMap[lower] ?? lower;
  }
}
