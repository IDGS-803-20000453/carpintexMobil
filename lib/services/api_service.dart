import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class ApiService {
  Future<List<User>> getRequest() async {
    String url = "https://192.168.137.1:7241/api/Usuario";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<User> users = [];
      for (var userData in responseData) {
        User user = User(
          id: userData["id"],
          name: userData["name"],
          email: userData["email"],
          calle: userData["calle"],
          codigopostal: userData["codigopostal"],
          estado: userData["estado"],
          ciudad: userData["ciudad"],
          passwordUsuario: userData["passwordUsuario"],
          activo: userData["activo"],
        );
        users.add(user);
      }
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> loadCertificate() async {
    // Obtén la ruta del certificado desde los activos
    String certificatePath = 'assets/ca/lets-encrypt-r3.pem';

    // Lee el contenido del certificado
    String certificateData = await rootBundle.loadString(certificatePath);

    // Configura el contexto de seguridad para aceptar el certificado personalizado
    SecurityContext.defaultContext.setTrustedCertificatesBytes(utf8.encode(certificateData));
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String calle;
  final String codigopostal;
  final String estado;
  final String ciudad;
  final String passwordUsuario;
  final bool activo;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.calle,
    required this.codigopostal,
    required this.estado,
    required this.ciudad,
    required this.passwordUsuario,
    required this.activo,
  });
}
