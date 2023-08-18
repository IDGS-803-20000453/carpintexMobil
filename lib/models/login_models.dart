class User {
  final int id;
  final String name;
  final String email;
  final String calle;
  final String codigopostal;
  final String estado;
  final String ciudad;
  final String passwordUsuario;
  final bool activo;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.calle,
    required this.codigopostal,
    required this.estado,
    required this.ciudad,
    required this.passwordUsuario,
    required this.activo,
  });
}