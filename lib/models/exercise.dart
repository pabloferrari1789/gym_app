class Exercise {
  final String name;
  final int sets;
  final String reps;
  final String weight;
  final String notes;
  String? energyLevel;
  String? trainingSensation;
  String? gifUrl;
  bool completed;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.notes,
    this.energyLevel,
    this.trainingSensation,
    this.gifUrl,
    this.completed = false,
  });

  factory Exercise.fromRow(List<String> row) {
    return Exercise(
      name: _safe(row, 1),
      sets: int.tryParse(_safe(row, 2)) ?? 0,
      reps: _safe(row, 3),
      weight: _safe(row, 4),
      notes: _safe(row, 5),
      energyLevel: _safeNullable(row, 6),
      trainingSensation: _safeNullable(row, 7),
    );
  }

  static String _safe(List<String> row, int index) =>
      index < row.length ? row[index].trim() : '';

  static String? _safeNullable(List<String> row, int index) {
    final val = index < row.length ? row[index].trim() : '';
    return val.isEmpty ? null : val;
  }

  bool get isFullyLogged =>
      energyLevel != null && trainingSensation != null;
}
