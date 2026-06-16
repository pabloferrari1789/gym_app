# Feature: Home Screen

**Tickets Linear:** GYM-7, GYM-8  
**Estado:** Backlog

## Descripción
Pantalla principal post-login. Muestra el selector de semana y la lista de días de entrenamiento.

## Ruta
`/home`

## Layout
```
AppBar
  - Título: "Mi Rutina"
  - Avatar del usuario (foto de Google)
  - Botón logout (ícono)

Body
  - Selector de semana (chips horizontales): SEMANA 1 | SEMANA 2 | SEMANA 3 | SEMANA 4
  - Loading indicator mientras se carga la semana
  - Lista de DayCards (una por día)

```

## Selector de semana
- 4 chips: `SEMANA 1`, `SEMANA 2`, `SEMANA 3`, `SEMANA 4`
- Al iniciar: seleccionar la semana activa automáticamente (ver lógica abajo)
- Al tocar un chip → cargar esa semana desde Sheets → actualizar lista de días

## Lógica semana activa
- La semana activa se calcula dividiendo los días transcurridos desde el inicio del ciclo entre 7 (1 semana = 7 días)
- Fallback: SEMANA 1 si no se puede calcular

## DayCard
Cada card representa un día de entrenamiento:
- Número de día: "DÍA 1", "DÍA 2", etc.
- Cantidad de ejercicios: "6 ejercicios"
- Preview: nombres de los primeros 3 ejercicios separados por "·"
- Indicador de completado: checkmark verde si todos los ejercicios del día tienen `energyLevel` y `trainingSensation` cargados
- Al tocar → navegar a `/week/:weekNumber/day/:dayNumber`

## Estados
| Estado | UI |
|---|---|
| Cargando semana | CircularProgressIndicator centrado |
| Error de red | Mensaje + botón "Reintentar" |
| Sin datos | Mensaje "No hay rutina para esta semana" |
| Con datos | Lista de DayCards |
