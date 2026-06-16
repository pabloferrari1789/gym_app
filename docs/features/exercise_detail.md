# Feature: Detalle de Ejercicio

**Ticket Linear:** GYM-10  
**Estado:** Backlog

## Descripción
Pantalla de detalle de un ejercicio individual con GIF animado, info completa y cronómetro de descanso.

## Ruta
`/week/:weekNumber/day/:dayNumber/exercise/:exerciseIndex`

## Layout
```
AppBar
  - Título: nombre del ejercicio
  - Back → lista de ejercicios del día
  - Flechas ← → para navegar al ejercicio anterior/siguiente

Body (scroll)
  GIF animado (ancho completo, altura ~250px)
    └── Placeholder de mancuerna si no hay GIF

  Chips de info:
    [🔁 3 series]  [× 6 reps]  [⚖️ 40 kg]

  Músculo objetivo (desde ExerciseDB):
    "Músculo principal: Cuádriceps"

  Sección "Nota del profe" (solo si Aclaraciones no está vacío):
    └── Texto en card con fondo diferenciado

  Botón "Iniciar descanso" → abre cronómetro (ver timer.md)
```

## Navegación anterior/siguiente
- Flechas en el AppBar
- Al llegar al primer/último ejercicio del día, deshabilitar la flecha correspondiente

## GIF
- Buscar en ExerciseDB por nombre del ejercicio (ver `exercise_service.md`)
- Mostrar con `Image.network` + `loadingBuilder` para skeleton
- Si falla o no hay resultado: mostrar ícono de mancuerna centrado

## ExerciseDB — mapeo español → inglés
La planilla tiene nombres en español. Mapear antes de buscar:

| Español | Inglés |
|---|---|
| Sentadillas | squat |
| Prensa | leg press |
| Press plano con barra | barbell bench press |
| Remo en máquina | seated cable row |
| Press militar sentado | seated dumbbell shoulder press |
| Bíceps con barra de pie | barbell curl |
| Sentadilla búlgara | bulgarian split squat |
| Peso muerto | deadlift |
| Sillón de cuádriceps | leg extension |
| Jalón al pecho | lat pulldown |
| Press de pecho inclinado con mancuernas | incline dumbbell press |
| Vuelos laterales | lateral raise |
| Extensiones de tríceps en polea | triceps pushdown |

Si no hay match en el mapa → buscar con el nombre original.
