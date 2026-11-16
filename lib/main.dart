import 'package:flutter/material.dart';

import 'features/nivelacion_t3/lista_productos_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.brown),
      home: const ListaProductosScreen(),
    );
  }
}
