import 'dart:convert';
import 'package:carpintex/models/compras_models.dart';
import 'package:carpintex/models/productos_models.dart';
import 'package:http/http.dart' as http;





  class ProductosApiService {
  final String baseUrl = 'https://192.168.137.1:7241/api/Producto';

  Future<List<Producto>> getProductos() async {
  print('Fetching productos...'); // Log antes de la llamada a la API
  final response = await http.get(Uri.parse(baseUrl));
  if (response.statusCode == 200) {
  print('Response received: ${response.body}'); // Log de la respuesta
  List<dynamic> responseData = json.decode(response.body);
  return responseData.map((data) => Producto.fromJson(data)).toList();
  } else {
  print('Failed to load productos, status code: ${response.statusCode}'); // Log en caso de error
  throw Exception('Failed to load productos');
  }
  }
  }

