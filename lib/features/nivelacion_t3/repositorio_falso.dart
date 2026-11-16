import 'producto.dart';

// IA: Repositorio falso con retardo simulado y fallo en el primer intento.
class RepositorioProductosFalso {
  int _llamadas = 0;

  Future<List<Producto>> obtener() async {
    await Future.delayed(const Duration(seconds: 2));
    _llamadas++;
    if (_llamadas == 1) {
      throw Exception('Sin conexión');
    }
    return const [
      Producto(nombre: 'Espresso', categoria: 'Café caliente', precio: 38.0),
      Producto(nombre: 'Americano', categoria: 'Café caliente', precio: 42.0),
      Producto(nombre: 'Latte Vainilla', categoria: 'Café caliente', precio: 55.0),
      Producto(nombre: 'Cappuccino', categoria: 'Café caliente', precio: 52.0),
      Producto(nombre: 'Mocha Frappé', categoria: 'Bebida fría', precio: 65.0),
      Producto(
        nombre: 'Té Chai',
        categoria: 'Té e infusiones',
        precio: 58.0,
        disponible: false,
      ),
    ];
  }
}
