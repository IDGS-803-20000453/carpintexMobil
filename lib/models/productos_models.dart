class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final int stock;
  final double altura;
  final double ancho;
  final double largo;
  final String? imagen; // Puede ser nula
  final double total;
  final int estatus;
  final DateTime? create_date;


  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.stock,
    required this.altura,
    required this.ancho,
    required this.largo,
    required this.imagen,
    required this.total,
    required this.estatus,
    required this.create_date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'stock': stock,
      'altura': altura,
      'ancho': ancho,
      'largo': largo,
      'imagen': imagen,
      'total': total,
      'estatus': estatus,
      'create_date': create_date,
    };
  }

  factory Producto.fromJson(Map<String, dynamic> json) {
    String? fechaString = json['create_date'];
    DateTime? fecha = fechaString != null ? DateTime.tryParse(fechaString) : null;

    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      stock: json['stock'],
      altura: (json['altura'] ?? 0).toDouble(),
      ancho: (json['ancho'] ?? 0).toDouble(),
      largo: (json['largo'] ?? 0).toDouble(),
      imagen: json['imagen'], // Ya es nulo, así que está bien
      total: (json['total'] ?? 0).toDouble(),
      estatus: json['estatus'],
      create_date: fecha,
    );
  }



}

