import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginApiService {
  final String baseUrl = 'https://192.168.137.1:7241/api/Usuario';

  Future<int> login(String email, String password) async {
    try {
      print('Intentando iniciar sesión con email: $email y password: $password');

      final response = await http.get(
        Uri.parse('$baseUrl/login/$email?password=$password'),
      );

      final jsonResponse = json.decode(response.body);
      print('Respuesta recibida: $jsonResponse');

      if (response.statusCode == 200) {
        int rolId = jsonResponse['rol_id'] as int;
        print('Inicio de sesión exitoso con rol ID: $rolId');

        // Guardar los datos en SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('id', jsonResponse['id']);
        prefs.setString('name', jsonResponse['name']);
        prefs.setString('email', jsonResponse['email']);
        prefs.setString('passwordUsuario', jsonResponse['passwordUsuario']);
        prefs.setInt('rol_id', jsonResponse['rol_id']);
        return rolId;
      } else if (response.statusCode == 404) {
        print('Error: Usuario no encontrado');
        return 0;
      } else {
        print('Error: Respuesta con código de estado ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error excepcional: $e');
      return 0;
    }
  }
}