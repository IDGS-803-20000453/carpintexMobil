import 'package:carpintex/models/compras_models.dart';
import 'package:carpintex/services/compras_api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditarCompraPage extends StatefulWidget {
  final ComprasApiService apiService;
  final int compraId; // ID de la compra a editar

  EditarCompraPage({required this.apiService, required this.compraId});

  @override
  _EditarCompraPageState createState() => _EditarCompraPageState();
}

class _EditarCompraPageState extends State<EditarCompraPage> {

  InputDecoration _getInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF483D8B)), // Cambia el color del texto a morado
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF483D8B)), // Cambia el color de la línea a morado
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF483D8B)), // Cambia el color de la línea a morado
      ),
    );
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? _selectedMateriaPrima;
  String? _selectedProveedor;

  List<Map<String, dynamic>> materiasPrimas = [];
  List<Map<String, dynamic>> proveedores = [];

  @override
  void initState() {
    super.initState();
    _fetchCompra();
    _fetchNombresMateriaPrima();
    _fetchNombresProveedores();
  }

  Future<void> _fetchCompra() async {
    try {
      Compra compra = await widget.apiService.getCompra(widget.compraId);
      _cantidadController.text = compra.cantidad.toString();
      _totalController.text = compra.total.toString();
      selectedDate = DateTime.parse(compra.fecha);
      _selectedMateriaPrima = compra.materiaPrima_id.toString();
      _selectedProveedor = compra.proveedor_id.toString();
      setState(() {});
    } catch (e) {
      print('Error fetching compra: $e');
    }
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
        lastDate: DateTime.now())) ?? // Cambiar a la fecha actual
        selectedDate;
    if (picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }


  void _editarCompra() async {
    if (_formKey.currentState!.validate()) {
      Compra compra = Compra(
        id: widget.compraId,
        cantidad: int.parse(_cantidadController.text),
        total: double.parse(_totalController.text),
        fecha: DateFormat('yyyy-MM-ddTHH:mm:ss').format(selectedDate),
        materiaPrima_id: int.parse(_selectedMateriaPrima!),
        proveedor_id: int.parse(_selectedProveedor!),
      );

      try {
        await widget.apiService.actualizarCompra(widget.compraId, compra);
        Navigator.pop(context, true);
      } catch (e) {
        print('Error al editar compra: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Compra"),
        backgroundColor: Color(0xFF483D8B), // Cambia el color del AppBar

      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _cantidadController,
                decoration: _getInputDecoration('Cantidad'),                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _totalController,
                decoration: _getInputDecoration('Total'),                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              Row(
                children: [
                  Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Seleccionar Fecha'),
                      style: ElevatedButton.styleFrom(
                  primary: Color(0xFF483D8B), // Cambia el color del botón a morado
      ),
                  ),
                ],
              ),
              DropdownButtonFormField(
                value: _selectedMateriaPrima,
                items: materiasPrimas.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['id'].toString(),
                    child: Text(item['nombre']),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedMateriaPrima = value),
                hint: Text('Selecciona Materia Prima'),
                validator: (value) => value == null ? 'Campo requerido' : null,
                decoration: _getInputDecoration('Materia Prima'),
              ),
              DropdownButtonFormField(
                value: _selectedProveedor,
                items: proveedores.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['id'].toString(),
                    child: Text(item['nombre']),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedProveedor = value),
                hint: Text('Selecciona Proveedor'),
                validator: (value) => value == null ? 'Campo requerido' : null,
                decoration: _getInputDecoration('Proveedor'), // Agregar esta línea
              ),


              ElevatedButton(
                onPressed: _editarCompra,
                child: Text('Editar Compra'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF483D8B), // Cambia el color del botón a morado
                )
                ,
              ),
            ],
          ),
        ),
      ),
    );

  }
}
