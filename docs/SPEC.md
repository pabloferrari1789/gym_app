# Gym App — Spec General

## Descripción
App móvil Flutter que permite leer la planilla de entrenamiento semanal desde Google Sheets y presentarla como una rutina interactiva con ejercicios, series, repeticiones, fotos/GIFs y cronómetro de descanso.

## Linear Project
https://linear.app/pablo-ferrari-projects/project/gym-app-6844d14b6e1e

## Stack
| Capa | Tecnología |
|---|---|
| Framework | Flutter (Dart) |
| Auth | google_sign_in |
| Sheets API | googleapis |
| Estado | flutter_riverpod |
| Navegación | go_router |
| HTTP | dio |
| Exercise API | ExerciseDB (RapidAPI) |
| Cache | hive |
| Storage | flutter_secure_storage |

## Estructura de carpetas
```
lib/
├── main.dart
├── app.dart                  # MaterialApp + ProviderScope + go_router
├── models/
│   ├── workout_week.dart
│   ├── workout_day.dart
│   └── exercise.dart
├── services/
│   ├── sheets_service.dart   # Lee planilla de Google Sheets
│   └── exercise_service.dart # Busca GIFs en ExerciseDB
├── providers/
│   ├── auth_provider.dart
│   ├── week_provider.dart
│   └── exercise_provider.dart
└── screens/
    ├── login/
    ├── home/
    ├── week/
    ├── day/
    └── exercise/
docs/
├── SPEC.md                   # Este archivo
└── features/
    ├── auth.md
    ├── sheets.md
    ├── home.md
    ├── day_view.md
    ├── exercise_detail.md
    └── timer.md
```

## Fuente de datos
- Planilla: https://docs.google.com/spreadsheets/d/1pqamR-uIIxhbluGqEtrCK__xZpMbSQ6tAD-cP8QTF_U
- Hojas: `SEMANA 1`, `SEMANA 2`, `SEMANA 3`, `SEMANA 4`
- Columnas (desde fila 10): Día | Ejercicio | Series | Repeticiones | Peso (Kg) | Aclaraciones | Nivel de energía | Sensación del entrenamiento

## Reglas generales
- Codear exactamente contra la spec del ticket. Nada más, nada menos.
- Cada feature tiene su spec en `docs/features/`.
- El ticket de Linear y el archivo de spec son la misma fuente de verdad.
- No agregar lógica que no esté especificada.
