# Feature: Cronómetro de Descanso

**Ticket Linear:** GYM-11  
**Estado:** Backlog

## Descripción
Cronómetro de cuenta regresiva para el descanso entre series. Se activa desde la pantalla de detalle de ejercicio.

## Presentación
- Modal bottom sheet (no pantalla separada)
- Se abre al tocar "Iniciar descanso" en el detalle del ejercicio

## Layout del modal
```
Handle bar

Título: "Descanso"

Selector de tiempo (chips): [60s] [90s] [120s]
  └── Default: 90s

Cronómetro circular animado (countdown)
  └── Muestra tiempo restante en el centro (MM:SS)

Botones:
  [Pausar / Reanudar]   [Resetear]

```

## Comportamiento
- Al abrir: iniciar countdown automáticamente con el tiempo seleccionado
- Al llegar a 0: vibración del dispositivo + sonido de alerta
- Si el usuario cierra el modal antes de terminar: pausar y descartar
- El cronómetro NO corre en background (fuera de scope v1)

## Paquetes
- `circular_countdown_timer: ^0.6.x`
- `vibration: ^1.x` (para haptic feedback)

## Estados
| Estado | UI |
|---|---|
| Corriendo | Círculo animándose, botón "Pausar" |
| Pausado | Círculo estático, botón "Reanudar" |
| Terminado | Círculo rojo, texto "¡Listo!" |
