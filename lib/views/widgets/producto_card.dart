import 'dart:convert';
import 'dart:typed_data';
import 'package:carpintex/models/productos_models.dart';
import 'package:flutter/material.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final int index;
  final Widget imagenWidget;
  final VoidCallback onTap; // Agregar esta línea


  ProductoCard(
      {required this.producto, required this.index, required this.onTap})
      : imagenWidget = producto.imagen != null
      ? Image.memory(base64Decode(producto.imagen!), width: 50, height: 50)
      : Icon(Icons.image_not_supported);

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Agregar esta línea
      onTap: onTap, // Agregar esta línea
      child: Card(
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
              leading: imagenWidget,
              // Utiliza el widget de imagen que hemos creado
              title: Text(producto.nombre,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'Stock: ${producto.stock}', style: TextStyle(fontSize: 12)),
            ),
          ),
        ),
      ),
    ); // Agregar esta línea
  }
}

