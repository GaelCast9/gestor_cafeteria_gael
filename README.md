# Gestor de Cafetería (`gestor_cafeteria`)

Aplicación cliente en Flutter para gestionar pedidos de una cafetería, conectada a un backend REST local con manejo tipado de errores (`Failure`) y pruebas unitarias con `MockClient`.

## Requisitos

- **Flutter / Dart SDK:** Dart `^3.13.2` (probado con Dart `3.13.4`)
- **Node.js:** `22.13` o superior (para ejecutar el servidor de pruebas `mini_backend`)

## Backend (`mini_backend`)

El servidor es un repositorio independiente:

- **Repositorio:** https://github.com/DMI-2026/mini_backend
- **Versión probada:** rama `master`, commit `94d2533`

### Cómo levantar `mini_backend`

```bash
git clone https://github.com/DMI-2026/mini_backend.git
cd mini_backend
node server.js
```

El servidor escuchará en `http://0.0.0.0:8000` (comprueba `GET http://localhost:8000/health`).

## Cómo ejecutar la app

1. Instala las dependencias:
   ```bash
   flutter pub get
   ```
2. Ejecuta la aplicación según el entorno:
   - **Web (Chrome):** usa `http://localhost:8000` por defecto:
     ```bash
     flutter run -d chrome
     ```
   - **Emulador Android:** usa `http://10.0.2.2:8000` por defecto:
     ```bash
     flutter run
     ```
   - **Dispositivo físico o URL personalizada:** indica `API_URL` con `--dart-define`:
     ```bash
     flutter run --dart-define=API_URL=http://<IP_DE_TU_PC>:8000
     ```

## Cómo correr las pruebas y análisis estático

```bash
flutter analyze
flutter test
```

## Estructura de carpetas

```text
lib/
  core/
    failure.dart          # Jerarquía sealed de errores (NetworkFailure, ServerFailure, etc.)
    http_client.dart      # ApiClient con mapeo de errores HTTP y manejo de timeout
  features/
    orders/               # Capas de dominio, datos e interfaz para pedidos
  main.dart               # Punto de entrada de la aplicación
test/
  core/
    failure_test.dart     # Pruebas de la jerarquía Failure
    http_client_test.dart # Pruebas unitarias de ApiClient con MockClient
```
