import 'package:carpintex/models/compras_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

class CompraCard extends StatelessWidget {
  final CompraConNombres compraConNombres;
  final Function onEdit; // Función para editar
  final Function onDelete; // Función para eliminar
  final int index; // Índice para el color

  CompraCard({required this.compraConNombres, required this.onEdit, required this.onDelete, required this.index});

  @override
  Widget build(BuildContext context) {
    String fecha = DateFormat('dd/MM/yyyy').format(DateTime.parse(compraConNombres.compra.fecha));
    return Dismissible(
        key: Key(compraConNombres.compra.id.toString()),
        background: Container(
          color: Colors.grey,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.white),
              Text('Editar', style: TextStyle(color: Colors.white, fontSize: 8)),
              SizedBox(width: 5),
              Text('⟶', style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 20),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          child: Row(
            children: [
              Text('⟵', style: TextStyle(color: Colors.white, fontSize: 10)),
              SizedBox(width: 5),
              Text('Eliminar', style: TextStyle(color: Colors.white, fontSize: 8)),
              Icon(Icons.delete, color: Colors.white),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            onEdit();
          } else if (direction == DismissDirection.endToStart) {
            onDelete();
          }
          return false;
        },
        child: InkWell(
          onTap: () async {
            final bool? canVibrate = await Vibration.hasVibrator();
            if (canVibrate == true) {
              Vibration.vibrate(duration: 1);
            }
          },
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
                  title: Text(compraConNombres.nombreMateriaPrima, style: TextStyle(fontSize: 12)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(compraConNombres.nombreProveedor, style: TextStyle(fontSize: 12)),
                      Text('Cantidad: ${compraConNombres.compra.cantidad}', style: TextStyle(fontSize: 12)),
                      Text('Total: \$${compraConNombres.compra.total}', style: TextStyle(fontSize: 12)),
                      Text('Fecha: $fecha', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      final RenderBox renderBox = context.findRenderObject() as RenderBox;
                      final position = renderBox.localToGlobal(Offset.zero);
                      final size = renderBox.size;

                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          position.dx + size.width - 50, // Ajuste manual para alinear a la derecha
                          position.dy + size.height,
                          position.dx + size.width, // Posición de final
                          position.dy,
                        ),
                        items: <PopupMenuEntry<int>>[
                          PopupMenuItem<int>(
                            value: 0,
                            child: Row(
                              children: [
                                Icon(Icons.edit), // Ícono de editar
                                Text('Editar'),
                              ],
                            ),
                          ),
                          PopupMenuItem<int>(
                            value: 1,
                            child: Row(
                              children: [
                                Icon(Icons.delete), // Ícono de eliminar
                                Text('Eliminar'),
                              ],
                            ),
                          ),
                        ],
                      )

                          .then((result) {
                        if (result == 0) {
                          onEdit();
                        } else if (result == 1) {
                          onDelete();
                        }
                      });
                    },
                    child: Icon(Icons.more_vert), // Ícono para abrir el menú
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}
