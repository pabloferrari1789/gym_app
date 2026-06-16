# Feature: Vista de Ejercicios del Día

**Ticket Linear:** GYM-9  
**Estado:** Backlog

## Descripción
Lista todos los ejercicios de un día de entrenamiento con su info básica.

## Ruta
`/week/:weekNumber/day/:dayNumber`

## Layout
```
AppBar
  - Título: "DÍA :dayNumber"
  - Back button → Home

Body
  - Barra de progreso (ejercicios completados / total)
  - Lista scrolleable de ExerciseListItems

```

## Barra de progreso
- Linear progress bar debajo del AppBar
- Texto: "3 / 6 ejercicios" 
- Se actualiza al marcar ejercicios como completados

## ExerciseListItem
Cada ítem de la lista muestra:
- Thumbnail del GIF (40x40px, esquinas redondeadas) — cargado desde ExerciseDB; placeholder si no carga
- Nombre del ejercicio
- Series × Repeticiones (ej: "3 × 6")
- Peso (ej: "40 kg")
- Ícono de nota (📋) si el campo `Aclaraciones` no está vacío
- Checkbox a la derecha para marcar como completado

## Interacciones
- Tocar el ítem → navegar a `/week/:weekNumber/day/:dayNumber/exercise/:exerciseIndex`
- Tocar checkbox → marcar/desmarcar completado (estado local, no persiste en Sheets)

## Navegación
- Back → `/home`
- Tap en ejercicio → detalle del ejercicio
