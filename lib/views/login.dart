import 'package:carpintex/services/compras_api_service.dart';
import 'package:carpintex/services/login_api_service.dart';
import 'package:carpintex/services/productos_api_service.dart';
import 'package:carpintex/views/ConnectionStatus.dart';
import 'package:carpintex/views/compras_list_page.dart';
import 'package:carpintex/views/productos_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  LoginApiService apiService = LoginApiService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ConnectionStatus connectionStatus = Provider.of<ConnectionStatus>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Inicio de Sesión'),
        backgroundColor: Color(0xFF483D8B), // Cambia el color del AppBar
      ),

      body: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/source/images/user_login.jpg'),

              SizedBox(height: 20),
              if (!connectionStatus.isConnected)
                Text(connectionStatus.message, style: TextStyle(color: Colors.red))
              else
                Text(connectionStatus.message, style: TextStyle(color: Colors.green)),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  labelStyle: TextStyle(color: Color(0xFF483D8B)), // Cambia el color del indicador
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF483D8B)), // Cambia el color del borde cuando está enfocado
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Color(0xFF483D8B)), // Cambia el color del indicador
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF483D8B)), // Cambia el color del borde cuando está enfocado
                  ),
                ),
              ),

              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  int login = await apiService.login(emailController.text, passwordController.text);

                  String mensaje = 'Inicio de sesión fallido, checa tu usuario y contraseña';
                  if (login == 2) {
                    mensaje = 'Cliente';

                    // Navegar a la página de compras si el usuario es administrador
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductosListPage(apiService: ProductosApiService()), // Redirige a la página de productos
                      ),
                    );

                    // No se mostrará el mensaje de Snackbar para el administrador, ya que hemos navegado a otra página
                    return;
                  } else if (login == 1) {
                    mensaje = 'Administrador';

                    // Navegar a la página de compras si el usuario es administrador
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComprasConNombresPage(apiService: ComprasApiService()),
                      ),
                    );

                    // No se mostrará el mensaje de Snackbar para el administrador, ya que hemos navegado a otra página
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(mensaje),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: Text('Iniciar Sesión'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF483D8B), // Cambia el color del botón
                  shadowColor: Colors.black.withOpacity(0.5), // Sombra del botón
                  elevation: 5, // Elevación para la sombra
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Bordes redondeados
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Relleno interior
                ),
                           ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
