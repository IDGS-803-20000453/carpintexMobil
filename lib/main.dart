import 'dart:async';
import 'dart:io';
import 'package:carpintex/services/api_service.dart';
import 'package:carpintex/views/compras_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/compras_api_service.dart'; // Importa ComprasApiService

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides(); // Usa MyHttpOverrides para deshabilitar la validación SSL
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final ComprasApiService apiService = ComprasApiService(); // Crea una instancia de ComprasApiService

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroPage(),
    );
  }
}

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    print('Starting intro page, waiting 5 seconds...'); // Log antes de la espera
    Future.delayed(Duration(seconds: 5), () {
      print('Navigating to ComprasConNombresPage...'); // Log antes de la navegación
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ComprasConNombresPage(apiService: ComprasApiService()),
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Bienvenido a Carpintex",
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
