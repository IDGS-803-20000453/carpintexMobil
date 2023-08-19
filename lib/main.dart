import 'dart:async';
import 'dart:io';
import 'package:carpintex/services/api_service.dart';
import 'package:carpintex/services/productos_api_service.dart';
import 'package:carpintex/views/ConnectionStatus.dart';
import 'package:carpintex/views/compras_list_page.dart';
import 'package:carpintex/views/login.dart'; // Asegúrate de importar la clase Login aquí
import 'package:carpintex/views/productos_list_page.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides(); // MyHttpOverrides para deshabilitar la validación SSL

  // Bloquea la orientación en modo vertical
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ])
      .then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => ConnectionStatus(),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

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
    // Leer el valor del ID de las preferencias compartidas
    int? rol_id = prefs.getInt('rol_id');

    if (rol_id != null) {
      print('Navigating based on user ID...');
      if (rol_id == 1) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ComprasConNombresPage(apiService: ComprasApiService()),
          ),
        );
      } else if (rol_id == 2) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProductosListPage(apiService: ProductosApiService()), // Redirige a la página de productos
          ),
        );
      } else {
        // Redirigir a la página de inicio de sesión si el ID no es 1 o 2
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
      }
    } else {
      // Redirigir a la página de inicio de sesión si el ID es nulo
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Login(),
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
