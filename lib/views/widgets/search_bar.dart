import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Buscar',
          suffixIcon: Icon(Icons.search),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
