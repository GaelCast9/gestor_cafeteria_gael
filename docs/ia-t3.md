# Declaración de uso de IA · Nivelación T3

## Herramienta utilizada
Asistente de IA (para generación guiada de la estructura de pantalla y repositorio falso bajo Política Nivel 2).

## Prompts principales
1. "Genera un repositorio falso en Dart para la entidad `Producto` de `gestor_cafeteria` con retardo de 2 segundos, al menos 5 elementos, que falle la primera llamada y funcione en la segunda."
2. "Crea una pantalla `StatefulWidget` en Flutter (Material 3) que use `Resultado<List<Producto>>`, verifique `if (!mounted) return;` después del `await` y pinte los tres estados (`Cargando`, `Exito`, `Error`) con un `switch` exhaustivo sin `default`."

## Qué acepté, qué cambié y cómo lo probé
- **Aceptado:** La estructura del `switch` exhaustivo sobre la clase sellada `Resultado<T>` (marcada con `// IA:`), la validación de `mounted` antes de `setState` y el botón `Reintentar`.
- **Cambiado / ajustado:** Se adaptaron los nombres y categorías de productos al dominio de la cafetería (`Espresso`, `Americano`, `Latte Vainilla`, `Cappuccino`, `Mocha Frappé`, `Té Chai`) y se redactó el mensaje de error en español sin exponer el texto técnico de la excepción.
- **Cómo se probó:** Se ejecutó `flutter analyze`, `flutter test` y `flutter run -d chrome` verificando manualmente los tres estados: indicador de carga (`Cargando`), pantalla de error con botón `Reintentar` (primer intento) y lista de 6 tarjetas (`Exito`) tras presionar `Reintentar`.
