import 'package:carpintex/models/productos_models.dart';
import 'package:flutter/material.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto; // Aceptar el objeto de tipo Producto directamente
  final int index;
  ProductoCard({required this.producto, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(200.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color(0xFFF5F5F5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            title: Text(producto.nombre, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle: Text('Stock: ${producto.stock}', style: TextStyle(fontSize: 12)),
          ),
        ),
      ),
    );
  }
}
