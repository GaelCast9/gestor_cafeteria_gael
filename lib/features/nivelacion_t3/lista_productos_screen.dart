import 'package:flutter/material.dart';

import 'producto.dart';
import 'repositorio_falso.dart';
import 'resultado.dart';

// IA: Pantalla StatefulWidget controlada por la clase sellada Resultado.
class ListaProductosScreen extends StatefulWidget {
  const ListaProductosScreen({super.key});

  @override
  State<ListaProductosScreen> createState() => _ListaProductosScreenState();
}

class _ListaProductosScreenState extends State<ListaProductosScreen> {
  final RepositorioProductosFalso _repo = RepositorioProductosFalso();
  Resultado<List<Producto>> _estado = const Cargando();

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  // IA: Carga asíncrona con verificación mounted antes de llamar setState.
  Future<void> _cargar() async {
    setState(() => _estado = const Cargando());
    try {
      final productos = await _repo.obtener();
      if (!mounted) return;
      setState(() => _estado = Exito(productos));
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _estado = const Error(
          'No se pudo cargar el menú de la cafetería. Revisa tu conexión e intenta de nuevo.',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú de Cafetería')),
      // IA: switch exhaustivo sobre Resultado<List<Producto>> sin default.
      body: switch (_estado) {
        Cargando() => const Center(child: CircularProgressIndicator()),
        Exito(datos: final productos) => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: productos.length,
          itemBuilder: (context, index) {
            final p = productos[index];
            return Card(
              child: ListTile(
                leading: Icon(
                  p.disponible ? Icons.local_cafe : Icons.block,
                ),
                title: Text(p.nombre),
                subtitle: Text(
                  '${p.categoria} · ${p.disponible ? 'Disponible' : 'Agotado'}',
                ),
                trailing: Text(
                  '\$${p.precio.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            );
          },
        ),
        Error(mensaje: final msg) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, size: 48),
                const SizedBox(height: 12),
                Text(msg, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _cargar,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      },
    );
  }
}
