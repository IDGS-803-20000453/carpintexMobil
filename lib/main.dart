import 'dart:async';
import 'dart:io';
import 'package:carpintex/services/api_service.dart';
import 'package:carpintex/views/ConnectionStatus.dart';
import 'package:carpintex/views/compras_list_page.dart';
import 'package:carpintex/views/login.dart'; // Asegúrate de importar la clase Login aquí
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa la biblioteca de SharedPreferences
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
  runApp(
    ChangeNotifierProvider(
      create: (context) => ConnectionStatus(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
    _navigateBasedOnPreferences(); // Llama a la función para la navegación basada en SharedPreferences
  }

  _navigateBasedOnPreferences() async {
    print('Starting intro page, waiting 5 seconds...');
    await Future.delayed(Duration(seconds: 5)); // Espera 5 segundos

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('name');
    String? userEmail = prefs.getString('email');

    // Comprueba si los valores de SharedPreferences son diferentes de los predeterminados
    if (userName != null && userName != 'Nombre de Usuario' && userEmail != null && userEmail != 'email@dominio.com') {
      print('Navigating to Compras List page...');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ComprasConNombresPage(apiService: ComprasApiService()),
        ),
      );
    } else {
      print('Navigating to Login page...');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Login(), // Cambia a la clase Login
        ),
      );
    }
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
