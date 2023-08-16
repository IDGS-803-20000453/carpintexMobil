class Compra {
  final int id;
  final int cantidad;
  final double total;
  final String fecha;
  final int materiaPrima_id;
  final int proveedor_id;

  Compra({
    required this.id,
    required this.cantidad,
    required this.total,
    required this.fecha,
    required this.materiaPrima_id,
    required this.proveedor_id,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cantidad': cantidad,
      'total': total,
      'fecha': fecha,
      'materiaPrima_id': materiaPrima_id,
      'proveedor_id': proveedor_id,
    };
  }

  factory Compra.fromJson(Map<String, dynamic> json) {
    return Compra(
      id: json['id'],
      cantidad: json['cantidad'],
      total: (json['total'] as num).toDouble(), // Convierte a double
      fecha: json['fecha'],
      materiaPrima_id: json['materiaPrima_id'],
      proveedor_id: json['proveedor_id'],
    );
  }
}

class CompraConNombres {
  final Compra compra;
  final String nombreMateriaPrima;
  final String nombreProveedor;

  CompraConNombres({
    required this.compra,
    required this.nombreMateriaPrima,
    required this.nombreProveedor,
  });

  factory CompraConNombres.fromJson(Map<String, dynamic> json) {
    return CompraConNombres(
      compra: Compra.fromJson(json['compra']),
      nombreMateriaPrima: json['nombreMateriaPrima'],
      nombreProveedor: json['nombreProveedor'],
    );
  }
}
