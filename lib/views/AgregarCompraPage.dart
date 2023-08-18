import 'package:intl/intl.dart'; // Importa esto para el formateo de la fecha
import 'package:carpintex/models/compras_models.dart';
import 'package:carpintex/services/compras_api_service.dart';
import 'package:flutter/material.dart';

class AgregarCompraPage extends StatefulWidget {
  final ComprasApiService apiService;

  AgregarCompraPage({required this.apiService});

  @override
  _AgregarCompraPageState createState() => _AgregarCompraPageState();
}

class _AgregarCompraPageState extends State<AgregarCompraPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  DateTime selectedDate = DateTime.now(); // Agrega esto para almacenar la fecha seleccionada
  String? _selectedMateriaPrima;
  String? _selectedProveedor;

  List<Map<String, dynamic>> materiasPrimas = [];
  List<Map<String, dynamic>> proveedores = [];

  @override
  void initState() {
    super.initState();
    _fetchNombresMateriaPrima();
    _fetchNombresProveedores();
  }

  Future<void> _fetchNombresMateriaPrima() async {
    try {
      materiasPrimas = await widget.apiService.getNombresMateriaPrima();
      setState(() {});
    } catch (e) {
      print('Error fetching nombres materias primas: $e');
    }
  }

  Future<void> _fetchNombresProveedores() async {
    try {
      proveedores = await widget.apiService.getNombresProveedores();
      setState(() {});
    } catch (e) {
      print('Error fetching nombres proveedores: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101))) ??
        selectedDate;
    if (picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void _agregarCompra() async {
    if (_formKey.currentState!.validate()) {
      Compra compra = Compra(
        id: 0,
        cantidad: int.parse(_cantidadController.text),
        total: double.parse(_totalController.text),
        fecha: DateFormat('yyyy-MM-ddTHH:mm:ss').format(selectedDate), // Usa la fecha seleccionada
        materiaPrima_id: int.parse(_selectedMateriaPrima!),
        proveedor_id: int.parse(_selectedProveedor!),
      );

      try {
        await widget.apiService.agregarCompra(compra);
        Navigator.pop(context, true);
      } catch (e) {
        print('Error al agregar compra: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Compra"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _cantidadController,
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _totalController,
                decoration: InputDecoration(labelText: 'Total'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              Row(
                children: [
                  Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Seleccionar Fecha'),
                  ),
                ],
              ),
              DropdownButtonFormField(
                items: materiasPrimas.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['id'].toString(),
                    child: Text(item['nombre']),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedMateriaPrima = value),
                hint: Text('Selecciona Materia Prima'),
                validator: (value) => value == null ? 'Campo requerido' : null,
              ),
              DropdownButtonFormField(
                items: proveedores.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['id'].toString(),
                    child: Text(item['nombre']),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedProveedor = value),
                hint: Text('Selecciona Proveedor'),
                validator: (value) => value == null ? 'Campo requerido' : null,
              ),
              ElevatedButton(
                onPressed: _agregarCompra,
                child: Text('Agregar Compra'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
