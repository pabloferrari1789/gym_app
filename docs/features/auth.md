# Feature: Autenticación con Google

**Ticket Linear:** GYM-2  
**Estado:** Backlog

## Descripción
El usuario inicia sesión con su cuenta de Google. La app solicita los permisos necesarios para leer Google Sheets y Drive. La sesión se persiste entre reinicios de la app.

## Scopes OAuth requeridos
- `email`
- `https://www.googleapis.com/auth/spreadsheets.readonly`
- `https://www.googleapis.com/auth/drive.readonly`

## Flujo
1. App abre → verifica si hay sesión activa en `flutter_secure_storage`
2. Si hay sesión → navegar a `/home`
3. Si no hay sesión → mostrar pantalla de Login
4. Usuario toca "Iniciar sesión con Google" → OAuth flow
5. Éxito → guardar token → navegar a `/home`
6. Error → mostrar mensaje de error inline (no dialog)

## Pantalla Login
- Fondo: color primario de la app
- Logo/nombre de la app centrado
- Botón "Continuar con Google" (estilo oficial de Google Sign-In)
- Sin otros elementos

## Logout
- Botón en el AppBar de Home
- Al tocar: cerrar sesión de Google + limpiar token de storage + navegar a `/login`
- No pedir confirmación

## Paquetes
- `google_sign_in: ^6.x`
- `flutter_secure_storage: ^9.x`

## Casos de error
| Caso | Comportamiento |
|---|---|
| Usuario cancela el login | Volver a pantalla de login sin mensaje |
| Sin conexión | Mostrar mensaje "Sin conexión a internet" |
| Token expirado | Re-autenticar silenciosamente; si falla, redirigir a login |
