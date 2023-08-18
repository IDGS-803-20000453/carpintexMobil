import 'package:flutter/material.dart';

class SortDropdown extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  SortDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: [
          'Fecha. Más antiguo',
          'Fecha. Más reciente',
          'Cantidad. Menos a Más',
          'Cantidad. Más a Menos',
          'Total. Menos a Más',
          'Total. Más a Menos',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class ProductSortDropdown extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  ProductSortDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: [
          'Nombre. A-Z',
          'Nombre. Z-A',
          'Stock. Menos a Más',
          'Stock. Más a Menos',
          'Total. Menos a Más',
          'Total. Más a Menos',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}





