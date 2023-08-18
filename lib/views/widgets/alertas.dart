import 'package:flutter/material.dart';

void showDeleteDialog(BuildContext context, Function onDelete) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Eliminar compra'),
        content: Text('¿Desea eliminar esta compra? Esta acción no se va a poder deshacer.'),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.cancel, color: Colors.red),
            label: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.delete, color: Colors.green),
            label: Text('Sí, eliminar'),
            onPressed: () {
              onDelete(); // Llama a la función de eliminación
              Navigator.of(context).pop(); // Cierra el diálogo
            },
          ),
        ],
      );
    },
  );
}

void showEditDialog(BuildContext context, Function onEdit) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Editar compra'),
        content: Text('¿Desea editar esta compra?'),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.cancel, color: Colors.red),
            label: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.edit, color: Colors.green),
            label: Text('Sí, editar'),
            onPressed: () {
              onEdit(); // Llama a la función de edición
              Navigator.of(context).pop(); // Cierra el diálogo
            },
          ),
        ],
      );
    },
  );
}

void showCreateDialog(BuildContext context, Function onCreate) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Crear compra'),
        content: Text('¿Desea crear esta compra?'),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.cancel, color: Colors.red),
            label: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.add, color: Colors.green),
            label: Text('Sí, crear'),
            onPressed: () {
              onCreate(); // Llama a la función de creación
              Navigator.of(context).pop(); // Cierra el diálogo
            },
          ),
        ],
      );
    },
  );
}


