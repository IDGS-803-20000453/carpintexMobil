// compras_api_service.dart

import 'dart:convert';
import 'package:carpintex/models/compras_models.dart';
import 'package:http/http.dart' as http;


class ComprasApiService {
  final String baseUrl = 'https://192.168.137.1:7241/api/Compras';

  Future<List<Compra>> getCompras() async {
    print('Fetching compras...'); // Log antes de la llamada a la API
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      print('Response received: ${response.body}'); // Log de la respuesta
      List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => Compra.fromJson(data)).toList();
    } else {
      print('Failed to load compras, status code: ${response.statusCode}'); // Log en caso de error
      throw Exception('Failed to load compras');
    }
  }


  Future<void> agregarCompra(Compra compra) async {
    print('Enviando compra: ${json.encode(compra.toJson())}');

    final response = await http.post(
      Uri.parse(baseUrl),
      body: json.encode(compra.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    print('Código de estado de la respuesta: ${response.statusCode}'); // Imprime el código de estado
    print('Respuesta del servidor: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add compra');
    }
  }



  Future<void> eliminarCompra(int id) async {
    print('Eliminando compra con ID $id...'); // Log antes de la llamada a la API
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    print('Código de estado de la respuesta: ${response.statusCode}'); // Imprime el código de estado
    print('Respuesta del servidor: ${response.body}'); // Log de la respuesta
    if (response.statusCode != 200) {
      throw Exception('Failed to delete compra');
    }
  }

  Future<void> actualizarCompra(int id, Compra compra) async {
    print('Actualizando compra con ID $id: ${json.encode(compra.toJson())}'); // Imprime los detalles de la compra

    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      body: json.encode(compra.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    print('Código de estado de la respuesta: ${response.statusCode}'); // Imprime el código de estado
    print('Respuesta del servidor: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to update compra');
    }
  }


  Future<Compra> getCompra(int id) async {
    print('Fetching compra con ID $id...'); // Log antes de la llamada a la API
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    print('Response received: ${response.body}'); // Log de la respuesta
    if (response.statusCode == 200) {
      return Compra.fromJson(json.decode(response.body));
    } else {
      print('Failed to load compra, status code: ${response.statusCode}'); // Log en caso de error
      throw Exception('Failed to load compra');
    }
  }

  Future<List<CompraConNombres>> getCompraConNombres() async {
    print('Fetching compras con nombres...'); // Log antes de la llamada a la API
    final response = await http.get(Uri.parse('$baseUrl/con-nombres'));
    if (response.statusCode == 200) {
      print('Response received: ${response.body}'); // Log de la respuesta
      List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => CompraConNombres.fromJson(data)).toList();
    } else {
      print('Failed to load compras con nombres, status code: ${response.statusCode}'); // Log en caso de error
      throw Exception('Failed to load compras con nombres');
    }
  }


  Future<List<Map<String, dynamic>>> getNombresMateriaPrima() async {
    final response = await http.get(Uri.parse('$baseUrl/materias-primas'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load nombres materias primas');
    }
  }

  Future<List<Map<String, dynamic>>> getNombresProveedores() async {
    final response = await http.get(Uri.parse('$baseUrl/proveedores'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load nombres proveedores');
    }
  }


}
