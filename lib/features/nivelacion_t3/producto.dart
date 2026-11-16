// Entidad del proyecto gestor_cafeteria para la lista de tres estados.
class Producto {
  const Producto({
    required this.nombre,
    required this.categoria,
    required this.precio,
    this.disponible = true,
  });

  final String nombre;
  final String categoria;
  final double precio;
  final bool disponible;
}
