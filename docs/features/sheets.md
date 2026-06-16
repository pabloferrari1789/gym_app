# Feature: Servicio Google Sheets

**Ticket Linear:** GYM-5  
**Estado:** Backlog

## Descripción
Servicio que lee la planilla de entrenamiento desde Google Sheets y la transforma en el modelo de datos de la app.

## Planilla
- ID: `1pqamR-uIIxhbluGqEtrCK__xZpMbSQ6tAD-cP8QTF_U`
- Hojas: `SEMANA 1`, `SEMANA 2`, `SEMANA 3`, `SEMANA 4`
- Headers en fila 8: `Día | Ejercicio | Series | Repeticiones | Peso (Kg) | Aclaraciones | Nivel de energía | Sensación del entrenamiento`
- Datos desde fila 10

## Estructura de columnas
| Índice | Campo | Tipo | Notas |
|---|---|---|---|
| 0 | Día | int? | Solo en la primera fila de cada día; vacío en las siguientes |
| 1 | Ejercicio | String | Nombre del ejercicio |
| 2 | Series | int | Número de series |
| 3 | Repeticiones | String | Puede ser "6", "8-10", etc. |
| 4 | Peso (Kg) | String | Puede ser "40 kg", "8 ladrillos", "17,5 por lado" |
| 5 | Aclaraciones | String? | Instrucciones del profe |
| 6 | Nivel de energía | String? | Dropdown, el usuario completa |
| 7 | Sensación | String? | Dropdown, el usuario completa |

## Lógica de parseo
```dart
// El campo Día solo aparece en la primera fila de cada día.
// Agrupar usando el último valor de Día visto.
int currentDay = 0;
for (final row in rows) {
  if (row[0].isNotEmpty) currentDay = int.parse(row[0]);
  days[currentDay] ??= [];
  days[currentDay]!.add(Exercise.fromRow(row));
}
```

## API call
```dart
// Rango a leer
final range = 'SEMANA $weekNumber!A8:H50';
final result = await sheetsApi.spreadsheets.values.get(spreadsheetId, range);
```

## Implementación
- Clase: `SheetsService`
- Método: `Future<WorkoutWeek> getWeek(int weekNumber, String accessToken)`
- Usa `googleapis` + `google_auth_http_client`

## Casos de error
| Caso | Comportamiento |
|---|---|
| Sin permisos | Lanzar `PermissionException` → redirigir a login |
| Hoja no encontrada | Lanzar `SheetNotFoundException` |
| Fila malformada | Skipear la fila y loggear warning |
| Sin conexión | Lanzar `NetworkException` → mostrar mensaje en UI |
