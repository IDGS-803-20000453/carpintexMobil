import 'dart:async';
import 'dart:convert';

import 'package:carpintex/models/compras_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConnectionStatus extends ChangeNotifier {
  final String baseUrl = 'https://192.168.137.1:7241/api/Usuario';

  bool _isConnected = true; // Estado inicial de la conexión
  String _message = ''; // Mensaje para mostrar en la interfaz

  bool get isConnected => _isConnected;
  String get message => _message;

  String _previousMessage = ""; // Agregar esta variable para rastrear el mensaje anterior
  bool _showingReconnectedMessage = false; // Estado de bloqueo

  Future<void> checkConnection() async {
    if (_showingReconnectedMessage) return; // Si se está mostrando el mensaje, retorna

    print('Comprobando conexión...');
    String tempMessage = _message; // Almacena el mensaje actual antes de cambiarlo
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        print('Conexión exitosa.');
        _isConnected = true;
        if (tempMessage == 'No hay conexión con el servidor') { // Si el mensaje anterior era de no conexión
          _message = 'De nuevo en línea';
          _showingReconnectedMessage = true; // Establece el bloqueo
          notifyListeners(); // Notifica a los oyentes del cambio en el mensaje
          await Future.delayed(Duration(seconds: 8)); // Espera 8 segundos
          _message = ""; // Luego limpia el mensaje
          _showingReconnectedMessage = false; // Libera el bloqueo
          notifyListeners(); // Notifica a los oyentes del cambio en el mensaje
        } else {
          _message = ""; // Si no había mensaje de error antes, simplemente limpia el mensaje
        }

      } else {
        print('Error en la conexión. Código de estado: ${response.statusCode}');
        _isConnected = false;
        _message = 'No hay conexión con el servidor';
      }
    } catch (e) {
      print('Error en la conexión: $e'); // Log agregado
      _isConnected = false;
      _message = 'No hay conexión con el servidor'; // Mensaje de error
    }
    _previousMessage = tempMessage; // Actualiza el mensaje anterior con el valor temporal
    notifyListeners(); // Notifica a los oyentes del cambio
  }


  Timer? _timer;

  ConnectionStatus() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      print('Verificando la conexión (llamada del temporizador)'); // Log agregado
      checkConnection(); // Comprueba la conexión cada 5 segundos
    });
  }

  Future<List<Compra>> getCompras() async {
    print('Obteniendo compras...');
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      print('Respuesta recibida: ${response.body}');
      List<dynamic> responseData = json.decode(response.body);
      print('Datos decodificados: $responseData');
      List<Compra> compras = responseData.map((data) => Compra.fromJson(data)).toList();
      print('Compras procesadas: $compras');
      return compras;
    } else {
      print('Error al cargar compras, código de estado: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}'); // Log agregado
      throw Exception('Error al cargar compras, código de estado: ${response.statusCode}');
    }
  }



  @override
  void dispose() {
    _timer?.cancel(); // Cancela el temporizador cuando se deshaga del objeto
    super.dispose();
  }
}
