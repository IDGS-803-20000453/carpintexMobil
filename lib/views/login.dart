import 'package:carpintex/services/compras_api_service.dart';
import 'package:carpintex/services/login_api_service.dart';
import 'package:carpintex/views/compras_list_page.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  LoginApiService apiService = LoginApiService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inicio de Sesión')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  int login = await apiService.login(emailController.text, passwordController.text);

                  String mensaje = 'Inicio de sesión fallido, checa tu usuario y contraseña';
                  if (login == 2) {
                    mensaje = 'Cliente';
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
