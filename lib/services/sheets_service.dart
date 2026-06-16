import 'package:googleapis/sheets/v4.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/exercise.dart';
import '../models/workout_day.dart';
import '../models/workout_week.dart';

class SheetsService {
  static const _spreadsheetId =
      '1pqamR-uIIxhbluGqEtrCK__xZpMbSQ6tAD-cP8QTF_U';

  final GoogleSignIn _googleSignIn;

  SheetsService(this._googleSignIn);

  Future<WorkoutWeek> getWeek(
      int weekNumber, GoogleSignInAccount account) async {
    final httpClient =
        await _googleSignIn.authenticatedClient();
    if (httpClient == null) throw Exception('No authenticated client');

    final sheetsApi = SheetsApi(httpClient);
    final range = 'SEMANA $weekNumber!A8:H50';

    final response = await sheetsApi.spreadsheets.values.get(
      _spreadsheetId,
      range,
    );

    final rows = response.values ?? [];
    return _parse(weekNumber, rows);
  }

  WorkoutWeek _parse(int weekNumber, List<List<Object?>> rawRows) {
    // Skip header row (index 0 = fila 8 del sheet = headers)
    final dataRows = rawRows.length > 1 ? rawRows.sublist(1) : <List<Object?>>[];

    final Map<int, List<Exercise>> dayMap = {};
    int currentDay = 0;

    for (final rawRow in dataRows) {
      final row = rawRow.map((e) => e?.toString() ?? '').toList();

      // Skip empty rows and footer rows
      if (row.isEmpty || row.every((c) => c.trim().isEmpty)) continue;
      if (row[0].trim().startsWith('¿')) continue;

      // New day if first cell has a number
      final dayCell = row[0].trim();
      if (dayCell.isNotEmpty) {
        final parsed = int.tryParse(dayCell);
        if (parsed != null) currentDay = parsed;
      }

      if (currentDay == 0) continue;

      // Skip rows with no exercise name
      final exerciseName = row.length > 1 ? row[1].trim() : '';
      if (exerciseName.isEmpty) continue;

      dayMap[currentDay] ??= [];
      dayMap[currentDay]!.add(Exercise.fromRow(row));
    }

    final days = dayMap.entries
        .map((e) => WorkoutDay(dayNumber: e.key, exercises: e.value))
        .toList()
      ..sort((a, b) => a.dayNumber.compareTo(b.dayNumber));

    return WorkoutWeek(weekNumber: weekNumber, days: days);
  }
}
