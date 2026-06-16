const Map<String, String> _exerciseAssets = {
  'prensa': 'assets/exercise_images/prensa.png',
  'sentadillas': 'assets/exercise_images/sentadillas.png',
  'sentadilla': 'assets/exercise_images/sentadillas.png',
  'sentadillas con barra': 'assets/exercise_images/sentadillas.png',
  'remo en máquina': 'assets/exercise_images/remo_maquina.png',
  'remo en maquina': 'assets/exercise_images/remo_maquina.png',
  'bicep con barra de pie': 'assets/exercise_images/bicep_barra.png',
  'bícep con barra de pie': 'assets/exercise_images/bicep_barra.png',
  'press plano con barra': 'assets/exercise_images/press_plano_barra.png',
  'press plano con mancuernas': 'assets/exercise_images/press_inclinado_mancuernas.png',
  'press militar sentado': 'assets/exercise_images/press_militar.png',
  'sillón de cuádriceps': 'assets/exercise_images/sillon_cuadriceps.png',
  'sillon de cuadriceps': 'assets/exercise_images/sillon_cuadriceps.png',
  'jalón al pecho': 'assets/exercise_images/jalon_pecho.png',
  'jalon al pecho': 'assets/exercise_images/jalon_pecho.png',
  'sentadilla búlgara': 'assets/exercise_images/sentadilla_bulgara.png',
  'sentadilla bulgara': 'assets/exercise_images/sentadilla_bulgara.png',
  'extensiones de triceps en polea': 'assets/exercise_images/extensiones_triceps.png',
  'extensiones de tríceps en polea': 'assets/exercise_images/extensiones_triceps.png',
  'peso muerto': 'assets/exercise_images/peso_muerto.png',
  'press de pecho inclinado con mancuernas': 'assets/exercise_images/press_inclinado_mancuernas.png',
  'press inclinado con mancuernas': 'assets/exercise_images/press_inclinado_mancuernas.png',
  'vuelos laterales': 'assets/exercise_images/vuelos_laterales.png',
};

const Map<String, String> _exerciseVideoIds = {
  'sentadillas': '-wrL2A64kPI',
  'sentadilla': '-wrL2A64kPI',
  'sentadillas con barra': '-wrL2A64kPI',
  'prensa': 'V3ucK89vtKA',
  'press plano con barra': 'VD9AEdNpPtY',
  'remo en máquina': '3rEWiQ4_ZYA',
  'remo en maquina': '3rEWiQ4_ZYA',
  'press militar sentado': '_z2D5mcgvqA',
  'bicep con barra de pie': 'gEuPG5wwqKs',
  'bícep con barra de pie': 'gEuPG5wwqKs',
  'sentadilla búlgara': 'jGqmaASCo_U',
  'sentadilla bulgara': 'jGqmaASCo_U',
  'peso muerto': '8x8ABZBim8s',
  'sillón de cuádriceps': '2btWEXFV94k',
  'sillon de cuadriceps': '2btWEXFV94k',
  'jalón al pecho': 'gjmNl--uQQA',
  'jalon al pecho': 'gjmNl--uQQA',
  'press de pecho inclinado con mancuernas': 'M8J8GSx-hxM',
  'press inclinado con mancuernas': 'M8J8GSx-hxM',
  'vuelos laterales': 'p7FViGir_PA',
  'extensiones de triceps en polea': 'J_zrIm2_m28',
  'extensiones de tríceps en polea': 'J_zrIm2_m28',
  'press plano con mancuernas': '6XAEgxUO14k',
};

String? _lookup<T>(Map<String, T> map, String exerciseName) {
  final key = exerciseName.trim().toLowerCase();
  if (map.containsKey(key)) return map[key] as String?;
  for (final entry in map.entries) {
    if (key.contains(entry.key) || entry.key.contains(key)) {
      return entry.value as String?;
    }
  }
  return null;
}

String? exerciseAsset(String exerciseName) => _lookup(_exerciseAssets, exerciseName);

String? youtubeUrl(String exerciseName) {
  final id = _lookup(_exerciseVideoIds, exerciseName);
  return id != null ? 'https://youtu.be/$id' : null;
}
