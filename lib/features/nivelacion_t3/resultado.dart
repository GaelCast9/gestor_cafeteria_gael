// Clase sellada Resultado<T> reutilizada de la Nivelación T1.
sealed class Resultado<T> {
  const Resultado();
}

class Cargando<T> extends Resultado<T> {
  const Cargando();
}

class Exito<T> extends Resultado<T> {
  const Exito(this.datos);
  final T datos;
}

class Error<T> extends Resultado<T> {
  const Error(this.mensaje);
  final String mensaje;
}
