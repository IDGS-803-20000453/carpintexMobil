import 'package:carpintex/models/compras_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CompraCard extends StatelessWidget {
  final CompraConNombres compraConNombres;

  CompraCard({required this.compraConNombres});

  @override
  Widget build(BuildContext context) {
    String fecha = DateFormat('dd/MM/yyyy').format(DateTime.parse(compraConNombres.compra.fecha));
    return Dismissible(
      key: Key(compraConNombres.compra.id.toString()),
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, color: Colors.white),
            Text('Eliminar', style: TextStyle(color: Colors.white)),
          ],
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
      ),
      secondaryBackground: Container(
        color: Colors.grey,
        child: Row(
          children: [
            Icon(Icons.edit, color: Colors.white),
            Text('Editar', style: TextStyle(color: Colors.white)),
          ],
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
      ),
      onDismissed: (direction) {
        // Aquí puedes agregar la funcionalidad para editar si se desliza hacia la izquierda
      },
      child: GestureDetector(
        onLongPress: () {
          HapticFeedback.vibrate(); // Vibración del teléfono
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[200], // Color gris del fondo
              title: Text('Nombre Materia Prima: ${compraConNombres.nombreMateriaPrima}', style: TextStyle(fontSize: 12)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Nombre Proveedor: ${compraConNombres.nombreProveedor}', style: TextStyle(fontSize: 12)),
                  ElevatedButton(
                    onPressed: () {
                      // Funcionalidad para editar
                    },
                    child: Text('Editar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Funcionalidad para eliminar
                    },
                    child: Text('Eliminar'),
                  ),
                ],
              ),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Espaciado reducido
            title: Text(compraConNombres.nombreMateriaPrima, style: TextStyle(fontSize: 12)), // Tamaño de fuente reducido
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(compraConNombres.nombreProveedor, style: TextStyle(fontSize: 12)), // Tamaño de fuente reducido
                Text('Cantidad: ${compraConNombres.compra.cantidad}', style: TextStyle(fontSize: 12)), // Tamaño de fuente reducido
                Text('Total: \$${compraConNombres.compra.total}', style: TextStyle(fontSize: 12)), // Tamaño de fuente reducido
                Text('Fecha: $fecha', style: TextStyle(fontSize: 12)), // Tamaño de fuente reducido
              ],
            ),
          ),
        ),
      ),
    );
  }
}
