import 'package:carpintex/services/productos_api_service.dart';
import 'package:carpintex/views/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carpintex/services/compras_api_service.dart';
import 'package:carpintex/views/compras_list_page.dart';
import 'package:carpintex/views/productos_list_page.dart';


class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  String userName = 'Nombre de Usuario';
  String userEmail = 'email@dominio.com';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'Nombre de Usuario';
      userEmail = prefs.getString('email') ?? 'email@dominio.com';
    });
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpia todos los datos de SharedPreferences
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Login(), // Redirige a la página de inicio de sesión
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userEmail),
            decoration: BoxDecoration(
              color: Color(0xFF483D8B), // Color de fondo morado oscuro
            ),
            // Otros parámetros si los necesitas
          ),

          ListTile(
            title: Text('Productos'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ProductosListPage(apiService: ProductosApiService()), // Redirige a la página de productos
                ),
              );
            },
          ),
          // Agrega más opciones aquí

          ListTile(
            title: Text('Cerrar Sesión'),
            leading: Icon(Icons.logout),
            onTap: _logout, // Llama a la función de cierre de sesión
          ),
        ],
      ),
    );
  }
}
